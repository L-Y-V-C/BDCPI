class Cliente:
    id = 0
    nombre = ""
    apellidos = ""
    tipo = ""
    id_mesa_billar = 0
    id_pago_com = 0
    id_mesa_comida = 0
    
    def __init__(self, id, nombre, apellidos, tipo, id_mesa_billar, id_pago_com, id_mesa_comida):
        self.id = id
        self.nombre = nombre
        self.apellidos = apellidos
        self.tipo = tipo
        self.id_mesa_billar = id_mesa_billar
        self.id_pago_com = id_pago_com
        self.id_mesa_comida = id_mesa_comida

class Casillero:
    id = 0
    numero = 0
    id_cliente = 0
    
    def __init__(self, id, numero, id_cliente):
        self.id = id
        self.numero = numero
        self.id_cliente = id_cliente

class Pago:
    id = 0
    metodo = ""
    id_pago_com = 0
    id_pedido_consumible = 0
    
    def __init__(self, id, metodo, id_pago_com, id_pedido_consumible):
        self.id = id
        self.metodo = metodo
        self.id_pago_com = id_pago_com
        self.id_pedido_consumible = id_pedido_consumible

class Mesabillar:
    id = 0
    tipo = ""
    estado = ""
    id_mantenimiento = 0
    id_pago_com = 0
    id_ambiente = 0
    
    def __init__(self, id, tipo, estado, id_mantenimiento, id_pago_com, id_ambiente):
        self.id = id
        self.tipo = tipo
        self.estado = estado
        self.id_mantenimiento = id_mantenimiento
        self.id_pago_com = id_pago_com
        self.id_ambiente = id_ambiente

class Mesacomida:
    id = 0
    capacidad = 0
    numero = 0
    id_ambiente = 0
    
    def __init__(self, id, capacidad, numero, id_ambiente):
        self.id = id
        self.capacidad = capacidad
        self.numero = numero
        self.id_ambiente = id_ambiente

class Ambiente:
    id = 0
    nombre = ""
    capacidad = 0
    id_local = 0
    
    def __init__(self, id, nombre, capacidad, id_local):
        self.id = id
        self.nombre = nombre
        self.capacidad = capacidad
        self.id_local = id_local

class Checkoutmesa:

    def __init__(self, id_pago_com, precio_hora, hora_fin, hora_inicio, id_local):
        self.id_pago_com = id_pago_com
        self.precio_hora = precio_hora
        self.hora_fin = hora_fin
        self.hora_inicio = hora_inicio
        self.id_local = id_local

class Empleado:
    dni = 0
    telefono = ""
    nombre = ""
    apellido = ""
    cargo = ""
    correo_electronico = ""
    id_local = 0
    
    def __init__(self, dni, telefono, nombre, apellido, correo_electronico, cargo, id_local):
        self.dni = dni
        self.telefono = telefono
        self.nombre = nombre
        self.apellido = apellido
        self.cargo = cargo
        self.correo_electronico = correo_electronico
        self.id_local = id_local

class Mantenimiento:
    id = 0
    fecha = ""
    descripcion = ""
    
    def __init__(self, id, fecha, descripcion):
        self.id = id
        self.fecha = fecha
        self.descripcion = descripcion

class Equipamiento:
    id = 0
    tipo = ""
    descripcion = ""
    id_proveedor = 0
    id_mantenimiento = 0
    
    def __init__(self, id, tipo, descripcion, id_proveedor, id_mantenimiento):
        self.id = id
        self.tipo = tipo
        self.descripcion = descripcion
        self.id_proveedor = id_proveedor
        self.id_mantenimiento = id_mantenimiento

class Proveedor:
    id = 0
    nombre = ""
    correo_electronico = ""
    tipo = ""
    telefono = ""
    
    def __init__(self, id, nombre, correo_electronico, tipo, telefono):
        self.id = id
        self.nombre = nombre
        self.correo_electronico = correo_electronico
        self.tipo = tipo
        self.telefono = telefono

class PedidoConsumible:
    id = 0
    id_cliente = 0
    id_local = 0
    
    def __init__(self, id, id_cliente, id_local):
        self.id = id
        self.id_cliente = id_cliente
        self.id_local = id_local

class LocalConsumible:
    id_consumible = 0
    id_local = 0
    
    def __init__(self, id_consumible, id_local):
        self.id_consumible = id_consumible
        self.id_local = id_local

class Consumible:
    id = 0
    precio = 0.0
    descripcion = ""
    nombre = ""
    stock = 0
    
    def __init__(self, id, precio, descripcion, nombre, stock):
        self.id = id
        self.precio = precio
        self.descripcion = descripcion
        self.nombre = nombre
        self.stock = stock

class Ingrediente:
    id = 0
    nombre = ""
    cantidad = 0
    id_proveedor = 0
    
    def __init__(self, id, nombre, cantidad, id_proveedor):
        self.id = id
        self.nombre = nombre
        self.cantidad = cantidad
        self.id_proveedor = id_proveedor

