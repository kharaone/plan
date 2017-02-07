from datetime import datetime
import json


class Message(object):

    def __init__(self, messageId, message, created=datetime.now()):
        self.messageId = messageId
        self.message = message
        self.created = created

    def json(self):
        return {
            'messageId': self.messageId,
            'text': self.message,
            'created': self.created.isoformat()
        }

    @classmethod
    def all(self, db_conn, limit=10):
        cursor = db_conn.cursor()
        cursor.execute('''
            SELECT id, message, created
            FROM messages
            ORDER BY created DESC
            LIMIT %(limit)s
        ''', {'limit': limit})
        messages = [Message(messageId, message, created) for (messageId, message, created) in cursor]
        cursor.close()
        return messages