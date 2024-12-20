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

def get_mesabillar_by_local_id (data_base, id):
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
        monto_mesa = clases.MontoMesa(None, None, None, "00:00:00", "00:00:00", 0)
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
        monto_consumibles_list.append(clases.MontoConsumible(monto_consumible[0], monto_consumible[1], monto_consumible[2], monto_consumible[3], monto_consumible[4]))
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

def get_empleados_by_local_id (data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_empleados_by_local_id ('{}');""".format(id)
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    empleados_list = []
    
    for empleado in arr:
        empleados_list.append(clases.Empleado(empleado[0], empleado[1], empleado[2], empleado[3], empleado[4], empleado[5], empleado[6]))
    return empleados_list

def get_empleado_by_id(data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_empleados_by_id ('{}');""".format(id)
    cursor.execute(sql_command)
    arr = cursor.fetchone()
    empleado = clases.Empleado(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6])
    return empleado

def get_all_mesabillar_mantenimiento_by_id(data_base,id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_mesabillar_mantenimiento_by_id ('{}');""".format(id)
    cursor.execute(sql_command)

    arr = cursor.fetchall()
    mantenimiento_list = []
    
    for mantenimiento in arr:
        mantenimiento_list.append(clases.mesadbm(mantenimiento[0], mantenimiento[1], mantenimiento[2], mantenimiento[3], mantenimiento[4], mantenimiento[5]))
    return mantenimiento_list

def proveedor_equipamiento(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.proveedor_equipamiento();""".format()
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    proequi_list = []
    
    for proe in arr:
        
        proequi_list.append(clases.Proveedor_equipamiento(proe[0], proe[1], proe[2], proe[3]))
    return proequi_list


def proveedor_ingrediente(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.proveedor_ingrediente();""".format()
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    proing_list = []
    
    for proi in arr:
        print(proi[0], proi[1], proi[2], proi[3])
        proing_list.append(clases.Proveedor_ingrediente(proi[0], proi[1], proi[2], proi[3]))
    return proing_list

def get_all_proveedores (data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_proveedores();"""
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    proveedores_list = []
    
    for proveedor in arr:
        proveedores_list.append(clases.Proveedor(proveedor[0], proveedor[1], proveedor[2], proveedor[3], proveedor[4]))
    return proveedores_list

def get_all_equipamento_mantenimiento(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_equipamento_mantenimiento();"""
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    mequim = []
    
    for equi in arr:
        mequim.append(clases.mequi(equi[0], equi[1], equi[2], equi[3],equi[4]))
    return mequim

def get_last_checkoutmesa_id(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """SELECT db_billar.get_last_checkoutmesa_id();""".format()
    cursor.execute(sql_command)
    result = cursor.fetchone()
    return result[0]

def get_checkoutmesa_by_id(data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_checkoutmesa_by_id('{}');""".format(id)
    cursor.execute(sql_command)
    arr = cursor.fetchone()
    checkoutmesa = clases.Checkoutmesa(arr[0], arr[1], arr[2], arr[3], arr[4])
    return checkoutmesa

def get_consumibles_by_local_id (data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_consumibles_by_local_id('{}');""".format(id)
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    consumibles_list = []
    for consumibles in arr:
        consumibles_list.append(clases.Consumible(consumibles[0], consumibles[1], consumibles[2], consumibles[3], consumibles[4]))
    return consumibles_list

def get_ingredientes_by_consumible_id (data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_ingredientes_by_consumible_id('{}');""".format(id)
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    ingredientes_list = []
    for ingrediente in arr:
        ingredientes_list.append(clases.Ingrediente(ingrediente[0], ingrediente[1], ingrediente[2], None))
    return ingredientes_list

def get_mesa_comida_by_local_id (data_base, id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_mesa_comida_by_local_id('{}');""".format(id)
    cursor.execute(sql_command)
    
    arr = cursor.fetchall()
    mesa_comida_list = []
    for mesa_comida in arr:
        mesa_comida_list.append(clases.Mesacomida(mesa_comida[0], mesa_comida[1], mesa_comida[2], mesa_comida[3]))
    return mesa_comida_list

def get_ambientes_nombre_by_mesa_id(data_base, mesas_arr):
    cursor = data_base.connection.cursor()
    #nombres_list = []
    counter = 0
    for mesa in mesas_arr:
        sql_command = """SELECT db_billar.get_ambiente_name_by_id('{}');""".format(mesa.id_ambiente)
        cursor.execute(sql_command.format(mesa))
        mesas_arr[counter].id_ambiente = cursor.fetchone()[0]
        counter += 1
    
def get_all_ambientes(data_base,local_id):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_all_ambientes('{}');""".format(local_id)
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    ambientes_list = []
    for ambiente in arr:
        ambientes_list.append(clases.Ambiente(ambiente[0],ambiente[1],ambiente[2], ambiente[3]))
    return ambientes_list

def get_pagoListConsumible(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_pagoListConsumible();"""
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    pagoListConsumible = []
    for pagoListEach in arr:
        pagoListConsumible.append(clases.pagoListConsumible(pagoListEach[0],pagoListEach[1],pagoListEach[2], pagoListEach[3], pagoListEach[4]))
    return pagoListConsumible

def get_pagoListMesa(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.get_pagoListMesa();"""
    cursor.execute(sql_command)
    arr = cursor.fetchall()
    pagoListMesa = []
    for pagoListEach in arr:
        pagoListMesa.append(clases.pagoListMesa(pagoListEach[0],pagoListEach[1],pagoListEach[2], pagoListEach[3], pagoListEach[4], pagoListEach[5], pagoListEach[6]))
    return pagoListMesa

def get_totalPagoListConsumible(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """SELECT db_billar.get_totalPagoListConsumible();"""
    cursor.execute(sql_command)
    arr = cursor.fetchone()
    pagoTotalConsumible = clases.pagoTotalConsumibles(arr[0])
    return pagoTotalConsumible

def get_totalPagoListMesa(data_base):
    cursor = data_base.connection.cursor()
    sql_command = """SELECT db_billar.get_totalPagoListMesa();"""
    cursor.execute(sql_command)
    arr = cursor.fetchone()
    pagoTotalMesas = clases.pagoTotalMesas(arr[0])
    return pagoTotalMesas
