from flask import Flask, jsonify
import urllib2
import uuid
app = Flask(__name__)

_globals = {
    "g_client_id": "b8047c4fddfe18ac9cdf",
    "g_client_secret": "ac45bd47f2cb9e7f04f1106c7ae35ec0229a6d3b",
}


@app.route("/")
def main():
    return "Hello World"


@app.route("/g")
def g():
    url = "https://github.com/login/oauth/authorize?"
    url += "client_id={client_id}&".format(client_id=_globals['g_client_id'])
    url += "redirect_uri={uri}&".format(uri="/dashboard")
    url += "scope={scope}&".format(scope="")
    url += "state={state}".format(state=str(uuid.uuid4().get_hex()))
    return jsonify(url=url)


if __name__ == "__main__":
    app.run()
