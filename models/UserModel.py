from models.user import User

class UserModel():
    @classmethod
    def login(self, user_obj, data_base):
        cursor = data_base.connection.cursor()
        sql = """SELECT id, nombre, user, password, email, foto FROM test_flask.usuarios
                    WHERE user = '{}'""".format(user_obj.user)
        cursor.execute(sql)
        ROW = cursor.fetchone()
        
        print (ROW)
        if ROW != None: #Si existe el usuario
            if (user_obj.password == ROW[3]): #comparo contraseñas
                print ("NOMBRE FOTO:", ROW[5])
                new_user = User(ROW[0], ROW[1], ROW[2], True, ROW[4], ROW[5]) #Si son iguales, asigna true
            else:
                new_user = User(ROW[0], ROW[1], ROW[2], False, ROW[4], ROW[5]) #Si son diferentes, asigna false
            return new_user
        else:
            return None
    @classmethod
    def register(self, user_obj, data_base):
        cursor = data_base.connection.cursor()
        sql_check_user = """SELECT user FROM test_flask.usuarios
                    WHERE user = '{}'""".format(user_obj.user)
        cursor.execute(sql_check_user)
        ROW = cursor.fetchone()
        
        if ROW != None: #Si existe el usuario
            return False
        else: #Si no existe
            sql_insert_user = """INSERT INTO test_flask.usuarios (nombre, user, password, email, foto)
                                 VALUES ('{}', '{}', '{}', '{}', '{}')""".format(user_obj.nombre, user_obj.user, user_obj.password, user_obj.email, user_obj.profile_pic)
            cursor.execute(sql_insert_user)
            data_base.connection.commit()
            return True
    @classmethod
    def update_profile(self, user_obj, data_base):
        cursor = data_base.connection.cursor()
        sql_update = """UPDATE test_flask.usuarios SET nombre = '{}', user = '{}', password = '{}', email = '{}', foto = '{}'
                    WHERE id = '{}'""".format(user_obj.nombre, user_obj.user, user_obj.password, user_obj.email, user_obj.profile_pic, user_obj.id)
        cursor.execute(sql_update)
        data_base.connection.commit()
        return True
    @classmethod
    def get_by_id(self, data_base, id):
        cursor = data_base.connection.cursor()
        sql = "SELECT id, nombre, user, password, email, foto FROM test_flask.usuarios WHERE id = {}".format(id)
        cursor.execute(sql)
        ROW = cursor.fetchone()
        
        print (ROW)
        if ROW != None: #Si existe el usuario
            return User(ROW[0], ROW[1], ROW[2], ROW[3], ROW[4], ROW[5]) #Retorno el usuario con los datos cargados
        else:
            return None
    @classmethod
    def delete_user(self, data_base, id):
        cursor = data_base.connection.cursor()
        sql_delete = "DELETE FROM test_flask.usuarios WHERE id = {}".format(id)
        cursor.execute(sql_delete)
        data_base.connection.commit()
        return True
    @classmethod
    def get_all_users(self, data_base):
        cursor = data_base.connection.cursor()
        sql_get_all_users = "SELECT id FROM test_flask.usuarios"
        cursor.execute(sql_get_all_users)
        all_users_SQL = cursor.fetchall()
        
        all_users_list = []
        for user_id in all_users_SQL:
            user = UserModel.get_by_id(data_base, user_id[0])
            if user != None:
                all_users_list.append(user)
        return all_users_list