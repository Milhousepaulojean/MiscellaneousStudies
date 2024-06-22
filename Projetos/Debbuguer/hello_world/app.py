import pymysql

# Função Lambda
def lambda_handler(event, context):
    # Configurações de conexão com o MySQL local
    db_host = 'host.docker.internal'
    db_user = 'testuser'
    db_password = 'testpassword'
    db_name = 'mydatabase'

    # Tentar conectar ao MySQL
    try:
        conn = pymysql.connect(host=db_host, user=db_user, password=db_password, database=db_name, port = 3306, cursorclass=pymysql.cursors.DictCursor
)
        
        # Criar um cursor para executar consultas SQL
        with conn.cursor() as cursor:
            # Exemplo de consulta SQL simples para obter um resultado
            sql_query = "SELECT * from helloworld;"
            cursor.execute(sql_query)
            result = cursor.fetchone()
            
            # Fechar a conexão com o MySQL
            conn.close()
            
            # Retorna o resultado da consulta
            return {
                'statusCode': 200,
                'body': result['message']
            }
    
    except pymysql.MySQLError as e:
        # Em caso de erro na conexão ou consulta
        return {
            'statusCode': 500,
            'body': f'Erro ao acessar o MySQL: {str(e)}'
        }

