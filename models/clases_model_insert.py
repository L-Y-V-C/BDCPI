def create_cliente(data_base, cliente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_cliente(%s, %s, %s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        cliente_obj.nombre, cliente_obj.apellidos, cliente_obj.tipo, 
        cliente_obj.id_mesa_billar, cliente_obj.id_pago_com, cliente_obj.id_mesa_comida
    ))
    data_base.connection.commit()

def create_casillero(data_base, casillero_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_casillero(%s, %s);"""
    cursor.execute(sql_command, (
        casillero_obj.numero, casillero_obj.id_cliente
    ))
    data_base.connection.commit()

def create_mesabillar(data_base, mesabillar_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_mesabillar(%s, %s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        mesabillar_obj.tipo, mesabillar_obj.estado, mesabillar_obj.id_mantenimiento,
        mesabillar_obj.id_pago_com, mesabillar_obj.id_ambiente
    ))
    data_base.connection.commit()

def create_checkoutmesa(data_base, checkoutmesa_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_checkoutmesa(%s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        checkoutmesa_obj.precio_hora, checkoutmesa_obj.hora_inicio,
        checkoutmesa_obj.hora_fin, checkoutmesa_obj.id_local
    ))
    data_base.connection.commit()

def create_ambiente(data_base, ambiente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_ambiente(%s, %s, %s);"""
    cursor.execute(sql_command, (
        ambiente_obj.nombre, ambiente_obj.capacidad, ambiente_obj.id_local
    ))
    data_base.connection.commit()

def create_empleado(data_base, empleado_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_empleado(%s, %s, %s, %s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        empleado_obj.dni, empleado_obj.telefono, empleado_obj.nombre, 
        empleado_obj.apellido, empleado_obj.correo_electronico, empleado_obj.cargo,
        empleado_obj.id_local
    ))
    data_base.connection.commit()

def create_mantenimiento(data_base, mantenimiento_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_mantenimiento(%s, %s);"""
    cursor.execute(sql_command, (
        mantenimiento_obj.fecha, mantenimiento_obj.descripcion
    ))
    data_base.connection.commit()

def create_local(data_base, local_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_local(%s, %s, %s);"""
    cursor.execute(sql_command, (
        local_obj.direccion, local_obj.hora_apertura, local_obj.hora_cierre
    ))
    data_base.connection.commit()

def create_equipamiento(data_base, equipamiento_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_equipo(%s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        equipamiento_obj.tipo, equipamiento_obj.descripcion,
        equipamiento_obj.id_proveedor, equipamiento_obj.id_mantenimiento
    ))
    data_base.connection.commit()

def create_proveedor(data_base, proveedor_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_proveedor(%s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        proveedor_obj.nombre, proveedor_obj.correo_electronico, proveedor_obj.tipo,
        proveedor_obj.telefono
    ))
    data_base.connection.commit()

def create_pedido_consumible(data_base, pedido_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_pedidoConsumible( %s, %s);"""
    cursor.execute(sql_command, (
        pedido_consumible_obj.id_cliente, 
        pedido_consumible_obj.id_local
    ))
    data_base.connection.commit()

def create_consumible(data_base, consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_consumible(%s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        consumible_obj.precio, consumible_obj.descripcion, consumible_obj.nombre,
        consumible_obj.stock
    ))
    data_base.connection.commit()

def create_ingrediente(data_base, ingrediente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_ingrediente(%s, %s, %s);"""
    cursor.execute(sql_command, (
        ingrediente_obj.nombre, ingrediente_obj.cantidad, ingrediente_obj.id_proveedor
    ))
    data_base.connection.commit()

def create_mesacomida(data_base, mesacomida_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_mesacomida(%s, %s, %s);"""
    cursor.execute(sql_command, (
        mesacomida_obj.capacidad, mesacomida_obj.numero, mesacomida_obj.id_ambiente
    ))
    data_base.connection.commit()

def create_pago(data_base, pago_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_pago(%s, %s, %s);"""
    cursor.execute(sql_command, (
        pago_obj.metodo, pago_obj.id_pedido_consumible, pago_obj.id_pago_com
    ))
    data_base.connection.commit()

def create_local_consumible(data_base, local_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_local_consumible(%s, %s);"""
    cursor.execute(sql_command, (
        local_consumible_obj.id_consumible, local_consumible_obj.id_local
    ))
    data_base.connection.commit()

def create_pedido_consumible_consumible(data_base, pedido_consumible_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_pedidoconsumible_consumible(%s, %s);"""
    cursor.execute(sql_command, (
        pedido_consumible_consumible_obj.id_consumible, 
        pedido_consumible_consumible_obj.id_pedido_consumible
    ))
    data_base.connection.commit()

def create_ingrediente_consumible(data_base, ingrediente_consumible_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.insert_ingrediente_consumible(%s, %s);"""
    cursor.execute(sql_command, (
        ingrediente_consumible_obj.id_ingrediente, ingrediente_consumible_obj.id_consumible
    ))
    data_base.connection.commit()
    
def create_proveedor_ingrediente(data_base, proveedor_obj, ingrediente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.create_proveedor_ingrediente(%s, %s, %s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        proveedor_obj.nombre, proveedor_obj.correo_electronico, proveedor_obj.tipo, proveedor_obj.telefono, ingrediente_obj.nombre, ingrediente_obj.cantidad
    ))
    data_base.connection.commit()