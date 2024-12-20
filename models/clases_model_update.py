def update_mesa_billar(data_base, mesa_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.update_mesabillar(%s, %s, %s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        mesa_obj.id,
        mesa_obj.tipo,
        mesa_obj.estado, 
        mesa_obj.id_mantenimiento,
        mesa_obj.id_pago_com, 
        mesa_obj.id_ambiente
    ))
    data_base.connection.commit()
    
def update_cliente(data_base, cliente_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.update_cliente(%s, %s, %s, %s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        cliente_obj.id, 
        cliente_obj.nombre,
        cliente_obj.apellidos, 
        cliente_obj.tipo, 
        cliente_obj.id_mesa_billar,
        cliente_obj.id_pago_com,
        cliente_obj.id_mesa_comida
    ))
    
    data_base.connection.commit()
def update_Stock (data_base, mesa_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.update_Stock('{}');""".format(
        mesa_obj.id
    )
    cursor.execute(sql_command)
    data_base.connection.commit()

def pagar_monto_total(data_base, cliente_id, metodo_pago):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.update_PagarMontoTotal({}, '{}');""".format(cliente_id, metodo_pago)
    cursor.execute(sql_command)
    data_base.connection.commit()
    
def setNullClienteCasillero (data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.SetNullIDCliente('{}');""".format(id)
    cursor.execute(sql_command)
    data_base.connection.commit()
    
def asignar_casillero (data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.AssignCasilleroToCliente('{}');""".format(id)
    cursor.execute(sql_command)
    data_base.connection.commit()
    
def update_empleado(data_base, empleado_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.update_empleado_by_id (%s, %s, %s, %s, %s, %s, %s);"""
    cursor.execute(sql_command, (
        empleado_obj.dni, 
        empleado_obj.telefono, 
        empleado_obj.nombre,
        empleado_obj.apellido, 
        empleado_obj.correo_electronico,
        empleado_obj.cargo, 
        empleado_obj.id_local
    ))
    
    data_base.connection.commit()