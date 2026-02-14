import time
import uuid
import json
import logging
from flask import Flask, request, jsonify, g

START_TIME = time.time()

logging.getLogger("werkzeug").setLevel(logging.ERROR)
app = Flask(__name__)

# Configure JSON logging
logging.basicConfig(
    level=logging.INFO,
    format="%(message)s"
)

logger = logging.getLogger(__name__)


def log(message: str, **kwargs):
    log_entry = {
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%S"),
        "level": "INFO",
        "message": message,
        **kwargs
    }
    logger.info(json.dumps(log_entry))


@app.before_request
def start_request():
    g.start_time = time.time()
    g.request_id = request.headers.get("X-Request-Id", str(uuid.uuid4()))


@app.after_request
def end_request(response):
    latency_ms = round((time.time() - g.start_time) * 1000, 2)

    log(
        message="request completed",
        request_id=g.request_id,
        method=request.method,
        path=request.path,
        status_code=response.status_code,
        latency_ms=latency_ms
    )

    response.headers["X-Request-Id"] = g.request_id
    return response


@app.route("/")
def index():
    delay = float(request.args.get("delay", 0))
    fail = request.args.get("fail", "false").lower() == "true"
    stress = request.args.get("stress", None)

    if delay > 0:
        time.sleep(delay)

    if stress == "cpu":
        for _ in range(10**7):
            pass

    if fail:
        log("simulated failure triggered", request_id=g.request_id)
        return jsonify({"error": "simulated failure"}), 500

    return jsonify({"status": "ok"}), 200



@app.route("/health")
def health():
    return "OK", 200

@app.route("/metrics")  
def metrics():
    uptime = round(time.time() - START_TIME, 2)
    return jsonify({
        "uptime_seconds": uptime
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)



# Test #1 – Instance termination
# Test #2 – 500 error spike
# Test #3 – CPU saturation
# Test #4 – Latency increase