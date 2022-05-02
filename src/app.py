from db import Post, db
import json
from flask import Flask
from flask import request
from db import User

app = Flask(__name__)
db_filename = "travel_log.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=400):
    return json.dumps({"error": message}), code

# USER Routes
@app.route("/users/", methods=["POST"])
def create_user():
    """
    Endpoint for creating a new user
    """
    body = json.loads(request.data)
    name = body.get("name")
    if name is None:
        return failure_response("need name")
    new_user = User(name = name)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

@app.route("/users/<int:user_id>/")
def get_user(user_id):
    """
    Endpoint for getting a user
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("user not found", 404)
    return success_response(user.serialize())

# POSTS Routes
@app.route("/posts/")
def get_posts():
    """
    Endpoint for getting all posts
    """
    posts = []
    for post in Post.query.all():
        posts.append(post.serialize())
    return success_response({"posts": [p.serialize() for p in Post.query.all()]})

@app.route("/posts/<int:post_id>/")
def get_course(post_id):
    """
    Endpoint for getting a post by id
    """
    post = Post.query.filter_by(id=post_id).first()
    if post is None:
        return failure_response("post not found", 404)
    return success_response(post.serialize())

