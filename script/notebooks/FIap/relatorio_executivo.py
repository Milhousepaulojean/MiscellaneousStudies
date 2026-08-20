# %% [markdown]
# # RELATÓRIO EXECUTIVO
# ## Impacto da eficiência logística na satisfação e no faturamento
#
# Dataset: Brazilian E-Commerce Public Dataset by Olist
#
# Pergunta norteadora:
# Como a eficiência logística impacta o faturamento dos e-commerces brasileiros?
#
# Este relatório foi estruturado a partir do notebook Ps_Tech2.ipynb.
# Foram mantidos os temas e análises originais, mas foram corrigidos:
#
# - duplicidade causada por junções entre tabelas de diferentes granularidades;
# - soma duplicada de payment_value;
# - uso de linguagem causal sem evidência experimental;
# - ausência de metodologia formal;
# - ausência de limitações estatísticas;
# - ausência de critérios explícitos para receita em risco;
# - falta de consolidação em formato executivo.
#
# O relatório distingue:
#
# - base de pedidos: uma linha por pedido;
# - base de itens: uma linha por item;
# - análise associativa: identifica relações, mas não prova causalidade.

# %%
from pathlib import Path
from datetime import datetime
import base64
import html
import warnings

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

warnings.filterwarnings("ignore")

# ---------------------------------------------------------------------
# Configurações de diretórios
# ---------------------------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "database"
REPORT_DIR = BASE_DIR / "reports"

REPORT_DIR.mkdir(exist_ok=True)

sns.set_theme(style="whitegrid")
plt.rcParams["figure.dpi"] = 110
plt.rcParams["font.family"] = "DejaVu Sans"


# ---------------------------------------------------------------------
# Funções auxiliares
# ---------------------------------------------------------------------

def carregar_csv(nome_arquivo):
    """Carrega um CSV da pasta database."""
    caminho = DATA_DIR / nome_arquivo

    if not caminho.exists():
        raise FileNotFoundError(
            f"Arquivo não encontrado: {caminho}\n"
            "Verifique se os CSVs estão na pasta database."
        )

    return pd.read_csv(caminho)


def formatar_brl(valor):
    """Formata valores em reais no padrão brasileiro."""
    if pd.isna(valor):
        return "R$ 0,00"

    valor = float(valor)
    return f"R$ {valor:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")


def formatar_percentual(valor, casas=1):
    """Formata uma proporção ou percentual."""
    if pd.isna(valor):
        return "0,0%"

    return f"{float(valor):.{casas}f}%".replace(".", ",")


def salvar_grafico(nome):
    """Salva o gráfico atual na pasta reports."""
    caminho = REPORT_DIR / nome
    plt.tight_layout()
    plt.savefig(caminho, dpi=160, bbox_inches="tight", facecolor="white")
    plt.close()
    return caminho


def imagem_base64(caminho):
    """
    Converte uma imagem para base64.
    Isso permite incorporar os gráficos diretamente no HTML final.
    """
    with open(caminho, "rb") as arquivo:
        conteudo = base64.b64encode(arquivo.read()).decode("utf-8")

    return f"data:image/png;base64,{conteudo}"


def anotar_barras(ax, formato="{:.2f}"):
    """Adiciona rótulos às barras de um gráfico."""
    for barra in ax.patches:
        altura = barra.get_height()

        if pd.notna(altura):
            ax.annotate(
                formato.format(altura),
                (
                    barra.get_x() + barra.get_width() / 2,
                    altura
                ),
                ha="center",
                va="bottom",
                xytext=(0, 5),
                textcoords="offset points",
                fontsize=9,
                fontweight="bold",
            )


def verificar_unicidade(df, coluna, nome_tabela):
    """Valida se uma tabela possui uma linha por chave."""
    duplicados = df[coluna].duplicated().sum()

    if duplicados > 0:
        print(
            f"Atenção: {nome_tabela} possui {duplicados} registros "
            f"duplicados para a chave {coluna}."
        )
    else:
        print(f"{nome_tabela}: chave {coluna} sem duplicidades.")


# %% [markdown]
# ---
# ## 1. Carregamento dos dados

# %%
orders = carregar_csv("olist_orders_dataset.csv")
payments = carregar_csv("olist_order_payments_dataset.csv")
reviews = carregar_csv("olist_order_reviews_dataset.csv")
customers = carregar_csv("olist_customers_dataset.csv")
items = carregar_csv("olist_order_items_dataset.csv")
products = carregar_csv("olist_products_dataset.csv")
sellers = carregar_csv("olist_sellers_dataset.csv")

print("Arquivos carregados com sucesso.")
print(f"Pedidos: {orders.shape}")
print(f"Pagamentos: {payments.shape}")
print(f"Avaliações: {reviews.shape}")
print(f"Clientes: {customers.shape}")
print(f"Itens: {items.shape}")


# %% [markdown]
# ---
# ## 2. Preparação e controle de granularidade
#
# A tabela principal da análise financeira será construída no nível do pedido.
# Portanto, haverá apenas uma linha por `order_id`.
#
# Essa decisão evita que:
#
# - pedidos com vários pagamentos sejam repetidos;
# - pedidos com vários itens sejam repetidos;
# - uma mesma receita seja somada várias vezes.
#
# A análise de produtos, categorias e vendedores deve utilizar a tabela de
# itens separadamente.

