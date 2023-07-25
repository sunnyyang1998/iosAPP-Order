//
//  ContentView.swift
//  OrderAPP
//
//  Created by 荞汐爱吃猫 on 24/7/2023.
//

import SwiftUI

struct ContentView: View {
    // 假设你的 JSON 文件名为 "products"
    let products = loadProducts(from: "product")
    
    // 使用 Dictionary 将产品按类别分组
    var categories: [String: [Product]] {
        Dictionary(grouping: products, by: \.category)
    }
    
    // 存储按照字母顺序排序的类别
    var categoryOrder: [String] {
        Array(categories.keys).sorted() // Sort the keys alphabetically
    }
    
    // 当前选中的类别
    @State private var selectedCategory: String?
    
    // 创建 OrderManager 对象
    @StateObject private var orderManager = OrderManager()

    // State to control the presentation of SavedOrderView
    @State private var showingSavedOrders = false

    var body: some View {
        NavigationView {
            // SideBar 用于选择类别
            List(categoryOrder, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(category)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200)
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Show Saved Orders") {
                        showingSavedOrders = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }

            // 主视图显示选中类别的产品列表
            if let category = selectedCategory, let products = categories[category] {
                List(products) { product in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text(product.secondaryName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Price: \(String(format: "%.2f", product.price))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        // 添加到订单的按钮
                        Button(action: {
                            orderManager.add(product)
                        }) {
                            Text("Add")
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
                .navigationTitle(category)
            }
            
            // 订单视图
            if !orderManager.order.isEmpty {
                OrderView(order: $orderManager.order)
                    .navigationTitle("Order")
            }
        }
        .sheet(isPresented: $showingSavedOrders) {
            OrderProductRow(databaseManager: DatabaseManager())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
