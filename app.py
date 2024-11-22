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
current_local_id = 1

data_base = MySQL(app)

@app.route('/')
def index():
    return redirect(url_for('mesas'))
#Mesas
@app.route('/mesas')
def mesas():
    mesas_arr = selector.get_mesabillar_by_local_id(data_base, current_local_id)
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
        cliente_to_update.nombre = request.form['nombre']
        cliente_to_update.apellidos = request.form['apellido']
        prev_tipo = cliente_to_update.tipo
        cliente_to_update.tipo = request.form['tipo']
        if (cliente_to_update.tipo == "Regular"):
            updater.setNullClienteCasillero(data_base, cliente_to_update.id)
        else:
            if (prev_tipo == "Regular"):
                updater.asignar_casillero(data_base, cliente_to_update.id)
        updater.update_cliente(data_base, cliente_to_update)
        
        return redirect(url_for('clientes'))
    else:
        return render_template('update_cliente.html', cliente = cliente_to_update)


@app.route('/update_mesa/<int:id>', methods = ['GET', 'POST'])
def update_mesa_info(id):
    mesa_to_update = selector.get_mesa_by_id(data_base, id)
    clientes_arr = selector.get_all_clientes(data_base)
    if request.method == 'POST':
        if request.form.get('estado') == 'Mantenimiento' or request.form.get('estado') == 'Disponible':
            mesa_to_update.estado = request.form.get('estado')
            updater.update_mesa_billar(data_base, mesa_to_update)
            return redirect(url_for('mesas'))
        preciohora = 0
        if mesa_to_update.tipo == 'Normal':
            preciohora = 7
        elif mesa_to_update.tipo == 'Carambola':
            preciohora = 6
        else:
            preciohora = 8
        checkoutmesa_obj = clases.Checkoutmesa(0,preciohora, request.form.get('hora_fin'), request.form.get('hora_inicio'), current_local_id)
        inserter.create_checkoutmesa(data_base, checkoutmesa_obj)
        last_checkoutmesa_id = selector.get_last_checkoutmesa_id(data_base)
        pago_obj = clases.Pago(0, None, None, last_checkoutmesa_id)
        inserter.create_pago(data_base, pago_obj)
        mesa_to_update.estado = request.form.get('estado')
        mesa_to_update.id_pago_com = last_checkoutmesa_id
        cliente_id = request.form.get('clienteSelect')
        cliente_to_update = selector.get_cliente_by_id(data_base, cliente_id)
        cliente_to_update.id_pago_com = last_checkoutmesa_id
        cliente_to_update.id_mesa_billar = mesa_to_update.id
        updater.update_mesa_billar(data_base, mesa_to_update)
        updater.update_cliente(data_base, cliente_to_update)
        return redirect(url_for('mesas'))
    else:
        return render_template('update_mesa.html', mesa = mesa_to_update, clientes = clientes_arr)

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
        flash(mensaje)
        return redirect(url_for('select_consumables', cliente_id=cliente_id))

    for consumible_id in productos_con_stock:
        consumible_obj = clases.Consumible(consumible_id, None, None, None, None)
        updater.update_Stock(data_base, consumible_obj)

    pedido_consumible_obj = clases.PedidoConsumible(0, cliente_id, 0)
    inserter.create_pedido_consumible(data_base, pedido_consumible_obj)

    cursor = data_base.connection.cursor()
    cursor.execute("SELECT LAST_INSERT_ID();")
    id_pedido_consumible = cursor.fetchone()[0]
    inserter.assign_consumible_pago(data_base,pedido_consumible_obj,id_pedido_consumible)

    for consumible_id in productos_con_stock:
        pedido_consumible_consumible_obj = clases.PedidoConsumible_Consumible(
            consumible_id, id_pedido_consumible
        )
        inserter.create_pedido_consumible_consumible(data_base, pedido_consumible_consumible_obj)

    data_base.connection.commit()
    return redirect(url_for('comidas'))

#PAGOS
@app.route('/montos_cliente/<int:cliente_id>', methods=['GET', 'POST'])
def montos_cliente(cliente_id):
    cliente = selector.get_cliente_by_id(data_base, cliente_id)
    monto_mesa = selector.get_monto_mesa(data_base, cliente_id)
    monto_consumibles = selector.get_monto_consumibles(data_base, cliente_id)
    monto_total = selector.get_monto_total_cliente(data_base, cliente_id)
    return render_template('pagos.html', 
                           monto_mesa = monto_mesa, 
                           monto_consumibles = monto_consumibles, 
                           monto_total = monto_total,
                           cliente = cliente)

