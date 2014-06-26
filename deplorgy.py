from flask import Flask, jsonify, render_template, redirect, make_response
from flask.ext.github import GitHub

app = Flask(__name__)
app.debug = True
app.config['GITHUB_CLIENT_ID'] = 'b8047c4fddfe18ac9cdf'
app.config['GITHUB_CLIENT_SECRET'] = 'ac45bd47f2cb9e7f04f1106c7ae35ec0229a6d3b'
app.config['GITHUB_CALLBACK_URL'] = 'http://127.0.0.1:5000/gcb'
app.config['REPO_NAME'] = 'Hipmunk'
app.config['REPO_OWNER'] = 'Hipmunk'
github = GitHub(app)

@app.route("/")
def main():
    return render_template("main.html")


@app.route("/login")
def login():
    return github.authorize(scope="repo")


@app.route("/gcb")
@github.authorized_handler
def gcb(oauth_token):
    if oauth_token is None:
        return redirect("/")

    resp = make_response(render_template("main.html"))
    resp.set_cookie("user_auth_token", oauth_token)
    resp.set_cookie("user_repo", app.config['REPO_NAME'])
    resp.set_cookie("user_repo_owner", app.config['REPO_OWNER'])
    return resp


if __name__ == "__main__":
    app.run()
