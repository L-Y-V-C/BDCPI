from models.productModel import ProductModel

class UserProductModel():
    
    @classmethod
    def get_products_by_user_id(self, data_base, user_id):
        cursor = data_base.connection.cursor()
        sql_get_products = """SELECT id_usuario FROM test_flask.productos WHERE id_usuario = {}""".format(user_id)
        cursor.execute(sql_get_products)
        products_SQL = cursor.fetchall()
        
        products_list = []
        for products_id in products_SQL:
            product = ProductModel.get_by_id(data_base, products_id[0])
            if product != None:
                products_list.append(product)
        return products_list
    
    @classmethod
    def get_all_products(self, data_base):
        cursor = data_base.connection.cursor()
        sql_get_all_products = "SELECT id FROM test_flask.productos"
        cursor.execute(sql_get_all_products)
        all_products_SQL = cursor.fetchall()
        
        all_products_list = []
        for product_id in all_products_SQL:
            product = ProductModel.get_by_id(data_base, product_id[0])
            if product != None:
                all_products_list.append(product)
        return all_products_list