#REALIZAR PAGO
@app.route('/realizarPago/<int:cliente_id>', methods=['GET', 'POST'])
def realizar_pago(cliente_id):
    metodo_pago = request.args['metodo']
    updater.pagar_monto_total(data_base, cliente_id, metodo_pago)
    return redirect(url_for('clientes'))

#LOCALES
@app.route('/local')
def locales():
    locales_arr = selector.get_all_locales(data_base)
    return render_template('locales.html', locales=locales_arr)

@app.route('/local_info/<int:local_id>')
def local_info(local_id):
    data = selector.resumen_distribucion_ambientes(data_base)
    locales_info = {}
    for row in data:
        if row.id_local not in locales_info:
            locales_info[row.id_local] = {
                'id_local': row.id_local,
                'direccion': row.direccion,
                'mesas': []
            }
        
        locales_info[row.id_local]['mesas'].append({
            'nombre': row.nombre,
            'id_mesa_billar': row.id_mesa_billar,
            'id_mesa_comida': row.id_mesa_comida
        })

    local = locales_info.get(local_id, None)
    
    if not local:
        return render_template('404.html')
    return render_template('local_info.html', local = local, id = local_id)

@app.route('/set_local/<int:local_id>')
def set_local(local_id):
    global current_local_id
    current_local_id = local_id
    return redirect(url_for('locales'))


@app.route('/mantenimiento')
def mantenimiento():
    mantenimiento_arr = selector.get_all_mesabillar_mantenimiento_by_id(data_base,current_local_id)
    return render_template('mantenimiento.html', mantenimientos = mantenimiento_arr)

@app.route('/empleados')
def empleados():
    empleados_arr = selector.get_empleados_by_local_id(data_base, current_local_id)
    return render_template('empleados.html', empleados = empleados_arr)

@app.route('/registrar_empleado', methods = ['GET', 'POST'])
def register_empleado():
    if request.method == 'POST':
        empleado_obj = clases.Empleado(request.form['dni'],request.form['telefono'], request.form['nombre'],request.form['apellido'], request.form['email'], request.form['cargo'], current_local_id)
        inserter.create_empleado(data_base, empleado_obj)
        return redirect(url_for('empleados'))
    else:
        return render_template('registrar_empleados.html')

@app.route('/update_empleado/<int:id>', methods = ['GET', 'POST'])
def update_empleado_by_id(id):
    empleado_to_update = selector.get_empleado_by_id(data_base, id)
    if request.method == 'POST':
        empleado_to_update.telefono = request.form['telefono']
        empleado_to_update.nombre = request.form['nombre']
        empleado_to_update.apellido = request.form['apellido']
        empleado_to_update.correo_electronico = request.form['email']
        empleado_to_update.cargo = request.form['cargo']
        
        updater.update_empleado(data_base, empleado_to_update)
        return redirect(url_for('empleados'))
    else:
        return render_template('update_empleado.html', empleado = empleado_to_update)
    
@app.route('/proveedor_equipamiento')
def proveedor_equipamiento():
    proequi_arr = selector.proveedor_equipamiento(data_base)
    return render_template('proveedor_equipamiento.html', proequi = proequi_arr)

@app.route('/proveedor_ingrediente')
def proveedor_ingrediente():
    proing_arr = selector.proveedor_ingrediente(data_base)
    return render_template('proveedor_ingrediente.html', proing = proing_arr)

@app.route('/registrar_proveedor_ingrediente', methods = ['GET', 'POST'])
def register_ingrediente():
    proveedores_arr = selector.get_all_proveedores(data_base)
    if request.method == 'POST':
        ingrediente = clases.Ingrediente(0, request.form['ingrediente'], request.form['cantidad'], request.form['proveedor'])
        inserter.create_ingrediente(data_base, ingrediente)
        return redirect(url_for('proveedor_ingrediente'))
    else:
        return render_template('registrar_proveedor_ingrediente.html', proveedores = proveedores_arr)