# %%
# Conversão das datas da tabela de pedidos
colunas_data_orders = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date",
]

for coluna in colunas_data_orders:
    if coluna in orders.columns:
        orders[coluna] = pd.to_datetime(orders[coluna], errors="coerce")

# Verificações iniciais
verificar_unicidade(orders, "order_id", "orders")
verificar_unicidade(customers, "customer_id", "customers")
verificar_unicidade(sellers, "seller_id", "sellers")


# %% [markdown]
# ---
# ## 3. Agregação de pagamentos por pedido
#
# A tabela de pagamentos pode conter mais de uma linha para o mesmo pedido,
# principalmente devido a diferentes formas de pagamento ou parcelas.
#
# O valor financeiro do pedido será calculado pela soma de `payment_value`
# agrupada por `order_id`.

# %%
pagamentos_pedido = (
    payments
    .groupby("order_id", as_index=False)
    .agg(
        payment_value=("payment_value", "sum"),
        payment_installments=("payment_installments", "max"),
        payment_types=(
            "payment_type",
            lambda valores: ", ".join(
                sorted(valores.dropna().astype(str).unique())
            ),
        ),
    )
)

verificar_unicidade(pagamentos_pedido, "order_id", "pagamentos_pedido")


# %% [markdown]
# ---
# ## 4. Consolidação das avaliações por pedido
#
# Algumas avaliações podem apresentar mais de um registro para o mesmo pedido.
# Para preservar uma observação por pedido, será mantida a avaliação mais
# recente disponível.
#
# Essa regra é uma decisão metodológica e deve ser informada no relatório.

# %%
if "review_answer_timestamp" in reviews.columns:
    reviews["review_answer_timestamp"] = pd.to_datetime(
        reviews["review_answer_timestamp"],
        errors="coerce"
    )

if "review_creation_date" in reviews.columns:
    reviews["review_creation_date"] = pd.to_datetime(
        reviews["review_creation_date"],
        errors="coerce"
    )

coluna_data_review = (
    "review_answer_timestamp"
    if "review_answer_timestamp" in reviews.columns
    else "review_creation_date"
)

reviews_ordenadas = reviews.sort_values(
    by=["order_id", coluna_data_review],
    na_position="first"
)

reviews_pedido = (
    reviews_ordenadas
    .drop_duplicates(subset="order_id", keep="last")
    [["order_id", "review_score"]]
)

verificar_unicidade(reviews_pedido, "order_id", "reviews_pedido")


# %% [markdown]
# ---
# ## 5. Construção da base principal: `df_pedidos`
#
# A base principal terá uma linha por pedido.
#
# Ela será utilizada para:
#
# - atraso;
# - satisfação;
# - receita;
# - estado do cliente;
# - perfil de cliente;
# - evolução temporal;
# - retenção exploratória.

# %%
df_pedidos = (
    orders
    .merge(
        pagamentos_pedido,
        on="order_id",
        how="left",
        validate="one_to_one"
    )
    .merge(
        reviews_pedido,
        on="order_id",
        how="left",
        validate="one_to_one"
    )
    .merge(
        customers[
            [
                "customer_id",
                "customer_unique_id",
                "customer_zip_code_prefix",
                "customer_state",
            ]
        ],
        on="customer_id",
        how="left",
        validate="many_to_one"
    )
)

# Verificação obrigatória da granularidade
if df_pedidos["order_id"].duplicated().any():
    raise ValueError(
        "A base df_pedidos possui order_id duplicado. "
        "A análise financeira não pode continuar."
    )

print(f"Linhas na base de pedidos: {len(df_pedidos):,}")
print(f"Pedidos únicos: {df_pedidos['order_id'].nunique():,}")


# %% [markdown]
# ---
# ## 6. Definição das variáveis analíticas
#
# Pedidos sem data de entrega são excluídos das métricas de prazo porque não
# permitem calcular o atraso observado.
#
# Essa exclusão não significa que esses pedidos não sejam relevantes. Eles
# devem ser considerados em uma análise posterior de cancelamento, transporte
# ou falha de entrega.

# %%
df_pedidos["dias_atraso"] = (
    df_pedidos["order_delivered_customer_date"]
    - df_pedidos["order_estimated_delivery_date"]
).dt.days

df_pedidos["foi_atraso"] = df_pedidos["dias_atraso"] > 0

df_pedidos["mes_compra"] = (
    df_pedidos["order_purchase_timestamp"]
    .dt.to_period("M")
    .astype(str)
)

df_entregues = df_pedidos.dropna(
    subset=["order_delivered_customer_date", "dias_atraso"]
).copy()

df_entregues["status_entrega"] = np.where(
    df_entregues["foi_atraso"],
    "Com atraso",
    "No prazo"
)

# Definição operacional de receita em risco
df_entregues["receita_em_risco_flag"] = (
    (df_entregues["foi_atraso"])
    & (df_entregues["review_score"] <= 2)
)

