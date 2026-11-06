import os
import time
import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Flask, request, jsonify

app = Flask(__name__)

# Strictly discovered from ConfigMap and Secret via envFrom
DB_HOST = os.environ["DB_HOST"]
DB_PORT = os.environ["DB_PORT"]
DB_NAME = os.environ["DB_NAME"]
DB_USER = os.environ["DB_USER"]
DB_PASS = os.environ["DB_PASS"]
BACKEND_PORT = int(os.environ["BACKEND_PORT"])

def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )

def init_db():
    retries = 10
    while retries > 0:
        try:
            conn = get_db_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    CREATE TABLE IF NOT EXISTS task_records (
                        id SERIAL PRIMARY KEY,
                        task_name VARCHAR(255) NOT NULL,
                        saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    );
                """)
            conn.commit()
            conn.close()
            print("Database table 'task_records' initialized successfully.")
            return
        except Exception as e:
            print(f"Waiting for database... ({e})")
            retries -= 1
            time.sleep(3)

init_db()

@app.route('/api/records', methods=['GET'])
def get_records():
    try:
        conn = get_db_connection()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT id, task_name, TO_CHAR(saved_at, 'YYYY-MM-DD HH24:MI:SS') AS saved_at 
                FROM task_records 
                ORDER BY id DESC;
            """)
            records = cur.fetchall()
        conn.close()
        return jsonify(records), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/records', methods=['POST'])
def save_record():
    data = request.get_json() or {}
    task_name = data.get('task_name', '').strip()
    if not task_name:
        return jsonify({"error": "Task name is required"}), 400

    try:
        conn = get_db_connection()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(
                "INSERT INTO task_records (task_name) VALUES (%s) RETURNING id, task_name, TO_CHAR(saved_at, 'YYYY-MM-DD HH24:MI:SS') AS saved_at;",
                (task_name,)
            )
            new_record = cur.fetchone()
        conn.commit()
        conn.close()
        return jsonify(new_record), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=BACKEND_PORT)
