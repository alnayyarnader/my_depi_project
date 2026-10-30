import os
from flask import Flask, jsonify, request
import psycopg2

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST", "database-service"),
        database=os.environ.get("DB_NAME", "postgres"),
        user=os.environ.get("DB_USER", "postgres"),
        password=os.environ.get("DB_PASSWORD", "postgres")
    )
    return conn

# Automatically create the table if it doesn't exist on startup
def init_db():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS time_records (
                id SERIAL PRIMARY KEY,
                saved_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
            );
        ''')
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Database init error: {e}")

init_db()

@app.route('/api/records', methods=['GET'])
def get_records():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT id, saved_at FROM time_records ORDER BY saved_at DESC LIMIT 10;')
    rows = cur.fetchall()
    cur.close()
    conn.close()
    
    records = [{"id": row[0], "saved_at": row[1].strftime("%Y-%m-%d %H:%M:%S")} for row in rows]
    return jsonify(records)

@app.route('/api/records', methods=['POST'])
def add_record():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('INSERT INTO time_records DEFAULT VALUES RETURNING id, saved_at;')
    new_record = cur.fetchone()
    conn.commit()
    cur.close()
    conn.close()
    
    return jsonify({"id": new_record[0], "saved_at": new_record[1].strftime("%Y-%m-%d %H:%M:%S")}), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
