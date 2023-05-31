//
//  Image.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 05.04.2023.
//

import SwiftUI

public extension Image {
    func appIcon(size: CGFloat = 80, cornerRadius: CGFloat = 0) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .cornersRadius(cornerRadius)
    }
    
}
