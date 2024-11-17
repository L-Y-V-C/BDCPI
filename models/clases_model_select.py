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

def get_mesabillar_by_id (data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_mesabillar_by_local_id('{}');""".format(id)
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

#BY ID
def get_mesa_by_id(data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_mesa_by_id('{}');""".format(id)
    cursor.execute(sql_command)
    
    arr = cursor.fetchone()
    mesa = clases.Mesabillar(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5])
    return mesa

def get_cliente_by_id(data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_cliente_by_id('{}');""".format(id)
    cursor.execute(sql_command)

    arr = cursor.fetchone()
    cliente = clases.Cliente(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6])
    return cliente

def get_all_stock(data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_stock('{}');""".format(id)
    cursor.execute(sql_command)
    
    arr = cursor.fetchone()
    consum = clases.Consumible(None,None,None,None,arr)
    return consum


def resumen_distribucion_ambientes(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.resumen_distribucion_ambientes();"""
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    distribucion_list = []
    for distri in arr:
        distribucion_list.append(clases.InfoLocal(distri[0], distri[1], distri[2], distri[3],distri[4]))
    return distribucion_list

def get_all_locales(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_locales();"""
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    locales_list = []
    for locales in arr:
        locales_list.append(clases.Local(locales[0], locales[1], locales[2], locales[3]))
    return locales_list

#PAGOS
def get_monto_mesa(data_base, cliente_id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_monto_mesa({});""".format(cliente_id)
    cursor.execute(sql_command)
    arr = cursor.fetchone()
    if arr == None:
        print("boi is NONe")
        monto_mesa = clases.MontoMesa(None,None,None,"00:00:00","00:00:00",0)
        return monto_mesa
    monto_mesa = clases.MontoMesa(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5])
    return monto_mesa

def get_monto_consumibles(data_base, cliente_id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_monto_consumibles({});""".format(cliente_id)
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    monto_consumibles_list = []
    for monto_consumible in arr:
        monto_consumibles_list.append(clases.MontoConsumible(monto_consumible[0], monto_consumible[1], monto_consumible[2], monto_consumible[3], 
            monto_consumible[4], monto_consumible[5], monto_consumible[6]))
    return monto_consumibles_list

def get_monto_total_cliente(data_base, cliente_id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_monto_total_cliente({});""".format(cliente_id)
    cursor.execute(sql_command)
    arr = cursor.fetchone()
    if arr[0] == None:
        arr = (0,) + arr[1:]
    if arr[2] is None:
        arr = arr[:2] + (0,) + arr[3:]
    monto_total = clases.MontoTotal(arr[0], arr[1], arr[2])
    return monto_total

