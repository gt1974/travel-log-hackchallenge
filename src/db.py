from shutil import register_unpack_format
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


association_table = db.Table(
    "association",
    db.Column("posts_id", db.Integer, db.ForeignKey("posts.id")),
    db.Column("category_id", db.Integer, db.ForeignKey("categories.id"))
)

class User(db.Model):
    """
    Initiate User object
    has a one to many relationship with Post model
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement =True)
    name = db.Column(db.String, nullable=False)
    posts = db.relationship("Post", cascade='delete')
    
    def __init__(self, **kwargs):
        """
        initialize User object/entry
        """
        self.name = kwargs.get("name", "")

    def serialize(self):  
        """
        serialize user object
        """  
        return {        
            "id": self.id,                
            "name": self.name,
            "posts": [p.serialize() for p in self.posts]
        }
    def simple_serialize(self):  
        """
        serialize user object
        """  
        return {
            "id": self.id,                
            "name": self.name
        }

class Post(db.Model):
    """
    Initiate Post object
    
    """
    __tablename__ = "posts"
    id = db.Column(db.Integer, primary_key=True, autoincrement =True)
    review = db.Column(db.Float, nullable=False)
    text = db.Column(db.String, nullable=False)
    place_id = db.Column(db.Integer, db.ForeignKey("places.id"), nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable = False)
    categories = db.relationship("Category", secondary =association_table, back_populates = "posts")
    
    def __init__(self, **kwargs):
        """
        initialize Post object/entry
        """
        self.review = kwargs.get("review", "")
        self.text = kwargs.get("text", "")
        self.place_id = kwargs.get("place_id")
        self.user_id = kwargs.get("user_id")

    def serialize(self):  
        """
        serialize post object
        """  
        return {        
            "id": self.id,                
            "review": self.review,
            "text": self.text,
            "place_id": self.place_id,
            "user_id": self.user_id,
            "categories": [c.simple_serialize() for c in self.categories]
        }
    def simple_serialize(self):  
        """
        serialize post object
        """  
        return {        
            "id": self.id,                
            "review": self.review,
            "text": self.text,
            "place_id": self.place_id,
            "user_id": self.user_id
        }

class Place(db.Model):
    """
    Initiate Place object
    has a one to many relationship with Post
    """
    __tablename__ = "places"
    id = db.Column(db.Integer, primary_key=True, autoincrement =True)
    name = db.Column(db.String, nullable=False)
    posts = db.relationship("Post", cascade='delete')
   
    def __init__(self, **kwargs):
        """
        initialize Place object/entry
        """
        self.name = kwargs.get("name", "")

    def serialize(self):  
        """
        serialize place object
        """  
        return {        
            "id": self.id,                
            "name": self.name,
            "posts": [p.serialize() for p in self.posts]
        }
    def simple_serialize(self):  
        """
        serialize place object
        """  
        return {
            "id": self.id,                
            "name": self.name
        }

class Category(db.Model):
    """
    Initiate category object
    """
    __tablename__ = "categories"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    description = db.Column(db.String, nullable=False)
    posts = db.relationship("Post", secondary=association_table, back_populates="categories")

    def __init__(self, **kwargs):
        """
        initializes a category object
        """
        self.description = kwargs.get("description", "")
    
    def serialize(self):
        """
        serializes category object
        """
        return {
            "id": self.id,
            "description": self.description, 
            "posts": [p.serialize() for p in self.posts]
        }
    
    def simple_serialize(self):
        """
        simply serializes category object
        """
        return {
            "id": self.id,
            "description": self.description
        }

