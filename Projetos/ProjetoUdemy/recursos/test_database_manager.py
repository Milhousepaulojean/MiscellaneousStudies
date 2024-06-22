import pytest
from database_manager import DatabaseManager, Cliente
import sqlite3
from faker import Faker
fake = Faker()


@pytest.fixture(scope="function")
def db_manager():
    return DatabaseManager("users.db")

@pytest.fixture
def conn(db_manager):
    return db_manager.create_connection()

@pytest.fixture
def close(self):
    if self.connection:
        self.connection.close()

def test_create_connection(conn):
    assert conn is not None
    assert isinstance(conn, sqlite3.Connection)

def test_incluir_cliente(db_manager):
    
    # Gerar dados fictícios para o objeto Cliente
    cliente = Cliente(
        fake.name(),
        fake.email(),
        "1234567890",
        fake.address().replace("\n", ", "),
        fake.city(),
        fake.state(),
        "12345-678",
        fake.date(),
        fake.date_of_birth(minimum_age=18, maximum_age=90).strftime("%Y-%m-%d")
    )
    
    # Chama o método para incluir o cliente no banco de dados
    result = db_manager.incluir_cliente(cliente)
    
    # Verifica se o resultado é um inteiro positivo (o ID do cliente inserido)
    assert isinstance(result, int)
    assert result > 0
