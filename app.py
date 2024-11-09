from flask import Flask, render_template, url_for, request, redirect, flash
from flask_mysqldb import MySQL
from flask_login import LoginManager, login_user, logout_user, login_required, current_user

#MODELOS
from models.UserModel import UserModel
from models.productModel import ProductModel
from models.UserProductModel import UserProductModel
#ENTIDADES
from models.user import User
from models.producto import Product

import os

MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWORD = ''
MYSQL_DB = 'test_flask'


app = Flask (__name__)
app.secret_key = 'adasdasdasdasdasdasdasd'
app.config['UPLOAD_FOLDER'] = 'static/profile_pictures'
app.config['PRODUCTS_UPLOAD_FOLDER'] = 'static/products_pictures'

data_base = MySQL(app)
login_manager_app =  LoginManager(app)

@login_manager_app.user_loader
def load_user(id):
    return UserModel.get_by_id(data_base, id)

@app.route('/')
def index():
    return redirect(url_for('login'))

#LOGIN
@app.route('/login', methods = ['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = User(0, '', (request.form['user']), (request.form['password']), '', '')
        logged_user = UserModel.login(user, data_base)
        if logged_user != None:
            if logged_user.password == True:
                login_user(logged_user)
                return redirect(url_for('products'))
            else:
                flash("Contraseña invalida")
                return render_template('login.html')    
        else:
            flash("Usuario no encontrado")
            return render_template('login.html')
    else:
        return render_template('login.html')
#REGISTER
@app.route('/register', methods = ['GET', 'POST'])
def registro():
    if request.method == 'POST':
        file = request.files['imagen']
        user = User (0, request.form['nombre'], request.form['user'], request.form['contrasena'], request.form['e_mail'], file.filename)
        if UserModel.register(user, data_base):
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename)) #Guarda imagen
            return redirect(url_for('login'))
        else:
            flash('El usuario ya existe!')
            return render_template('register.html')
    else:
        return render_template('register.html')

#PERFIL
@app.route('/update_profile/<int:id>', methods = ['GET', 'POST'])
@login_required
def update_profile_web(id):
    User_to_update = UserModel.get_by_id(data_base, id)
    if request.method == 'POST':
        user = User (id, request.form['nombre'], request.form['usuario'], request.form['password'], request.form['e-mail'], User_to_update.profile_pic)
        if UserModel.update_profile(user, data_base):
            if current_user.id != 1:
                return redirect(url_for('logout'))
            else:
                return redirect(url_for('users'))
    else:
        return render_template('update_profile.html', user_info = User_to_update)
    
@app.route('/my_profile')
def profile():
    return render_template('my_profile.html')

#USUARIOS
@app.route('/users')
def users():
    users_list = UserModel.get_all_users(data_base)
    return render_template('usuarios.html', users_list = users_list)
#BORRAR USUARIOS
@app.route('/delete_users/<int:id>')
def delete_user_id(id):
    UserModel.delete_user(data_base, id)
    return redirect(url_for('users'))

#PRODUCTOS
@app.route('/products')
def products():
    products_list = UserProductModel.get_all_products(data_base)
    usuarios = UserModel.get_all_users(data_base)
    return render_template('productos.html', products = products_list, usuarios = usuarios)

#BORRAR PRODUCTOS
@app.route('/delete_product/<int:id>')
def delete_product_id(id):
    ProductModel.delete_product(data_base, id)
    return redirect(url_for('products'))
#COMPRAR PRODUCTOS
@app.route('/buy_product/<int:id>')
def buy_product(id):
    ProductModel.update_status(data_base, current_user.id, id)
    return redirect(url_for('products'))

#AÑADIR PRODUCTO
@app.route('/add_product', methods = ['GET', 'POST'])
def add_product():
    if request.method == 'POST':
        file = request.files['imagen']
        producto = Product(0, current_user.id, request.form['nombre'], request.form['descripcion'], request.form['precio'], file.filename, 0, 0)
        ProductModel.create_product(data_base, producto)
        
        file.save(os.path.join(app.config['PRODUCTS_UPLOAD_FOLDER'], file.filename)) #Guarda imagen
        return redirect(url_for('products'))
    else:
        return render_template('create_product.html')

#ACTUALIZAR PRODUCTO
@app.route('/update_product/<int:id>', methods = ['GET', 'POST'])
def update_product(id):
    if request.method == 'POST':
        producto = ProductModel.get_by_id(data_base, id)
        producto.precio = request.form['precio']
        ProductModel.update_product(data_base, producto)
        return redirect(url_for('products'))
    else:
        return render_template('update_product.html', product_info = ProductModel.get_by_id(data_base, id))

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.errorhandler(404)
def pagina_no_encontrada(error):
    return render_template('404.html'), 404

@app.errorhandler(401)
def error_401(error):
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug = True)