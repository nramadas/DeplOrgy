from flask import Flask, jsonify, render_template, redirect
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

    return render_template("main.html",
                           oauth_token=oauth_token,
                           repo_name=app.config['REPO_NAME'],
                           repo_owner=app.config['REPO_OWNER'])

@app.route("/dashboard")
def dashboard():
    return redirect("/")

@app.route("/navigation")
def navigation():
    return redirect("/")

@app.route("/pullrequests")
def pullrequests():
    return redirect("/")

if __name__ == "__main__":
    app.run()
