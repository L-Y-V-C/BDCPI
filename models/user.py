from flask_login import UserMixin

class User(UserMixin):
    id = 0
    nombre = ''
    user = ''
    password = ''
    email = ''
    profile_pic = ''
    def __init__ (self, id, nombre, user, password, email, profile_pic):
        self.id = id
        self.nombre = nombre
        self.user = user
        self.password = password
        self.email = email
        self.profile_pic = profile_pic
    
    def check_password(self, in_password):
        return self.password == in_password