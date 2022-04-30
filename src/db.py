from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    """
    Initiate User object
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, auto_increment =True)
    name = db.Column(db.String, nullable=False)
    
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
        }
    def simple_serialize(self):  
        """
        serialize user object
        """  
        pass

class Post(db.Model):
    """
    Initiate Post object
    """
    __tablename__ = "posts"
    id = db.Column(db.Integer, primary_key=True, auto_increment =True)
    review = db.Column(db.Float, nullable=False)
    text = db.Column(db.String, nullable=False)
    
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
            "text": self.text
        }
    def simple_serialize(self):  
        """
        serialize post object
        """  
        pass

class Place(db.Model):
    """
    Initiate Place object
    """
    __tablename__ = "places"
    id = db.Column(db.Integer, primary_key=True, auto_increment =True)
    name = db.Column(db.String, nullable=False)
    
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
        }
    def simple_serialize(self):  
        """
        serialize place object
        """  
        pass

