import sqlite3
from sqlite3 import Error
import re
from datetime import datetime

class Cliente:

        
    def __init__(self, nome, email, telefone, endereco, cidade, estado, cep, datacadastro, datanascimento):
        self.nome = nome
        self.email = email
        self.telefone = telefone
        self.endereco = endereco
        self.cidade = cidade
        self.estado = estado
        self.cep = cep
        self.datacadastro = datacadastro
        self.datanascimento = datanascimento
        
    def to_dict(self):
        return {
            "nome": self.nome,
            "email": self.email,
            "telefone": self.telefone,
            "endereco": self.endereco,
            "cidade": self.cidade,
            "estado": self.estado,
            "cep": self.cep,
            "datacadastro": self.datacadastro,
            "datanascimento": self.datanascimento
        }

class DatabaseManager:
    def __init__(self, db_file=":memory:"):
        self.db_file = db_file
        self.conn = self.create_connection()

    def create_connection(self):
        try:
            conn = sqlite3.connect(self.db_file)
            return conn
        except Error as e:
            print(e)
        return None
    
    def close_connection(self):
        if self.connection:
            self.connection.close()
            self.connection = None

    def incluir_cliente(self, cliente):
        """
        Inclui um cliente no banco de dados.

        Args:
            cliente (Cliente): O objeto cliente a ser incluído.

        Returns:
            int or str: O ID do cliente inserido ou uma mensagem de erro em caso de falha.
        """
        if not self.validar_cliente(cliente):
            return "Falha na validação dos dados do cliente."

        try:
            sql = ''' INSERT INTO users(nome,email,telefone,endereco,cidade,estado,cep,datacadastro,datanascimento)
                      VALUES(?,?,?,?,?,?,?,?,?) '''
                      
            cur = self.conn.cursor()
            cur.execute(sql, (cliente.nome, cliente.email, cliente.telefone, cliente.endereco, cliente.cidade, cliente.estado, cliente.cep, cliente.datacadastro, cliente.datanascimento))
            self.conn.commit()
            return cur.lastrowid
        except Error as e:
            print(e)
            return "Erro ao inserir o cliente no banco de dados."

    def verificar_cliente(self, id):
        try:
            cur = self.conn.cursor()
            cur.execute("SELECT * FROM users WHERE id=?", (id,))
            row = cur.fetchone()
            return row
        except Error as e:
            print(e)
            return "Erro ao buscar o cliente."

    def atualizar_cliente(self, id, campo, valor):
        if not self.validar_id(id):
            return "ID inválido ou inexistente."

        try:
            sql = f"UPDATE users SET {campo} = ? WHERE id = ?"
            cur = self.conn.cursor()
            cur.execute(sql, (valor, id))
            self.conn.commit()
            return cur.rowcount
        except Error as e:
            print(e)
            return "Erro ao atualizar o cliente."

    def validar_cliente(self, cliente):
        if any([not cliente.nome, not cliente.email, not cliente.telefone, not cliente.endereco, not cliente.cidade, not cliente.estado, not cliente.cep, not cliente.datacadastro, not cliente.datanascimento]):
            return False

        if not re.match(r"[^@]+@[^@]+\.[^@]+", cliente.email):
            return False

        try:
            datetime.strptime(cliente.datacadastro, '%Y-%m-%d')
            datetime.strptime(cliente.datanascimento, '%Y-%m-%d')
        except ValueError:
            return False

        return True

    def validar_id(self, id):
        try:
            cur = self.conn.cursor()
            cur.execute("SELECT * FROM users WHERE id=?", (id,))
            row = cur.fetchone()
            return bool(row)
        except Error as e:
            print(e)
            return False
