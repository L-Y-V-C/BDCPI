class Product():
    id = 0
    user_id = 0
    nombre = ""
    descripcion = ""
    precio = 0
    product_pic = ''
    status = 0
    buyer_id = 0
    
    def __init__(self, in_id, in_user_id, in_nombre, in_descripcion, in_precio, in_pic, in_status, in_buyer_id):
        self.id = in_id
        self.user_id = in_user_id
        self.nombre = in_nombre
        self.descripcion = in_descripcion
        self.precio = in_precio
        self.product_pic = in_pic
        self.status = in_status
        self.buyer_id = in_buyer_id