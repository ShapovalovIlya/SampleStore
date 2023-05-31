//
//  View.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 31.03.2023.
//

import SwiftUI

public extension View {
    func backgroundBlur(radius: CGFloat = 3, opaque: Bool = false) -> some View {
        self
            .background(
                Blur(radius: radius, opaque: opaque))
    }
    
    func innerShadow<S: Shape, SS: ShapeStyle>(shape: S, color: SS, lineWidth: CGFloat = 1, offsetX: CGFloat = 0, offsetY: CGFloat = 0, blur: CGFloat = 4, blendMode: BlendMode = .normal, opacity: Double = 1) -> some View {
        return self
            .overlay {
                shape
                    .stroke(color, lineWidth: lineWidth)
                    .blendMode(blendMode)
                    .offset(x: offsetX, y: offsetY)
                    .blur(radius: blur)
                    .mask(shape)
                    .opacity(opacity)
                
            }
    }
    
    func navigationItemFrame() -> some View {
        self.frame(width: 30, height: 30)
    }
    
    func thinBackground(
        cornerRadius: CGFloat = 12,
        blurRadius: CGFloat = 25
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius)
        return self
            .backgroundBlur(radius: blurRadius, opaque: true)
            .clipShape(shape)
            .innerShadow(
                shape: shape,
                color: Color.white,
                lineWidth: 2,
                offsetX: 0,
                offsetY: 0,
                blur: 7,
                blendMode: .overlay,
                opacity: 1)
    }
    
    
    /// Replace default navigation back button with custom.
    /// - Parameter dismissAction: any defined @Environment(\.dismiss) property.
    /// - Returns: custom navigation back button.
    func replaceNavigationBackButton(dismissAction: DismissAction) -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .toolbar { backButton(dismiss: dismissAction) }
    }
    
    func cornersRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    
    /// Create graphic snapshot of the View.
    /// - Returns: UIImage with snapshot of current View.
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func titleStyle(
        size: CGFloat = 25,
        color: Color = .white,
        textAlignment: TextAlignment = .center
    ) -> some View {
        self.font(Font.system(size: size))
            .bold()
            .foregroundColor(color)
            .multilineTextAlignment(textAlignment)
    }
    
    func descriptionStyle(
        size: CGFloat = 15,
        color: Color = .white,
        textAlignment: TextAlignment = .leading
    ) -> some View {
        self.font(Font.system(size: size))
            .foregroundColor(color)
            .multilineTextAlignment(textAlignment)
    }
}