receita_em_risco = df_entregues.loc[
    df_entregues["receita_em_risco_flag"],
    "payment_value"
].sum()

total_pedidos_entregues = len(df_entregues)
pedidos_atrasados = int(df_entregues["foi_atraso"].sum())
taxa_atraso = pedidos_atrasados / total_pedidos_entregues * 100

print(f"Pedidos entregues analisados: {total_pedidos_entregues:,}")
print(f"Pedidos atrasados: {pedidos_atrasados:,}")
print(f"Taxa de atraso: {taxa_atraso:.2f}%")
print(f"Receita associada ao risco: {formatar_brl(receita_em_risco)}")


# %% [markdown]
# ---
# ## 7. Estatísticas de tendência central, dispersão e outliers
#
# De acordo com as aulas de Estatística Essencial para Analytics, a média não
# deve ser usada isoladamente quando a distribuição apresenta assimetria ou
# valores extremos.
#
# Por isso, são apresentados:
#
# - média;
# - mediana;
# - desvio-padrão;
# - primeiro e terceiro quartis;
# - IQR;
# - percentil 90;
# - limites para identificação exploratória de outliers.

# %%
dias_atraso_validos = df_entregues["dias_atraso"].dropna()

q1 = dias_atraso_validos.quantile(0.25)
q3 = dias_atraso_validos.quantile(0.75)
iqr = q3 - q1

limite_inferior = q1 - 1.5 * iqr
limite_superior = q3 + 1.5 * iqr

outliers_atraso = dias_atraso_validos[
    (dias_atraso_validos < limite_inferior)
    | (dias_atraso_validos > limite_superior)
]

estatisticas_atraso = {
    "n": int(dias_atraso_validos.count()),
    "media": dias_atraso_validos.mean(),
    "mediana": dias_atraso_validos.median(),
    "desvio_padrao": dias_atraso_validos.std(),
    "minimo": dias_atraso_validos.min(),
    "maximo": dias_atraso_validos.max(),
    "q1": q1,
    "q3": q3,
    "iqr": iqr,
    "p90": dias_atraso_validos.quantile(0.90),
    "outliers_iqr": len(outliers_atraso),
}

print("\nEstatísticas de atraso:")
for chave, valor in estatisticas_atraso.items():
    print(f"{chave}: {valor}")


# %% [markdown]
# ---
# ## 8. Impacto associado do atraso na satisfação
#
# O resultado abaixo deve ser interpretado como associação:
#
# pedidos atrasados apresentaram determinada avaliação média, enquanto pedidos
# no prazo apresentaram outra avaliação média.
#
# O resultado não prova que o atraso seja o único causador da nota, pois outros
# fatores podem influenciar a avaliação.

# %%
satisfacao = (
    df_entregues
    .dropna(subset=["review_score"])
    .groupby("status_entrega")
    .agg(
        pedidos=("order_id", "nunique"),
        nota_media=("review_score", "mean"),
        nota_mediana=("review_score", "median"),
        desvio_padrao=("review_score", "std"),
        percentual_notas_baixas=(
            "review_score",
            lambda x: (x <= 2).mean() * 100
        ),
    )
    .reset_index()
)

ordem_status = ["No prazo", "Com atraso"]
satisfacao["ordem"] = satisfacao["status_entrega"].map(
    {"No prazo": 0, "Com atraso": 1}
)
satisfacao = satisfacao.sort_values("ordem")

# Gráfico
plt.figure(figsize=(9, 6))
ax = sns.barplot(
    data=satisfacao,
    x="status_entrega",
    y="nota_media",
    hue="status_entrega",
    palette={"No prazo": "#2D6A4F", "Com atraso": "#D90429"},
    legend=False,
)

ax.set_title(
    "Avaliação média segundo o status da entrega",
    fontsize=15,
    fontweight="bold"
)
ax.set_xlabel("Status da entrega")
ax.set_ylabel("Nota média")
ax.set_ylim(0, 5)

anotar_barras(ax, "{:.2f}")
grafico_satisfacao = salvar_grafico("satisfacao_por_status.png")


# %% [markdown]
# ---
# ## 9. Receita associada ao risco por estado
#
# A receita em risco é definida neste relatório como o valor pago em pedidos
# atrasados que receberam nota igual ou inferior a 2.
#
# O indicador representa exposição financeira associada a uma experiência
# negativa. Ele não representa perda efetiva nem previsão de perda futura.

# %%
risco_estado = (
    df_entregues[df_entregues["receita_em_risco_flag"]]
    .groupby("customer_state", as_index=False)
    .agg(
        receita_em_risco=("payment_value", "sum"),
        pedidos_em_risco=("order_id", "nunique"),
    )
    .sort_values("receita_em_risco", ascending=False)
)

plt.figure(figsize=(10, 6))
ax = sns.barplot(
    data=risco_estado.head(10),
    x="receita_em_risco",
    y="customer_state",
    hue="customer_state",
    palette="Reds_r",
    legend=False,
)

ax.set_title(
    "Estados com maior receita associada ao risco",
    fontsize=15,
    fontweight="bold"
)
ax.set_xlabel("Receita associada ao risco")
ax.set_ylabel("Estado")

