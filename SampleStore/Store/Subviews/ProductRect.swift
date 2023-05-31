//
//  ProductRect.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 29.03.2023.
//

import SwiftUI
import StoreKit

struct ProductRect: View {
    
    let subscription: Product
    let action: (Product) -> Void
    let isPurchased: Bool
    let geometry: GeometryProxy
    
    private struct Drawing {
        static let titleSize: CGFloat = 15
        static let labelsMultiplier: CGFloat = 0.1
        static let cornerRadius: CGFloat = 10
    }
    
    var body: some View {
        VStack {
            Image(subscription.id)
                .resizable()
            HStack {
                VStack(alignment: .leading) {
                    Text(subscription.displayName)
                        .titleStyle(size: Drawing.titleSize)
                    Text(subscription.description)
                        .descriptionStyle()
                }
                Spacer()
                AppBuyButton(
                    product: subscription,
                    action: action,
                    isPurchased: isPurchased)
            }
            .padding(.horizontal)
            .frame(height: geometry.size.height * Drawing.labelsMultiplier)
        }
        .thinBackground(cornerRadius: Drawing.cornerRadius)
        .cornerRadius(Drawing.cornerRadius)
    }
}
