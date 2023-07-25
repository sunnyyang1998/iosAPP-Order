//
//  Product.swift
//  OrderAPP
//
//  Created by 荞汐爱吃猫 on 24/7/2023.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let description: String
    let productsID: String
    let category: String
    let price: Double
    let name: String
    let secondaryName: String
    let spicy_id: String?
    let paralysis_id: String?
    
    // JSON键的编码/解码
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case description = "descreption"
        case productsID = "ProductsID"
        case category = "Category"
        case price = "Price"
        case name = "Name"
        case secondaryName = "SecondaryName"
        case spicy_id = "spicy_id"
        case paralysis_id = "paralysis_id"
    }
}

func loadProducts(from filename: String) -> [Product] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let products = try? JSONDecoder().decode([Product].self, from: data) else {
        return []
    }

    return products
}