for barra in ax.patches:
    valor = barra.get_width()

    ax.annotate(
        formatar_brl(valor),
        (valor, barra.get_y() + barra.get_height() / 2),
        ha="left",
        va="center",
        xytext=(5, 0),
        textcoords="offset points",
        fontsize=8,
    )

grafico_estado = salvar_grafico("risco_por_estado.png")


# %% [markdown]
# ---
# ## 10. Perfil do cliente e receita associada ao risco
#
# O perfil é definido no nível do cliente único:
#
# - novo cliente: apenas um pedido na base;
# - recorrente: mais de um pedido na base.
#
# Essa classificação é descritiva e não equivale a uma análise completa de
# Lifetime Value, pois a base possui período histórico limitado.

# %%
frequencia_cliente = (
    df_pedidos
    .groupby("customer_unique_id", as_index=False)
    .agg(total_pedidos=("order_id", "nunique"))
)

df_entregues = df_entregues.merge(
    frequencia_cliente,
    on="customer_unique_id",
    how="left",
    validate="many_to_one"
)

df_entregues["perfil_cliente"] = np.where(
    df_entregues["total_pedidos"] > 1,
    "Cliente recorrente",
    "Novo cliente"
)

risco_perfil = (
    df_entregues[df_entregues["receita_em_risco_flag"]]
    .groupby("perfil_cliente", as_index=False)
    .agg(
        receita_em_risco=("payment_value", "sum"),
        pedidos_em_risco=("order_id", "nunique"),
    )
)

plt.figure(figsize=(9, 6))
ax = sns.barplot(
    data=risco_perfil,
    x="perfil_cliente",
    y="receita_em_risco",
    hue="perfil_cliente",
    palette={
        "Novo cliente": "#D90429",
        "Cliente recorrente": "#F48C06",
    },
    legend=False,
)

ax.set_title(
    "Receita associada ao risco por perfil de cliente",
    fontsize=15,
    fontweight="bold"
)
ax.set_xlabel("Perfil do cliente")
ax.set_ylabel("Receita associada ao risco")

for barra in ax.patches:
    valor = barra.get_height()

    ax.annotate(
        formatar_brl(valor),
        (
            barra.get_x() + barra.get_width() / 2,
            valor
        ),
        ha="center",
        va="bottom",
        xytext=(0, 5),
        textcoords="offset points",
        fontsize=9,
    )

grafico_perfil = salvar_grafico("risco_por_perfil.png")


# %% [markdown]
# ---
# ## 11. Evolução mensal do risco
#
# O gráfico apresenta a evolução mensal da receita associada a pedidos
# atrasados com avaliação baixa.
#
# A existência de um pico mensal não prova, isoladamente, que ele seja causado
# pela Black Friday ou pelo Natal. Essa interpretação exige comparação com
# volume de pedidos, taxa de atraso e sazonalidade de anos diferentes.

# %%
risco_mensal = (
    df_entregues[df_entregues["receita_em_risco_flag"]]
    .groupby("mes_compra", as_index=False)
    .agg(
        receita_em_risco=("payment_value", "sum"),
        pedidos_em_risco=("order_id", "nunique"),
    )
    .sort_values("mes_compra")
)

plt.figure(figsize=(14, 6))
ax = sns.lineplot(
    data=risco_mensal,
    x="mes_compra",
    y="receita_em_risco",
    marker="o",
    color="#D90429",
    linewidth=2.5,
)

ax.set_title(
    "Evolução mensal da receita associada ao risco",
    fontsize=15,
    fontweight="bold"
)
ax.set_xlabel("Mês da compra")
ax.set_ylabel("Receita associada ao risco")
plt.xticks(rotation=45)

grafico_mensal = salvar_grafico("risco_mensal.png")


# %% [markdown]
# ---
# ## 12. Retenção exploratória após a primeira experiência
#
# A análise identifica se o cliente realizou mais de um pedido na base.
#
# Essa métrica não prova que a nota causou ou impediu a recompra, porque:
#
# - não há controle experimental;
# - não foi aplicada uma janela fixa após a primeira compra;
# - clientes que compraram no final do período tiveram menos tempo para retornar;
# - outros fatores podem explicar a recompra.

# %%
df_cliente_ordem = df_pedidos.sort_values(
    ["customer_unique_id", "order_purchase_timestamp"]
).copy()

primeiro_pedido = (
    df_cliente_ordem
    .drop_duplicates("customer_unique_id", keep="first")
    [["customer_unique_id", "review_score"]]
)

contagem_pedidos = (
    df_pedidos
    .groupby("customer_unique_id", as_index=False)
    .agg(total_pedidos=("order_id", "nunique"))
)

retencao = primeiro_pedido.merge(
    contagem_pedidos,
    on="customer_unique_id",
    how="left",
    validate="one_to_one"
)

retencao["voltou_a_comprar"] = retencao["total_pedidos"] > 1

retencao["satisfacao_inicial"] = np.select(
    [
        retencao["review_score"] <= 3,
        retencao["review_score"] == 4,
        retencao["review_score"] == 5,
    ],
    [
        "Notas 1 a 3",
        "Nota 4",
        "Nota 5",
    ],
    default="Sem avaliação",
)

