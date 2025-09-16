# Save this as app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
   return "<h1>Hello, World!</h1>"

if __name__ == '__main__':
    print("Starting Flask app...")
    print("Running at: http://127.0.0.1:8080")
    app.run(host='127.0.0.1', port=8080, debug=True)