import json

from flask import Flask, Response
from flask import request, render_template, g
import mysql.connector

from config import Config
from message import Message


app = Flask(__name__)
app.config.from_object(Config)


@app.before_request
def before_request():
    g.db = mysql.connector.connect(
        database=Config.MYSQL_DBNAME,
        user=Config.MYSQL_USER,
        password=Config.MYSQL_PASSWORD,
        host=Config.MYSQL_HOST
    )


@app.teardown_request
def teardown_request(exception):
    g.db.close()


@app.route('/', methods=['GET'])
def index():
    messages = Message.all(g.db, limit=20)
    payload = json.dumps([m.json() for m in messages], ensure_ascii=False).encode('utf8')

    resp = Response(payload)
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp


# Only used when starting the server during development
if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=8000)
