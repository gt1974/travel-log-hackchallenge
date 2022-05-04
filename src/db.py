from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

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
    
    def __init__(self, **kwargs):
        """
        initialize Post object/entry
        """
        self.review = kwargs.get("review", "")
        self.text = kwargs.get("text", "")

    def serialize(self):  
        """
        serialize post object
        """  
        return {        
            "id": self.id,                
            "name": self.review,
            "text": self.text,
            "place_id": [p.simple_serialize() for p in self.place_id],
            "user_id": [u.simple_serialize() for u in self.user_id]
        }
    def simple_serialize(self):  
        """
        serialize post object
        """  
        pass

class Place(db.Model):
    """
    Initiate Place object
    has a one to many relationship with Posts
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
            "posts": [p.simple_serialize() for p in self.posts]
        }
    def simple_serialize(self):  
        """
        serialize place object
        """  
        return {
            "id": self.id,                
            "name": self.name
        }