taxa_retorno = (
    retencao[retencao["satisfacao_inicial"] != "Sem avaliação"]
    .groupby("satisfacao_inicial", as_index=False)
    .agg(
        clientes=("customer_unique_id", "nunique"),
        taxa_retorno=("voltou_a_comprar", "mean"),
    )
)

taxa_retorno["taxa_retorno_percentual"] = (
    taxa_retorno["taxa_retorno"] * 100
)

ordem_retorno = {
    "Notas 1 a 3": 0,
    "Nota 4": 1,
    "Nota 5": 2,
}

taxa_retorno["ordem"] = taxa_retorno["satisfacao_inicial"].map(
    ordem_retorno
)
taxa_retorno = taxa_retorno.sort_values("ordem")

plt.figure(figsize=(9, 6))
ax = sns.barplot(
    data=taxa_retorno,
    x="satisfacao_inicial",
    y="taxa_retorno_percentual",
    hue="satisfacao_inicial",
    palette=["#D90429", "#F48C06", "#2D6A4F"],
    legend=False,
)

ax.set_title(
    "Retorno observado segundo a avaliação da primeira experiência",
    fontsize=15,
    fontweight="bold"
)
ax.set_xlabel("Avaliação da primeira experiência")
ax.set_ylabel("Clientes com mais de um pedido (%)")

for barra in ax.patches:
    valor = barra.get_height()

    ax.annotate(
        formatar_percentual(valor, 2),
        (
            barra.get_x() + barra.get_width() / 2,
            valor
        ),
        ha="center",
        va="bottom",
        xytext=(0, 5),
        textcoords="offset points",
        fontsize=9,
    )

grafico_retorno = salvar_grafico("retorno_por_satisfacao.png")


# %% [markdown]
# ---
# ## 13. Relatório executivo em HTML
#
# O HTML utiliza uma estrutura visual inspirada nas recomendações de
# apresentação acadêmica:
#
# - papel A4;
# - margem superior e esquerda de 3 cm;
# - margem inferior e direita de 2 cm;
# - fonte Times New Roman;
# - corpo em tamanho 12;
# - espaçamento de 1,5;
# - texto justificado;
# - títulos numerados;
# - tabelas com identificação;
# - figuras com legenda e fonte.
#
# A ABNT não determina um modelo único de dashboard executivo. Portanto, as
# regras abaixo são uma adaptação acadêmica para o relatório analítico.

# %%
nota_no_prazo = satisfacao.loc[
    satisfacao["status_entrega"] == "No prazo",
    "nota_media"
].iloc[0] if "No prazo" in satisfacao["status_entrega"].values else np.nan

nota_atraso = satisfacao.loc[
    satisfacao["status_entrega"] == "Com atraso",
    "nota_media"
].iloc[0] if "Com atraso" in satisfacao["status_entrega"].values else np.nan

diferenca_nota = nota_no_prazo - nota_atraso

mediana_atraso = estatisticas_atraso["mediana"]
p90_atraso = estatisticas_atraso["p90"]

percentual_pedidos_sem_entrega = (
    orders["order_delivered_customer_date"].isna().mean() * 100
)

data_geracao = datetime.now().strftime("%d/%m/%Y às %H:%M")

tabela_satisfacao = satisfacao[
    [
        "status_entrega",
        "pedidos",
        "nota_media",
        "nota_mediana",
        "desvio_padrao",
        "percentual_notas_baixas",
    ]
].copy()

tabela_satisfacao.columns = [
    "Status da entrega",
    "Pedidos",
    "Nota média",
    "Nota mediana",
    "Desvio-padrão",
    "Notas baixas (%)",
]

tabela_satisfacao_html = tabela_satisfacao.to_html(
    index=False,
    classes="tabela",
    float_format=lambda valor: f"{valor:.2f}".replace(".", ",")
)

tabela_estados_html = risco_estado.head(10).copy()
tabela_estados_html["receita_em_risco"] = (
    tabela_estados_html["receita_em_risco"]
    .map(formatar_brl)
)

tabela_estados_html = tabela_estados_html.rename(
    columns={
        "customer_state": "Estado",
        "receita_em_risco": "Receita associada ao risco",
        "pedidos_em_risco": "Pedidos em risco",
    }
)[
    [
        "Estado",
        "Receita associada ao risco",
        "Pedidos em risco",
    ]
].to_html(
    index=False,
    classes="tabela"
)

def figura_html(caminho, numero, titulo):
    imagem = imagem_base64(caminho)

    return f"""
    <figure>
        <img src="{imagem}" alt="{html.escape(titulo)}">
        <figcaption>
            Figura {numero} — {html.escape(titulo)}.
            Fonte: elaboração própria com base nos dados da Olist.
        </figcaption>
    </figure>
    """


