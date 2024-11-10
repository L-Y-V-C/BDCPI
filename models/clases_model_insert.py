def create_cliente(data_base, cliente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_cliente('{}', '{}', '{}', '{}', '{}', '{}');""".format(
        cliente_obj.nombre, cliente_obj.apellidos, cliente_obj.tipo, 
        cliente_obj.id_mesa_billar, cliente_obj.id_pago_com, cliente_obj.id_mesa_comida)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_casillero(data_base, casillero_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_casillero('{}', '{}');""".format(
        casillero_obj.numero, casillero_obj.id_cliente)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_mesabillar(data_base, mesabillar_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_mesabillar('{}', '{}', '{}', '{}', '{}', '{}');""".format(
        mesabillar_obj.tipo, mesabillar_obj.estado, mesabillar_obj.id_mantenimiento,
        mesabillar_obj.id_pago_com, mesabillar_obj.id_ambiente)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_checkoutmesa(data_base, checkoutmesa_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_checkoutmesa('{}', '{}', '{}', '{}');""".format(
        checkoutmesa_obj.precio_hora, checkoutmesa_obj.hora_inicio,
        checkoutmesa_obj.hora_fin, checkoutmesa_obj.id_local)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_ambiente(data_base, ambiente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_ambiente('{}', '{}', '{}');""".format(
        ambiente_obj.nombre, ambiente_obj.capacidad, ambiente_obj.id_local)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_empleado(data_base, empleado_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_empleado('{}', '{}', '{}', '{}', '{}', '{}', '{}');""".format(
        empleado_obj.dni, empleado_obj.telefono, empleado_obj.nombre, 
        empleado_obj.apellido, empleado_obj.correo_electronico, empleado_obj.cargo,
        empleado_obj.id_local)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_mantenimiento(data_base, mantenimiento_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_mantenimiento('{}', '{}');""".format(
        mantenimiento_obj.fecha, mantenimiento_obj.descripcion)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_local(data_base, local_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_local('{}', '{}', '{}');""".format(
        local_obj.direccion, local_obj.hora_apertura, local_obj.hora_cierre)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_equipamiento(data_base, equipamiento_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_equipo('{}', '{}', '{}', '{}', '{}');""".format(
        equipamiento_obj.tipo, equipamiento_obj.descripcion, equipamiento_obj.id_local,
        equipamiento_obj.id_proveedor, equipamiento_obj.id_mantenimiento)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_proveedor(data_base, proveedor_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_proveedor('{}', '{}', '{}', '{}');""".format(
        proveedor_obj.nombre, proveedor_obj.correo_electronico, proveedor_obj.tipo,
        proveedor_obj.telefono)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_pedido_consumible(data_base, pedido_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_pedidoConsumible('{}', '{}', '{}');""".format(
        pedido_consumible_obj.cantidad, pedido_consumible_obj.id_cliente, 
        pedido_consumible_obj.id_local)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_consumible(data_base, consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_consumible('{}', '{}', '{}', '{}');""".format(
        consumible_obj.precio, consumible_obj.descripcion, consumible_obj.nombre,
        consumible_obj.stock)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_ingrediente(data_base, ingrediente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_ingrediente('{}', '{}', '{}');""".format(
        ingrediente_obj.nombre, ingrediente_obj.cantidad, ingrediente_obj.id_proveedor)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_mesacomida(data_base, mesacomida_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_mesacomida('{}', '{}', '{}');""".format(
        mesacomida_obj.capacidad, mesacomida_obj.numero, mesacomida_obj.id_ambiente)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_pago(data_base, pago_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_pago('{}', '{}', '{}');""".format(
        pago_obj.metodo, pago_obj.id_pedido_consumible, pago_obj.id_pago_com)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_local_consumible(data_base, local_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_local_consumible('{}', '{}');""".format(
        local_consumible_obj.id_consumible, local_consumible_obj.id_local)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_pedido_consumible_consumible(data_base, pedido_consumible_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_pedidoconsumible_consumible('{}', '{}');""".format(
        pedido_consumible_consumible_obj.id_consumible, 
        pedido_consumible_consumible_obj.id_pedido_consumible)
    cursor.execute(sql_command)
    data_base.connection.commit()

def create_ingrediente_consumible(data_base, ingrediente_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL insert_ingrediente_consumible('{}', '{}');""".format(
        ingrediente_consumible_obj.id_ingrediente, ingrediente_consumible_obj.id_consumible)
    cursor.execute(sql_command)
    data_base.connection.commit()
