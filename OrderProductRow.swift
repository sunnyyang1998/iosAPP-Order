//
//  SavedOrdersView.swift
//  OrderAPP
//
//  Created by 荞汐爱吃猫 on 24/7/2023.
//

import SwiftUI

struct OrderProductRow: View {
    @Binding var orderProduct: OrderProduct

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(orderProduct.product.name)
                        .font(.headline)
                    Text(orderProduct.product.secondaryName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Price: \(String(format: "%.2f", orderProduct.product.price * Double(orderProduct.quantity)))")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    Text("Quantity: \(orderProduct.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            Stepper(value: $orderProduct.quantity, in: 1...Int.max) {
            }
            Button(action: {
                if let index = order.firstIndex(where: { $0.id == orderProduct.id }) {
                    order.remove(at: index)
                }
            }) {
                Image(systemName: "trash")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
