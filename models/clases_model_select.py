#get_all_distribucion_ambientes
#get_all_pedido_completo
#get_all_propietario_casillero

import models.clases as clases

def get_all_mesabillar (data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_mesabillar();"""
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    mesabillar_list = []
    
    for mesabillar in arr:
        mesabillar_list.append(clases.Mesabillar(mesabillar[0], mesabillar[1], mesabillar[2], None, None, None))
    return mesabillar_list



def get_all_clientes (data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_clientes();"""
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    clientes_list = []
    
    for clientes in arr:
        clientes_list.append(clases.Cliente(clientes[0], clientes[1], clientes[2], clientes[3], clientes[4], clientes[5],clientes[6]))
    return clientes_list

def get_all_consumibles (data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_consumibles();"""
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    consumibles_list = []
    
    for consumibles in arr:
        consumibles_list.append(clases.Consumible(consumibles[0], consumibles[1], consumibles[2], consumibles[3], consumibles[4]))
    return consumibles_list

def get_mesa_by_id(data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_mesa_by_id('{}');""".format(id)
    cursor.execute(sql_command)
    
    arr = cursor.fetchone()
    mesa = clases.Mesabillar(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5])
    return mesa

