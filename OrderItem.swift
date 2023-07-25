//
//  OrderItem.swift
//  OrderAPP
//
//  Created by 荞汐爱吃猫 on 24/7/2023.
//

import Foundation

struct OrderItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}

