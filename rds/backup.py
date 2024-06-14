import subprocess
import psycopg2

host = 'localhost'
user = 'postgres'
password = 'nopassword'
backup_file_path = '/home/caleb/Desktop/Workspace/scripts/rds/backup.sql'

try:
    conn = psycopg2.connect(host=host, user=user, password=password)
    print('Connection successful')

    pg_dumpall_cmd = f'pg_dumpall -h {host} -U {user} -f {backup_file_path}'
    subprocess.run(pg_dumpall_cmd, shell=True, check=True)

    print(f"Backup of database {host} successful created at {backup_file_path}")



#     cursor = conn.cursor()
#
#     cursor.execute('SELECT datname FROM pg_database;')
#
#     databases = cursor.fetchall()
#
#     print('Databases:')
#     for db in databases:
#         print(db[0])
#
except psycopg2.Error as e:
    print('Error: Could not make connection to the Postgres database')
    print(e)

finally:
    if cursor:
        cursor.close()
        print('Connection closed')
    if conn:
        conn.close()
        print('Database connection closed')