@app.route('/registrar_proveedor_equipamiento', methods = ['GET', 'POST'])
def register_equipamiento():
    proveedores_arr = selector.get_all_proveedores(data_base)
    if request.method == 'POST':
        tipo = request.form['nombre_equipamiento']
        descripcion = ""
        if (tipo == "Bolas de Billar"):
            descripcion = "Conjunto completo de bolas"
        elif (tipo == "Tiza"):
            descripcion = "Tiza para billar"
        elif (tipo == "Racks de Billar"):
            descripcion = "Conjunto de racks para billar"
        else:
            descripcion = "Palo estándar"
        
        equipamiento = clases.Equipamiento(0, tipo, descripcion, request.form['proveedor'], None)
        inserter.create_equipamiento(data_base, equipamiento)
        return redirect(url_for('proveedor_equipamiento'))
    else:
        return render_template('registrar_proveedor_equipamiento.html', proveedores = proveedores_arr)

@app.route('/proveedor')
def proveedor():
    return render_template('proveedor.html')

@app.route('/registrar_proveedor', methods = ['GET', 'POST'])
def register_proveedor():
    if request.method == 'POST':
        proveedor_obj =  clases.Proveedor(0, request.form['nombre'], request.form['correo'], "Ingrediente" , request.form['numero'])
        inserter.create_proveedor(data_base, proveedor_obj)
        return redirect(url_for('proveedor'))
    else:
        return render_template('registrar_proveedor.html')

@app.route('/equi')
def equi():
    equis_arr = selector.get_all_equipamento_mantenimiento(data_base)
    return render_template('equipamiento.html', equis = equis_arr)

#
@app.route('/consumibles')
def consumibles():
    consumibles_arr = selector.get_consumibles_by_local_id(data_base, current_local_id)
    return render_template('consumibles.html', consumibles = consumibles_arr)

@app.route('/view_ingredients/<int:id>', methods = ['GET', 'POST'])
def view_ingredients(id):
    ingredientes_arr = selector.get_ingredientes_by_consumible_id(data_base, id)
    print("MESA ID INGREDIENTES: ", id)
    return render_template('ingredientes.html', ingredientes = ingredientes_arr, mesa_id = id)

@app.route('/mesas_comida')
def mesas_comida():
    mesas_arr = selector.get_mesa_comida_by_local_id(data_base, current_local_id)
    selector.get_ambientes_nombre_by_mesa_id(data_base, mesas_arr)
    return render_template('mesas_comida.html', mesas = mesas_arr)

@app.route('/registrar_mesa_billar', methods = ['GET', 'POST'])
def registrar_mesa_billar():
    ambientes_arr = selector.get_all_ambientes(data_base,current_local_id)
    if request.method == 'POST':
        mesa_billar = clases.Mesabillar(0, request.form['tipo_mesa'], 'Disponible', None,None,int(request.form['id_ambiente']))
        inserter.create_mesabillar(data_base, mesa_billar)
    return render_template('registrar_mesa_billar.html', ambientes=ambientes_arr)

@app.route('/registrar_mesa_comida', methods = ['GET', 'POST'])
def registrar_mesa_comida():
    ambientes_arr = selector.get_all_ambientes(data_base,current_local_id)
    if request.method == 'POST':
        mesa_comida = clases.Mesacomida(
            0,
            int(request.form['capacidad']),
            int(request.form['numero']),
            int(request.form['id_ambiente'])
        )
        inserter.create_mesacomida(data_base, mesa_comida)
    return render_template('registrar_mesa_comida.html', ambientes=ambientes_arr)

@app.route('/listaPagos')
def totales():
    pagoConsumibleList = selector.get_pagoListConsumible(data_base)
    pagoMesaList = selector.get_pagoListMesa(data_base)
    pagoTotalConsumible = selector.get_totalPagoListConsumible(data_base)
    pagoTotalMesa = selector.get_totalPagoListMesa(data_base)
    return render_template('pagosLista.html', pagoConsumibleList = pagoConsumibleList, pagoMesaList = pagoMesaList, pagoTotalConsumible = pagoTotalConsumible, pagoTotalMesa = pagoTotalMesa)

@app.context_processor
def inject_current_local_id():
    global current_local_id
    return {'current_local_id': current_local_id}

@app.errorhandler(404)
def pagina_no_encontrada(error):
    return render_template('404.html'), 404

if __name__ == '__main__':
    app.run(debug = True)