# https://docs.snowflake.com/en/user-guide/python-connector-install.html
# pip install --upgrade snowflake-sqlalchemy

from sqlalchemy import create_engine
from snowflake.connector.pandas_tools import write_pandas, pd_writer
import pandas as pd
import json

with open('snowflake.json', 'r') as f:
    creds = json.load(f)

engine = create_engine(
    'snowflake://{user}:{password}@{account_identifier}/{db}/{schema}?warehouse={warehouse}'.format(
        user=creds['user'],
        password=creds['password'],
        account_identifier=creds['account'],
        db=creds['database'],
        schema=creds['schema'],
        warehouse=creds['warehouse']
    )
)
try:
    connection = engine.connect()
    results = connection.execute('select current_version()').fetchone()
    print(results[0])
except e:
    print(e)


df = pd.read_csv("iris.csv")
df.columns = map(lambda x: str(x).upper(), df.columns)

try:
    df.to_sql('iris', con=connection, index=False, method=pd_writer, if_exists='append')
except e:
    print(e)
finally:
    connection.close()
    engine.close()

    