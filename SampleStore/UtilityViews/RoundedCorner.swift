//
//  RoundedCorner.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 19.04.2023.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let cornerRadii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii)
        
        return Path(path.cgPath)
    }
}
