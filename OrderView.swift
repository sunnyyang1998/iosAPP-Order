//
//  OrderView.swift
//  OrderAPP
//
//  Created by 荞汐爱吃猫 on 24/7/2023.
//

import SwiftUI

struct OrderProduct: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}

struct Order: Identifiable {
    let id: UUID
    let name: String
    let tableNumber: Int
    let isTakeaway: Bool
    let orderProducts: [OrderProduct]
}

struct OrderView: View {
    @Binding var order: [OrderProduct]
    @StateObject var databaseManager = DatabaseManager()
    
    @State private var selectedTableNumber = 1
    @State private var isTakeaway = false
    @State private var showingSavedOrders = false

    var totalQuantity: Int {
        order.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        order.reduce(0) { $0 + Double($1.quantity) * $1.product.price }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Total Quantity: \(totalQuantity)")
                Spacer()
                Text("Total Price: \(String(format: "%.2f", totalPrice))")
            }
            .padding()

            List {
                ForEach(order) { item in
                    if let index = order.firstIndex(where: { $0.id == item.id }) {
                        OrderProductRow(orderProduct: $order[index])
                    }
                }
                .onDelete(perform: delete)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Table Number", selection: $selectedTableNumber) {
                        ForEach(1...20, id: \.self) { tableNumber in
                            Text("Table \(tableNumber)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle("Takeaway", isOn: $isTakeaway)
                        .toggleStyle(SwitchToggleStyle(tint: .orange))
                }
            }

            if !order.isEmpty {
                HStack {
                    Spacer()
                    Button("Confirm Order") {
                        let savedOrder = Order(id: UUID(), name: "Order \(selectedTableNumber)", tableNumber: selectedTableNumber, isTakeaway: isTakeaway, orderProducts: order)
                        databaseManager.insert(order: savedOrder)
                        order.removeAll()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingSavedOrders) {
            OrderProductRow(databaseManager: databaseManager)
        }
    }
    
    func delete(at offsets: IndexSet) {
        order.remove(atOffsets: offsets)
    }
}