html_relatorio = f"""
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">

<title>
Relatório Executivo — Eficiência Logística e Faturamento
</title>

<style>

@page {{
    size: A4;
    margin: 3cm 2cm 2cm 3cm;
}}

body {{
    font-family: "Times New Roman", Times, serif;
    font-size: 12pt;
    line-height: 1.5;
    text-align: justify;
    color: #222;
    background: white;
}}

h1, h2, h3 {{
    font-family: "Times New Roman", Times, serif;
    text-align: left;
}}

h1 {{
    text-align: center;
    font-size: 18pt;
    margin-top: 80px;
    margin-bottom: 40px;
}}

h2 {{
    font-size: 14pt;
    margin-top: 28px;
    margin-bottom: 12px;
}}

h3 {{
    font-size: 12pt;
    margin-top: 20px;
}}

.capa {{
    text-align: center;
    page-break-after: always;
}}

.capa p {{
    text-align: center;
}}

.resumo-executivo {{
    border: 1px solid #999;
    padding: 15px;
    margin: 18px 0;
}}

.kpi {{
    border: 1px solid #bbb;
    padding: 10px;
    margin: 8px 0;
    background-color: #f7f7f7;
}}

.kpi strong {{
    font-size: 14pt;
}}

.tabela {{
    border-collapse: collapse;
    width: 100%;
    margin: 12px 0 5px 0;
    font-size: 10pt;
}}

.tabela th,
.tabela td {{
    border: 1px solid #777;
    padding: 6px;
}}

.tabela th {{
    background-color: #eaeaea;
    text-align: center;
}}

.tabela td {{
    text-align: left;
}}

figure {{
    text-align: center;
    margin: 22px 0;
    page-break-inside: avoid;
}}

figure img {{
    max-width: 100%;
    height: auto;
}}

figcaption {{
    font-size: 10pt;
    text-align: center;
    margin-top: 5px;
}}

.nota-metodologica {{
    background-color: #f5f5f5;
    border-left: 4px solid #555;
    padding: 12px;
    margin: 15px 0;
}}

ul {{
    margin-top: 5px;
}}

.referencia {{
    text-align: left;
    margin-left: 0;
    text-indent: -1.25cm;
    padding-left: 1.25cm;
    margin-bottom: 8px;
}}

.page-break {{
    page-break-before: always;
}}

</style>
</head>

<body>

<section class="capa">
    <p><strong>RELATÓRIO EXECUTIVO</strong></p>
    <p>DATA ANALYTICS</p>

    <h1>
        Impacto da eficiência logística na satisfação e no faturamento
    </h1>

    <p>
        Análise exploratória do Brazilian E-Commerce Public Dataset by Olist
    </p>

    <br><br><br>

    <p>JULIA AYUMI SUZUKI</p>
    <p>Pâmela Cristina da Silva</p>
    <p>LARISSA NICOLI RODRIGUES</p>
    <p>Matheus Silva de Jesus</p>
    <p>Paulo Jean Alves da Silva</p>
    <p>São Paulo</p>
    <p>{datetime.now().year}</p>
</section>

<h2>Resumo executivo</h2>

<div class="resumo-executivo">
<p>
Este relatório analisa a associação entre desempenho logístico, satisfação do
cliente e exposição financeira no comércio eletrônico brasileiro. A unidade
principal de análise foi o pedido, garantindo que o valor pago não fosse
contabilizado repetidamente em razão da existência de múltiplos pagamentos,
avaliações ou itens.
</p>

<p>
A receita associada ao risco foi definida como o valor pago em pedidos entregues
com atraso e avaliados com nota igual ou inferior a 2. Essa definição representa
uma exposição financeira associada a uma experiência negativa, mas não equivale
a uma perda efetiva nem permite estimar, isoladamente, o faturamento futuro.
</p>

<p>
Os resultados devem ser interpretados como evidências descritivas e associativas.
Eles apoiam a priorização de investigações logísticas, mas não comprovam que o
atraso seja o único responsável pela insatisfação ou pela ausência de recompra.
</p>
</div>

<div class="kpi">
<strong>{total_pedidos_entregues:,}</strong><br>
pedidos entregues considerados na análise.
</div>

<div class="kpi">
<strong>{formatar_percentual(taxa_atraso)}</strong><br>
taxa de pedidos atrasados.
</div>

<div class="kpi">
<strong>{formatar_brl(receita_em_risco)}</strong><br>
receita associada ao risco operacional.
</div>

<h2>1 Objetivos</h2>

<h3>1.1 Objetivo geral</h3>

<p>
Analisar como o desempenho logístico está associado à satisfação dos clientes e
à exposição financeira da operação de comércio eletrônico.
</p>

<h3>1.2 Objetivos específicos</h3>

<ul>
<li>Comparar a satisfação de pedidos entregues no prazo e com atraso;</li>
<li>estimar a receita associada a pedidos atrasados com avaliações baixas;</li>
<li>identificar estados com maior concentração de exposição financeira;</li>
<li>examinar a distribuição dos atrasos e seus valores extremos;</li>
<li>analisar diferenças descritivas entre clientes novos e recorrentes;</li>
<li>avaliar, de forma exploratória, a relação entre primeira avaliação e retorno.</li>
</ul>

<h2>2 Metodologia</h2>

<p>
A análise foi desenvolvida com Python, utilizando as bibliotecas Pandas,
NumPy, Matplotlib e Seaborn. Foram utilizadas as tabelas de pedidos,
pagamentos, avaliações, clientes, itens, produtos e vendedores do conjunto de
dados público da Olist.
</p>

<h3>2.1 Unidade de análise</h3>

<p>
A análise financeira e de satisfação foi realizada no nível do pedido, com uma
linha por <code>order_id</code>. Pagamentos foram agregados por pedido e as
avaliações foram consolidadas, mantendo-se o registro mais recente disponível.
</p>

<p>
A análise de produtos, categorias e vendedores deve ser realizada no nível dos
itens. Essas duas granularidades não devem ser misturadas quando houver soma de
valores financeiros do pedido.
</p>

<h3>2.2 Definição de atraso</h3>

<p>
Um pedido foi classificado como atrasado quando a data efetiva de entrega ao
cliente foi posterior à data estimada de entrega:
<strong>dias de atraso > 0</strong>.
</p>

<h3>2.3 Definição de receita associada ao risco</h3>

<p>
Foi considerado associado ao risco o valor pago em pedidos que atenderam
simultaneamente às condições de atraso e avaliação igual ou inferior a 2.
</p>

<div class="nota-metodologica">
<strong>Nota metodológica:</strong>
essa métrica não representa perda financeira comprovada, churn, LTV ou ROI.
Ela representa uma medida descritiva de exposição financeira associada a uma
experiência operacional negativa.
</div>

<h3>2.4 Tratamento estatístico</h3>

<p>
Foram utilizadas média, mediana, desvio-padrão, quartis, intervalo
interquartílico e percentil 90. A mediana e os percentis foram incluídos porque
tempos de entrega podem apresentar assimetria e valores extremos.
</p>

<h2>3 Resultados</h2>

<h3>3.1 Desempenho da entrega e satisfação</h3>

<p>
A avaliação média dos pedidos entregues no prazo foi de
<strong>{nota_no_prazo:.2f}</strong>, enquanto a avaliação média dos pedidos
atrasados foi de <strong>{nota_atraso:.2f}</strong>.
</p>

<p>
A diferença descritiva entre os grupos foi de
<strong>{diferenca_nota:.2f} ponto(s)</strong>. Esse resultado indica uma
associação entre atraso e menor avaliação média na base analisada. Entretanto,
não permite afirmar que o atraso seja a única causa da avaliação, pois fatores
como produto, preço, frete, atendimento e expectativa do cliente também podem
influenciar a nota.
</p>

{figura_html(grafico_satisfacao, 1, "Avaliação média segundo o status da entrega")}

<h3>3.2 Estatísticas de atraso, dispersão e outliers</h3>

<p>
O atraso apresentou mediana de
<strong>{mediana_atraso:.1f} dia(s)</strong> e percentil 90 de
<strong>{p90_atraso:.1f} dia(s)</strong>. O percentil 90 indica o valor abaixo
do qual se encontram aproximadamente 90% das observações válidas de prazo.
</p>

<p>
Foram identificadas, pelo critério exploratório do IQR, 
<strong>{estatisticas_atraso["outliers_iqr"]:,}</strong> observações
potencialmente extremas. Esses registros não foram removidos automaticamente,
porque um outlier pode representar erro, evento excepcional ou ocorrência real
de interesse operacional.
</p>

<h3>3.3 Exposição financeira por estado</h3>

<p>
Os estados com maior valor absoluto de receita associada ao risco estão
apresentados abaixo. A concentração em determinado estado pode refletir tanto
maior risco relativo quanto maior volume de pedidos. Por isso, a decisão
gerencial deve considerar também taxas proporcionais, e não apenas valores
absolutos.
</p>

{figura_html(grafico_estado, 2, "Estados com maior receita associada ao risco")}

{tabela_estados_html}

<p>
Tabela 1 — Estados com maior receita associada ao risco.
Fonte: elaboração própria com base nos dados da Olist.
</p>

<h3>3.4 Perfil do cliente</h3>

<p>
A segmentação entre novo cliente e cliente recorrente foi construída com base
na quantidade de pedidos observados por <code>customer_unique_id</code>.
Clientes com mais de um pedido foram classificados como recorrentes.
</p>

<p>
Essa classificação não equivale a uma segmentação completa de clientes VIP,
pois não considera margem, frequência mensal, ticket médio, tempo entre
compras ou valor de vida do cliente.
</p>

{figura_html(grafico_perfil, 3, "Receita associada ao risco por perfil de cliente")}

<h3>3.5 Evolução mensal</h3>

<p>
A evolução mensal permite observar períodos de maior concentração da receita
associada ao risco. Porém, um pico mensal não deve ser atribuído diretamente à
Black Friday, ao Natal ou a outro evento sem uma comparação formal com volume
de pedidos, taxa de atraso e períodos equivalentes.
</p>

{figura_html(grafico_mensal, 4, "Evolução mensal da receita associada ao risco")}

<h3>3.6 Retenção exploratória</h3>

<p>
A recompra foi aproximada pela existência de mais de um pedido para o mesmo
cliente único na base histórica. Essa medida é exploratória, pois não controla
a janela de observação. Clientes que compraram no final do período tiveram
menos tempo disponível para realizar uma nova compra.
</p>

{figura_html(grafico_retorno, 5, "Retorno observado segundo a avaliação inicial")}

<h2>4 Recomendações executivas</h2>

<ol>
<li>
<strong>Priorizar a investigação dos pedidos atrasados com notas baixas.</strong>
Esse grupo combina uma falha operacional observada com uma experiência negativa
do cliente.
</li>

<li>
<strong>Monitorar a mediana e o percentil 90 do prazo.</strong>
A média isolada pode esconder instabilidade e valores extremos.
</li>

<li>
<strong>Separar risco absoluto de risco relativo por estado.</strong>
Estados com maior faturamento podem apresentar maior risco absoluto apenas por
terem maior volume de pedidos.
</li>

<li>
<strong>Construir uma análise de coorte para recompra.</strong>
A comparação deve considerar clientes cuja primeira compra ocorreu em períodos
semelhantes e uma janela fixa de acompanhamento.
</li>

<li>
<strong>Investigar rotas, vendedores e etapas logísticas.</strong>
O relatório identifica associações; a identificação da causa operacional exige
análises adicionais por vendedor, região, prazo prometido, etapa de postagem e
transporte.
</li>

<li>
<strong>Evitar o uso do termo ROI.</strong>
Para calcular ROI seriam necessários os custos das ações corretivas e o retorno
financeiro incremental obtido após a intervenção.
</li>
</ol>

<h2>5 Limitações</h2>

<ul>
<li>
A base representa um período histórico específico e não necessariamente o
cenário atual da operação.
</li>

<li>
Pedidos sem data de entrega foram excluídos da análise de atraso, podendo
introduzir viés de seleção.
</li>

<li>
Correlação e associação não comprovam causalidade.
</li>

<li>
Não foram identificados custos de intervenção logística, portanto não foi
calculado ROI.
</li>

<li>
A recompra não foi analisada por coorte ou janela temporal fixa.
</li>

<li>
Outliers foram identificados, mas não excluídos automaticamente.
</li>

<li>
A existência de maior receita em risco em um estado não significa,
necessariamente, que esse estado tenha a pior performance relativa.
</li>
</ul>

<h2>6 Conclusão</h2>

<p>
A análise indica uma associação relevante entre atraso na entrega e redução da
avaliação média dos pedidos. Também foi possível identificar uma exposição
financeira associada a pedidos atrasados que receberam avaliações baixas.
</p>

<p>
Os resultados sugerem que a eficiência logística deve ser tratada como uma
dimensão estratégica da experiência do cliente e da proteção da receita. No
entanto, as evidências apresentadas são descritivas e observacionais. Portanto,
a recomendação é utilizar o relatório como instrumento de priorização e
diagnóstico, e não como prova definitiva de causalidade ou previsão de
faturamento futuro.
</p>

<p>
Para fortalecer a tomada de decisão, a próxima etapa deve incluir análises de
coorte, segmentação por vendedor e rota, controle de sazonalidade, comparação
de taxas relativas e, quando possível, um teste-piloto de intervenção logística.
</p>

<h2>Referências</h2>

<p class="referencia">
OLIST. <strong>Brazilian E-Commerce Public Dataset by Olist</strong>.
Conjunto de dados utilizado na análise. Disponível em repositório público.
Acesso em: {datetime.now().strftime("%d %b. %Y")}.
</p>

<p class="referencia">
POSTECH. <strong>Estatística Essencial para Analytics: Aula 1 —
Papel da estatística na análise de dados e na tomada de decisão</strong>.
Material didático da disciplina. 2025.
</p>

<p class="referencia">
POSTECH. <strong>Estatística Essencial para Analytics: Aula 2 —
Tipos de variáveis e escalas de medição</strong>.
Material didático da disciplina. 2025.
</p>

<p class="referencia">
POSTECH. <strong>Estatística Essencial para Analytics: Aula 3 —
População, amostra e amostragem</strong>.
Material didático da disciplina. 2025.
</p>

<p class="referencia">
POSTECH. <strong>Estatística Essencial para Analytics: Aula 4 —
Medidas de tendência central</strong>.
Material didático da disciplina. 2025.
</p>

<p class="referencia">
POSTECH. <strong>Estatística Essencial para Analytics: Aula 5 —
Medidas de dispersão</strong>.
Material didático da disciplina. 2026.
</p>

<p class="referencia">
POSTECH. <strong>Estatística Essencial para Analytics: Aula 6 —
Identificação de outliers e distribuição dos dados</strong>.
Material didático da disciplina. 2025.
</p>

<p style="font-size: 10pt; margin-top: 30px;">
Relatório gerado em {data_geracao}.
</p>

</body>
</html>
"""

caminho_html = REPORT_DIR / "relatorio_executivo.html"

with open(caminho_html, "w", encoding="utf-8") as arquivo:
    arquivo.write(html_relatorio)

print(f"\nRelatório HTML gerado em: {caminho_html}")
# %%
from weasyprint import HTML

caminho_pdf = REPORT_DIR / "relatorio_executivo.pdf"

HTML(
    filename=str(caminho_html),
    base_url=str(REPORT_DIR)
).write_pdf(str(caminho_pdf))

print(f"PDF gerado em: {caminho_pdf}")