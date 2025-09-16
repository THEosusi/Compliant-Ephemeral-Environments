# Save this as app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
   return "<h1>Hello, World!</h1>"

if __name__ == '__main__':
    print("Starting Flask app...")
    print("Running at: http://0.0.0.0:8080")
    app.run(host='0.0.0.0', port=8080, debug=True)