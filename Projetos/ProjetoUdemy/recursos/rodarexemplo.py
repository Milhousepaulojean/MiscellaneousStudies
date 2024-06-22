import pytest
from database_manager import DatabaseManager, Cliente
from faker import Faker
fake = Faker()
db_manager = DatabaseManager('./users.db')

#incluir cliente
cliente_novo = Cliente(
        fake.name(),
        fake.email(),
        "1234567890",
        fake.address().replace("\n", ", "),
        fake.city(),
        fake.state(),
        "12345-678",
        fake.date(),
        fake.date_of_birth(minimum_age=18, maximum_age=90).strftime("%Y-%m-%d"))


# resultado_inclusao = db_manager.incluir_cliente(cliente_novo)
# print("Resultado da inclusão:", resultado_inclusao)

##verificar cliente
id_cliente = 6
cliente_encontrado = db_manager.verificar_cliente(id_cliente)
if cliente_encontrado:
    print("Cliente encontrado:", cliente_encontrado)
else:
    print("Cliente não encontrado com ID:", id_cliente)

#atualizar cliente
id_cliente_para_atualizar = 1
campo_para_atualizar = "email"  
novo_valor = "newemail@example.com"
resultado_atualizacao = db_manager.atualizar_cliente(id_cliente_para_atualizar, campo_para_atualizar, novo_valor)
if resultado_atualizacao > 0:
    print("Cliente atualizado com sucesso.")
else:
    print("Atualização falhou.")
