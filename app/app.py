# Save this as app.py
from flask import Flask
import random

app = Flask(__name__)

@app.route('/')
def hello():
    return f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Hello App</title>
        <style>
            body {{
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #74ebd5, #9face6);
                color: #333;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                overflow: hidden;
            }}
            .card {{
                background: white;
                padding: 2rem 3rem;
                border-radius: 1rem;
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
                text-align: center;
                max-width: 400px;
                z-index: 2;
            }}
            h1 {{
                margin: 0 0 1rem;
                font-size: 2rem;
                color: #4a4a8c;
            }}
            p {{
                font-size: 1.1rem;
                color: #555;
            }}
            .balloon {{
                position: absolute;
                bottom: -100px;
                font-size: 2rem;
                animation: float 8s linear infinite;
            }}
            @keyframes float {{
                from {{ transform: translateY(0); }}
                to {{ transform: translateY(-120vh); }}
            }}
        </style>
    </head>
    <body>
        <div class="card">
            <h1>Hello 👋!</h1>
            <p>Welcome to this very important app.</p>
        </div>

        <!-- Floating balloon emoji -->
        <div class="balloon" style="left: 20%;">🎈</div>
        <div class="balloon" style="left: 50%; animation-delay: 2s;">🎈</div>
        <div class="balloon" style="left: 80%; animation-delay: 4s;">🎈</div>
    </body>
    </html>
    """

if __name__ == '__main__':
    print("Starting Flask app...")
    print("Running at: http://0.0.0.0:8080")
    app.run(host='0.0.0.0', port=8080, debug=True)
