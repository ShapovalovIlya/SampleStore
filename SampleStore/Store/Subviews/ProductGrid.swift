//
//  ProductGrid.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 31.03.2023.
//

import SwiftUI
import StoreKit

struct ProductGrid: View {
    
    let title: String
    let products: [Product]
    let purchase: (Product) -> Void
    let isPurchased: (Product) -> Bool
    let geometry: GeometryProxy
    var rowsCount = 3
    
    private struct Drawing {
        static let descriptionSize: CGFloat = 20
        static let gridSpacing: CGFloat = 5
        static let rowMultiplier: CGFloat = 0.1
        static let widthMultiplier: CGFloat = 0.8
        static let heightMultiplier: CGFloat = 0.1
    }
    
    private var rows: [GridItem] {
        let item = GridItem(.fixed(geometry.size.height * Drawing.rowMultiplier))
        return Array(
            repeating: item,
            count: rowsCount)
    }
 
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .descriptionStyle(size: Drawing.descriptionSize)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: Drawing.gridSpacing) {
                    ForEach(products, id: \.id) { product in
                        ProductRow(
                            product: product,
                            action: purchase,
                            isPurchased: isPurchased(product),
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
