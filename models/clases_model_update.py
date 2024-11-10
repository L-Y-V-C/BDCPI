def update_mesa_billar (data_base, mesa_obj):
    cursor = data_base.connection.cursor()
    sql_command = """CALL db_billar.update_mesabillar('{}', '{}', '{}', '{}', '{}', '{}');""".format(
        mesa_obj.id, 
        mesa_obj.tipo,
        mesa_obj.estado, 
        mesa_obj.id_mantenimiento, 
        mesa_obj.id_pago_com, 
        mesa_obj.id_ambiente
    )
    print (mesa_obj.id, "   " ,mesa_obj.tipo, "  " ,mesa_obj.estado)
    cursor.execute(sql_command)
    data_base.connection.commit()