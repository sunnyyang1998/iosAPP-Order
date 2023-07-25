//
//  DatabaseManager.swift
//  OrderAPP
//
//  Created by 荞汐爱吃猫 on 24/7/2023.
//

import Foundation
import SQLite3

class DatabaseManager: ObservableObject {
    var db: OpaquePointer?

    init() {
        db = openDatabase()
        createTable()
    }

    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Orders.sqlite")

        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        return db
    }

    func createTable() {
        let createOrdersTableString = """
        CREATE TABLE IF NOT EXISTS Orders (
        uuid TEXT PRIMARY KEY,
        name TEXT,
        tableNumber INTEGER,
        isTakeaway INTEGER
        );
        """
        var createOrdersTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createOrdersTableString, -1, &createOrdersTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createOrdersTableStatement) == SQLITE_DONE {
                print("Orders table created.")
            } else {
                print("Orders table could not be created.")
            }
        } else {
            print("CREATE TABLE statement for Orders could not be prepared.")
        }
        sqlite3_finalize(createOrdersTableStatement)

        let createOrderProductsTableString = """
        CREATE TABLE IF NOT EXISTS OrderProducts (
        orderID TEXT,
        productID TEXT,
        quantity INTEGER,
        FOREIGN KEY(orderID) REFERENCES Orders(uuid)
        );
        """
        var createOrderProductsTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createOrderProductsTableString, -1, &createOrderProductsTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createOrderProductsTableStatement) == SQLITE_DONE {
                print("OrderProducts table created.")
            } else {
                print("OrderProducts table could not be created.")
            }
        } else {
            print("CREATE TABLE statement for OrderProducts could not be prepared.")
        }
        sqlite3_finalize(createOrderProductsTableStatement)
    }

    func insert(order: Order) {
        let insertOrderString = "INSERT INTO Orders (uuid, name, tableNumber, isTakeaway) VALUES (?, ?, ?, ?);"
        var insertOrderStatement: OpaquePointer?
        
        let insertOrderProductString = "INSERT INTO OrderProducts (orderID, productID, quantity) VALUES (?, ?, ?);"
        var insertOrderProductStatement: OpaquePointer?
        
        sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil)

        if sqlite3_prepare_v2(db, insertOrderString, -1, &insertOrderStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertOrderStatement, 1, (order.id.uuidString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertOrderStatement, 2, (order.name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertOrderStatement, 3, Int32(order.tableNumber))
            sqlite3_bind_int(insertOrderStatement, 4, order.isTakeaway ? 1 : 0)

            if sqlite3_step(insertOrderStatement) == SQLITE_DONE {
                if sqlite3_prepare_v2(db, insertOrderProductString, -1, &insertOrderProductStatement, nil) == SQLITE_OK {
                    for product in order.orderProducts {
                        sqlite3_bind_text(insertOrderProductStatement, 1, (order.id.uuidString as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertOrderProductStatement, 2, (product.product.id.uuidString as NSString).utf8String, -1, nil)
                        sqlite3_bind_int(insertOrderProductStatement, 3, Int32(product.quantity))
                        if sqlite3_step(insertOrderProductStatement) != SQLITE_DONE {
                            print("Could not insert order product.")
                        }
                        sqlite3_reset(insertOrderProductStatement)
                    }
                } else {
                    print("INSERT order product statement could not be prepared.")
                }
            } else {
                print("Could not insert order.")
            }
        } else {
            print("INSERT order statement could not be prepared.")
        }

        sqlite3_finalize(insertOrderStatement)
        sqlite3_finalize(insertOrderProductStatement)
        sqlite3_exec(db, "COMMIT TRANSACTION", nil, nil, nil)
    }
    
    func deleteAllOrders() {
        let deleteOrderProductsStatementString = "DELETE FROM OrderProducts;"
        var deleteOrderProductsStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteOrderProductsStatementString, -1, &deleteOrderProductsStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteOrderProductsStatement) == SQLITE_DONE {
                print("Successfully deleted all order products.")
            } else {
                print("Could not delete all order products.")
            }
        } else {
            print("DELETE statement for OrderProducts could not be prepared.")
        }
        sqlite3_finalize(deleteOrderProductsStatement)

        let deleteOrdersStatementString = "DELETE FROM Orders;"
        var deleteOrdersStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteOrdersStatementString, -1, &deleteOrdersStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteOrdersStatement) == SQLITE_DONE {
                print("Successfully deleted all orders.")
            } else {
                print("Could not delete all orders.")
            }
        } else {
            print("DELETE statement for Orders could not be prepared.")
        }
        sqlite3_finalize(deleteOrdersStatement)
    }
}
