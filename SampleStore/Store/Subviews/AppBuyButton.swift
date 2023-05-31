//
//  AppBuyButton.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 30.03.2023.
//

import SwiftUI
import StoreKit

struct AppBuyButton: View {
    
    let product: Product
    let action: (Product) -> Void
    let isPurchased: Bool
    
    private struct Drawing {
        static let cornerRadius: CGFloat = 10
    }
    
    var body: some View {
        Button {
            action(product)
        } label: {
            if isPurchased {
                Image(systemName: Icons.Store.Main.buyButtonIcon)
            } else {
                Text(product.displayPrice)
            }
        }
        .background(isPurchased ? .green : .background)
        .animation(.easeInOut, value: isPurchased)
        .disabled(isPurchased)
        .foregroundColor(.white)
        .buttonStyle(.bordered)
        .cornerRadius(Drawing.cornerRadius)
    }
    
}
