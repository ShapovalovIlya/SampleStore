//
//  SubscriptionsGrid.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 31.03.2023.
//

import SwiftUI
import StoreKit

struct SubscriptionsGrid: View {
    
    let title: String
    let subscriptions: [Product]
    let purchase: (Product) -> Void
    let isPurchased: (Product) -> Bool
    let geometry: GeometryProxy
    
    private struct Drawing {
        static let widthMultiplier: CGFloat = 0.8
        static let heightMultiplier: CGFloat = 0.43
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .descriptionStyle(size: 20)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(subscriptions, id: \.id) { subscription in
                        ProductRect(
                            subscription: subscription,
                            action: purchase,
                            isPurchased: isPurchased(subscription),
                            geometry: geometry)
                        .frame(
                            width: geometry.size.width * Drawing.widthMultiplier,
                            height: geometry.size.height * Drawing.heightMultiplier)
                    }
                }
            }
            Divider()
                .background(Color.buttonColor)
        }
    }
}
