//
//  AppImageView.swift
//  
//
//  Created by Илья Шаповалов on 31.05.2023.
//

import SwiftUI

public struct AppImageView: View {
    let imageId: String
    let size: CGFloat
    let cornerRadius: CGFloat
    
    public var body: some View {
        Image(imageId, bundle: .main)
            .appIcon(
                size: size,
                cornerRadius: cornerRadius)
    }
    
    public init(
        imageId: String,
        size: CGFloat = 80,
        cornerRadius: CGFloat = 0
    ) {
        self.imageId = imageId
        self.size = size
        self.cornerRadius = cornerRadius
    }
}

struct AppImageView_Previews: PreviewProvider {
    static var previews: some View {
        AppImageView(
            imageId: "2")
    }
}
