from turtle import up
from db import Post, db
import json
from flask import Flask
from flask import request
from db import User
from db import Place
from db import Category
import users_dao

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

def extract_token(request):
    """
    Helper function that extracts the token from the header of a request
    """
    auth_header = request.headers.get("Authorization")
    if auth_header is None:
        return False, json.dumps({"Missing authorization header"})

    bearer_token = auth_header.replace("Bearer", "").strip()

    return True, bearer_token

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

@app.route("/login/", methods=["POST"])
def login():
    """
    Endpoint for logging in a user
    """
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password")
    if email is None or password is None:
        return failure_response("Missing email or password", 400)
    was_successful, user = users_dao.verify_credentials(email, password)

    if not was_successful:
        return failure_response("Incorrect username or password", 401)
    
    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }, 201
    )
@app.route("/secret/", methods=["GET"])
def secret_message():
    """
    Endpoint for verifying a session token and returning a secret message

    In your project, you will use the same logic for any endpoint that needs 
    authentication
    """
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    
    user= users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return failure_response("invalid session token")
    return success_response({"message": "you have implemented sessions"})

@app.route("/register/", methods=["POST"])
def create_user():
    """
    Endpoint for registering a new user
    """
    body = json.loads(request.data)
    name = body.get("name")
    email = body.get("email")
    password = body.get("password")
    if name is None:
        return failure_response("need name")
    if email is None or password is None:
        return failure_response("Missing email or password")
    
    was_successful, new_user = users_dao.create_user(name, email, password)
    if not was_successful:
        return failure_response("user already exists")

    db.session.add(new_user)
    db.session.commit()
    return success_response(
        {
            "session_token": new_user.session_token,
            "session_expiration": str(new_user.session_expiration),
            "update_token": new_user.update_token
        }, 201
        
    )
@app.route("/session/", methods=["POST"])
def update_session():
    """
    Endpoint for updating a user's session
    """
    was_successful, update_token = extract_token(request)

    if not was_successful:
        return update_token
    try:
        user = users_dao.renew_session(update_token)
    except Exception as e:
        return failure_response(f"Invalid update token: {str(e)}")
    
    return success_response(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }, 201
    )

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
def get_post(post_id):
    """
    Endpoint for getting a post by id
    """
    post = Post.query.filter_by(id=post_id).first()
    if post is None:
        return failure_response("post not found", 404)
    return success_response(post.serialize())

@app.route("/users/<int:user_id>/posts/")
def get_posts_from_user(user_id):
    """
    endpoint for getting posts given a user's id
    """
    posts = []
    if posts is None:
        return failure_response("user has not posts", 404)
    
    for post in Post.query.filter_by(user_id=user_id):
        posts.append(post.serialize())
    return success_response({"posts": [p.simple_serialize() for p in Post.query.filter_by(user_id=user_id)]})

@app.route("/users/<int:user_id>/posts/", methods=["POST"])
def create_post(user_id):
    """
    endpoint for creating a new post for a place 
    """
    body = json.loads(request.data)
    place = body.get("place")
    if place is None:
        return failure_response("place not found", 404)
    place_id = (Place.query.filter_by(name=place).first())
    
    if place_id is None:
        # create new place
        # otherwise assign task to existing category
        new_place = Place(name = place)
        db.session.add(new_place)
        db.session.commit()

    place_id = (Place.query.filter_by(name=place).first()).id
    
    if user_id is None:
        return failure_response("user not found", 404)
    review = body.get("review")
    if not review:
        return failure_response("missing review", 404)
    text = body.get("text")
    if not text:
        return failure_response("missing text", 404)
   
    new_post = Post(
        review=review,
        text=text,
        place_id=place_id,
        user_id =user_id,
        categories = body.get("categories")
    )
    db.session.add(new_post)
    db.session.commit()
    return success_response(new_post.serialize(), 201)

@app.route("/posts/<int:post_id>/",  methods=["DELETE"])
def delete_post(post_id):
    """
    endpoint for deleting a post by id
    """
    post = Post.query.filter_by(id=post_id).first()
    if post is None:
        return failure_response("post not found")
    db.session.delete(post)
    db.session.commit()
    return success_response(post.serialize())

# Category Routes
@app.route("/categories/")
def get_categories():
    """
    Endpoint for getting all categories
    """
    categories = []
    for category in Category.query.all():
        categories.append(category.serialize())
    return success_response({"categories": [c.simple_serialize() for c in Category.query.all()]})

@app.route("/posts/<int:post_id>/category/", methods=["POST"])
def assign_category(post_id):
    """
    Endpoint for assigning a category to a post by id 
    """
    post = Post.query.filter_by(id=post_id).first()
    if post is None:
        return failure_response("post not found")
    body = json.loads(request.data)
    description = body.get("description")
    
    category = Category.query.filter_by(description=description).first()
    if category is None:
        category = Category(description=description)
    post.categories.append(category)

    db.session.commit()
    return success_response(post.serialize())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
