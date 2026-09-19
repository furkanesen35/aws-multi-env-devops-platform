import os
from flask import Flask, jsonify

app = Flask(__name__)

ENV = os.getenv("ENVIRONMENT", "dev")

@app.route("/")
def health():
    return jsonify({
        "status": "healthy",
        "environment": ENV,
        "service": "aws-multi-env-devops-platform"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)