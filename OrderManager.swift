//
//  OrderManager.swift
//  OrderAPP
//
//  Created by 荞汐爱吃猫 on 24/7/2023.
//

import Foundation

class OrderManager: ObservableObject {
    @Published var order = [OrderItem]()
    @Published var tableNumber: Int?

    var totalQuantity: Int {
        return order.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        return order.reduce(0) { $0 + Double($1.quantity) * $1.product.price }
    }

    func add(_ product: Product) {
        if let index = order.firstIndex(where: { $0.product.id == product.id }) {
            order[index].quantity += 1
        } else {
            order.append(OrderItem(product: product, quantity: 1))
        }
    }

    func remove(at index: Int) {
        if order[index].quantity > 1 {
            order[index].quantity -= 1
        } else {
            order.remove(at: index)
        }
    }
}
