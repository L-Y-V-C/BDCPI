from flask import Flask, render_template, url_for, request, redirect, flash
from flask_mysqldb import MySQL

import models.clases_model_select as selector
import models.clases_model_insert as inserter
import models.clases as clases
import models.clases_model_update as updater

MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWORD = ''
MYSQL_DB = 'db_billar'


app = Flask (__name__)
app.secret_key = 'adasdasdasdasdasdasdasd'
app.config['UPLOAD_FOLDER'] = 'static/profile_pictures'
app.config['PRODUCTS_UPLOAD_FOLDER'] = 'static/products_pictures'

data_base = MySQL(app)

@app.route('/')
def index():
    return redirect(url_for('mesas'))

'''
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
#inicio
@app.route('/inicio')
def inicio():
    return render_template('inicio.html')
'''

#Mesas
@app.route('/mesas')
def mesas():
    mesas_arr = selector.get_all_mesabillar(data_base)
    return render_template('mesas.html', mesas = mesas_arr)
#Pagos
@app.route('/pagos')
def pagos():
    return redirect(url_for('montos'))

#CLIENTES
@app.route('/clientes')
def clientes():
    clientes_arr = selector.get_all_clientes(data_base)
    return render_template('clientes_table.html', clientes = clientes_arr)


@app.route('/registrar_cliente', methods = ['GET', 'POST'])
def register_client():
    if request.method == 'POST':
        cliente_obj = clases.Cliente(0,request.form['nombre'], request.form['apellido'], request.form['tipo'], None, None, None)
        inserter.create_cliente(data_base, cliente_obj)
        return redirect(url_for('clientes'))
    else:
        return render_template('ingresar_clientes.html')

@app.route('/update_cliente/<int:id>', methods = ['GET', 'POST'])
def update_cliente_by_id(id):
    cliente_to_update = selector.get_cliente_by_id(data_base, id)
    if request.method == 'POST':
        #HACER ESTO
        cliente_to_update.nombre = request.form['nombre']
        cliente_to_update.apellidos = request.form['apellido']
        cliente_to_update.tipo = request.form['tipo']
        
        print ("MESA COMIDA PRUEBA: " ,cliente_to_update.id_mesa_comida)
        print("\n\n\n\n\n\n\n")
        updater.update_cliente(data_base, cliente_to_update)
        return redirect(url_for('clientes'))
    else:
        return render_template('update_cliente.html', cliente = cliente_to_update)


@app.route('/update_mesa/<int:id>', methods = ['GET', 'POST'])
def update_mesa_info(id):
    mesa_to_update = selector.get_mesa_by_id(data_base, id)
    if request.method == 'POST':
        mesa_to_update.estado = request.form['estado']
        print("ESTADO: " , mesa_to_update.estado)
        updater.update_mesa_billar(data_base, mesa_to_update)
        return redirect(url_for('mesas'))
    else:
        return render_template('update_mesa.html', mesa = mesa_to_update)

#comidas
@app.route('/comidas')
def comidas():
    clientes_arr = selector.get_all_clientes(data_base)
    for cliente in clientes_arr:
        print(cliente.id, "   " ,cliente.nombre, "  " ,cliente.apellidos, "  " ,cliente.tipo, "  " ,cliente.id_mesa_billar, "  " ,cliente.id_pago_com, "  ",cliente.id_mesa_comida)
    return render_template('comidas.html', clientes = clientes_arr)

@app.route('/select-consumables/<int:cliente_id>', methods=['GET', 'POST'])
def select_consumables(cliente_id):
    consumibles = selector.get_all_consumibles(data_base)
    return render_template('select_consumables.html', cliente=cliente_id, consumibles=consumibles, sin_stock=None)


@app.route('/guardar-detalle-pedido', methods=['POST'])
def guardar_detalle_pedido():
    cliente_id = request.form.get('cliente_id')
    seleccionados = request.form.getlist('consumibles')

    if not cliente_id or not seleccionados:
        return redirect(url_for('comidas'))

    sin_stock = []
    productos_con_stock = []

    for consumible_id in seleccionados:
        stock_actual = selector.get_all_stock(data_base, consumible_id).stock
        if stock_actual[0] <= 0:
            sin_stock.append(consumible_id)
        else:
            productos_con_stock.append(consumible_id) 
    if sin_stock:
        mensaje = "Algunos productos no tienen stock suficiente: " + ', '.join(map(str, sin_stock))
        flash(mensaje)  # Mantienes el flash para pasar el mensaje a la plantilla
        return redirect(url_for('select_consumables', cliente_id=cliente_id))

    for consumible_id in productos_con_stock:
        consumible_obj = clases.Consumible(consumible_id, None, None, None, None)
        updater.update_Stock(data_base, consumible_obj)

    pedido_consumible_obj = clases.PedidoConsumible(0, 1, cliente_id, 0)
    inserter.create_pedido_consumible(data_base, pedido_consumible_obj)

    cursor = data_base.connection.cursor()
    cursor.execute("SELECT LAST_INSERT_ID();")
    id_pedido_consumible = cursor.fetchone()[0]
    
    for consumible_id in productos_con_stock:
        pedido_consumible_consumible_obj = clases.PedidoConsumible_Consumible(
            consumible_id, id_pedido_consumible
        )
        inserter.create_pedido_consumible_consumible(data_base, pedido_consumible_consumible_obj)

    data_base.connection.commit()
    return redirect(url_for('comidas'))
#pagos
@app.route('/montos')
def montos():
    montos_arr = selector.get_pagos(data_base)
    return render_template('pagos.html', montos = montos_arr)



'''
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
'''

@app.errorhandler(404)
def pagina_no_encontrada(error):
    return render_template('404.html'), 404

'''
@app.errorhandler(401)
def error_401(error):
    return redirect(url_for('login'))
'''
if __name__ == '__main__':
    app.run(debug = True)