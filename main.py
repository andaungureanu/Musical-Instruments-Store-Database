import cx_Oracle
import matplotlib.pyplot as plt

class OracleConnection:
    def __init__(self, username, password, host, port, sid):
        self.host = host
        self.port = port
        self.sid = sid
        self.username = username
        self.password = password

    def openConnection(self):
        try:
            url = self.username + '/' + self.password + '@' + self.host + ':' + self.port + '/' + self.sid
            self.db = cx_Oracle.connect(url)
            self.cursor = self.db.cursor()
            print("Connection open!")
        except Exception as e:
            print("Connection not open!")
            print(e)

    def closeConnection(self):
        try:
            self.cursor.close()
            self.db.close()
            print("Connection close!")
        except Exception as e:
            print("Connection not closed!")
            print(e)

    def get_favorite_manufacturers(self):
        try:
            manufacturers = []
            chosen_by = []
            result = self.cursor.var(cx_Oracle.CURSOR)
            self.cursor.callproc("GET_FAVORITE_MANUFACTURERS", [result]) 
            for elem in result.getvalue():
                manufacturers.append(elem[0])
                chosen_by.append(elem[1])
            n = [x for x in range(1, len(manufacturers) + 1)]
            plt.bar(n, chosen_by, tick_label = manufacturers)
            plt.xlabel('Manufacturers')
            plt.ylabel('Chosen by .. people')
            plt.title('Top 5 manufacturers')
            plt.show()
        except Exception as e:
            print(e)

    def get_favorite_instruments(self):
        try:
            instruments = []
            times_bought = []
            result = self.cursor.var(cx_Oracle.CURSOR)
            self.cursor.callproc("GET_FAVORITE_INSTRUMENTS", [result]) 
            for elem in result.getvalue():
                instruments.append(elem[3] + ': ' + elem[0] + ', ' + elem[1])
                times_bought.append(elem[2])
            n = [x for x in range(1, len(instruments) + 1)]
            plt.bar(n, times_bought, tick_label = instruments)
            plt.xlabel('Customers and their instruments')
            plt.ylabel('Bought .. times')
            plt.title('Top 3 same instruments bought by the same person')
            plt.show()
        except Exception as e:
            print(e)

    def get_most_expensive_orders(self):
        try:
            names = []
            paid = []
            result = self.cursor.var(cx_Oracle.CURSOR)
            self.cursor.callproc("GET_MOST_EXPENSIVE_ORDERS", [result]) 
            for elem in result.getvalue():
                names.append(elem[0])
                paid.append(elem[1])
            n = [x for x in range(1, len(names) + 1)]
            plt.bar(n, paid, tick_label = names)
            plt.xlabel('Customers')
            plt.ylabel('Paid')
            plt.title('Top 5 most expensive orders')
            plt.show()
        except Exception as e:
            print(e)

if __name__ == "__main__":
    cx_Oracle.init_oracle_client(lib_dir=r"C:\instantclient_21_8")
    oc = OracleConnection('system', 'parolaAiaPuternic4', 'localhost', '1521', 'XE')
    oc.openConnection()
    oc.get_favorite_manufacturers()
    oc.get_favorite_instruments()
    oc.get_most_expensive_orders()
    oc.closeConnection()
    