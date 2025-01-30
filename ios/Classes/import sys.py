import sys
import logging
import json
from datetime import datetime
from instagrapi import Client

# Configure logging
logging.basicConfig(level=logging.INFO)

def fetch_conversations(username, password):
    client = Client()
    try:
        client.login(username, password)
        threads = client.direct_threads(amount=10)
        
        conversations = []
        for thread in threads:
            messages = client.direct_messages(thread.id, amount=10)
            conversation = {
                'thread_id': thread.id,
                'participants': [user.username for user in thread.users],
                'messages': [{
                    'timestamp': message.timestamp.isoformat() if isinstance(message.timestamp, datetime) else datetime.fromtimestamp(int(message.timestamp)).isoformat(),
                    'user_id': message.user_id,
                    'text': message.text if message.text else ''
                } for message in messages]
            }
            conversations.append(conversation)
        
        print(json.dumps(conversations))
    
    except Exception as e:
        print(json.dumps({"error": str(e)}))

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(json.dumps({"error": "Missing username or password"}))
        sys.exit(1)
    
    username = sys.argv[1]
    password = sys.argv[2]
    fetch_conversations(username, password)
