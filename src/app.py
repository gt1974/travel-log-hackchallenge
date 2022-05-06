from db import Post, db
import json
from flask import Flask
from flask import request
from db import User
from db import Place
from db import Category

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
@app.route("/")
@app.route("/users/")
def get_users():
    """
    Endpoint for getting a user
    """
    users = []
    for user in User.query.all():
        users.append(user.serialize()) 
    return success_response({"users": [u.serialize() for u in User.query.all()]})

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

# PLACES routes
@app.route("/places/")
def get_places():
    """
    Endpoint for getting all places
    """
    places = []
    for place in Place.query.all():
        places.append(place.serialize())
    return success_response({"places": [p.serialize() for p in Place.query.all()]})

@app.route("/places/", methods=["POST"])
def create_place():
    """
    Endpoint for creating a new place
    """
    body = json.loads(request.data)
    name = body.get("name")
    if not name:
        return failure_response("missing place name", 400)

    new_place = Place(name=name)
    db.session.add(new_place)
    db.session.commit()
    return success_response(new_place.serialize(), 201)


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

@app.route("/users/<int:user_id>/posts/", methods=["POST"])
def create_post(user_id):
    """
    endpoint for creating a new post for a place 
    """
    body = json.loads(request.data)
    place = body.get("place")
    if place is None:
        return failure_response("place not found", 404)
    place_id = (Place.query.filter_by(name=place).first()).id
    
    if place_id is None:
        return failure_response("place id not found", 404)
    
    if user_id is None:
        return failure_response("user not found", 404)

    new_post = Post(
        review=body.get("review"),
        text=body.get("text"),
        place_id=place_id,
        user_id =user_id
    )
    db.session.add(new_post)
    db.session.commit()
    return success_response(new_post.serialize(), 201)



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