class IngredienteConsumible:
    id_ingrediente = 0
    id_consumible = 0
    
    def __init__(self, id_ingrediente, id_consumible):
        self.id_ingrediente = id_ingrediente
        self.id_consumible = id_consumible

class Local:
    id = 0
    direccion = ""
    hora_apertura = ""
    hora_cierre = ""
    
    def __init__(self, id, direccion, hora_apertura, hora_cierre):
        self.id = id
        self.direccion = direccion
        self.hora_apertura = hora_apertura
        self.hora_cierre = hora_cierre
        
class PedidoConsumible_Consumible:
    id_consumible = 0
    id_pedido_consumible = 0
    
    def __init__(self, id_consumible, id_pedido_consumible):
        self.id_consumible = id_consumible
        self.id_pedido_consumible = id_pedido_consumible

class MontoMesa:
    def __init__(self, IDPago, IDPagoCOM, PrecioHora, HoraInicio, HoraFin, MontoMesa):
        self.IDPago = IDPago
        self.IDPagoCOM = IDPagoCOM
        self.PrecioHora = PrecioHora
        self.HoraInicio = HoraInicio
        self.HoraFin = HoraFin
        self.MontoMesa = MontoMesa

class MontoConsumible:
    def __init__(self, IDPago, IDPedidoConsumible, IDConsumible, Nombre, Precio):
        self.IDPago = IDPago
        self.IDPedidoConsumible = IDPedidoConsumible
        self.IDConsumible = IDConsumible
        self.Nombre = Nombre
        self.Precio = Precio

class MontoTotal:
    def __init__(self, MontoMesa, MontoConsumible, MontoTotal):
        self.MontoMesa = MontoMesa
        self.MontoConsumible = MontoConsumible
        self.MontoTotal = MontoTotal

class InfoLocal:
    id_local=0
    direccion=""
    nombre=""
    id_mesa_billar=0
    id_mesa_comida=0
    def __init__(self, id_local,direccion, nombre, id_mesa_billar, id_mesa_comida):
        self.id_local=id_local
        self.direccion = direccion
        self.nombre = nombre
        self.id_mesa_billar = id_mesa_billar 
        self.id_mesa_comida = id_mesa_comida 
    def __repr__(self):
        return f"InfoLocal(id_local={self.id_local}, direccion={self.direccion}, nombre={self.nombre}, id_mesa_billar={self.id_mesa_billar}, id_mesa_comida={self.id_mesa_comida})"


class mesadbm:
    def __init__(self,id_mesa_mante,m_tipo,id_manteni,m_fecha,m_descripcion,am_idambiente):
        self.id_mesa_mante=id_mesa_mante
        self.m_tipo=m_tipo
        self.id_manteni=id_manteni
        self.m_fecha=m_fecha
        self.m_descripcion=m_descripcion
        self.am_idambiente=am_idambiente
    
class InfoLocal:
    id_local=0
    direccion=""
    nombre=""
    id_mesa_billar=0
    id_mesa_comida=0
    def __init__(self, id_local,direccion, nombre, id_mesa_billar, id_mesa_comida):
        self.id_local=id_local
        self.direccion = direccion
        self.nombre = nombre
        self.id_mesa_billar = id_mesa_billar 
        self.id_mesa_comida = id_mesa_comida 
    def __repr__(self):
        return f"InfoLocal(id_local={self.id_local}, direccion={self.direccion}, nombre={self.nombre}, id_mesa_billar={self.id_mesa_billar}, id_mesa_comida={self.id_mesa_comida})"

    
class Proveedor_ingrediente:
    nombre_proveedor=""
    correo=""
    nombre_ingrediente=""
    cantidad=0
    def __init__(self,nombre_proveedor,correo,nombre_ingrediente,cantidad):
        self.nombre_proveedor=nombre_proveedor
        self.correo=correo
        self.nombre_ingrediente=nombre_ingrediente
        self.cantidad=cantidad

class Proveedor_equipamiento:
    nombre=""
    correo=""
    tipo=""
    descripcion=""
    def __init__(self,nombre,correo,tipo,descripcion):
        self.nombre=nombre
        self.correo=correo
        self.tipo=tipo
        self.descripcion=descripcion
        
class mequi:
    def __init__(self,id_equi,tipo,fecha,e_descripcion,m_descripcion):
        self.id_equi=id_equi
        self.tipo=tipo
        self.fecha=fecha
        self.e_descripcion=e_descripcion
        self.m_descripcion=m_descripcion

class pagoListConsumible:
    def __init__(self, id_pago, metodo, idpc, nombre, precio):
        self.id_pago = id_pago
        self.metodo = metodo
        self.idpc = idpc
        self.nombre = nombre
        self.precio = precio

class pagoListMesa:
    def __init__(self, id_pago, metodo, idpc, precioHora, inicio, fin, monto):
        self.id_pago = id_pago
        self.metodo = metodo
        self.idpc = idpc
        self.precioHora = precioHora
        self.inicio = inicio
        self.fin = fin
        self.monto = monto

class pagoTotalConsumibles:
    def __init__(self, total):
        self.total = total

class pagoTotalMesas:
    def __init__(self, total):
        self.total = total