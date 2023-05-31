//
//  ProductRow.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 29.03.2023.
//

import SwiftUI
import StoreKit

struct ProductRow: View {
    
    let product: Product
    let action: (Product) -> Void
    let isPurchased: Bool
    let geometry: GeometryProxy
    
    private struct Drawing {
        static let rowSpacing: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let heightMultiplier: CGFloat = 0.1
    }
    
    var body: some View {
        HStack(spacing: Drawing.rowSpacing) {
            AppImageView(
                imageId: product.id,
                size: geometry.size.height * Drawing.heightMultiplier,
                cornerRadius: Drawing.cornerRadius)
            Text(product.displayName)
                .descriptionStyle()
            Spacer()
            AppBuyButton(
                product: product,
                action: action,
                isPurchased: isPurchased)
        }
        .padding(.trailing)
        .thinBackground(cornerRadius: Drawing.cornerRadius)
        .cornerRadius(Drawing.cornerRadius)
    }
    
}
