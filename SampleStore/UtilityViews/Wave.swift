//
//  Wave.swift
//  Ensoul
//
//  Created by  Юлия Григорьева on 12.03.2023.
//

import SwiftUI

struct Wave: Shape {

    var yOffset: CGFloat = 0.75

    var animatableData: CGFloat {
        get {
            return yOffset
        }
        set {
            yOffset = newValue
        }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX * 0.75, y: rect.maxY - (rect.maxY * yOffset)),
                      control2: CGPoint(x: rect.maxX * 0.25, y: rect.maxY + rect.maxY * yOffset)
                      )
        path.closeSubpath()
        return path
    }

}

struct Wave_Previews: PreviewProvider {
    static var previews: some View {
        Wave()
            .stroke(Color.red, lineWidth: 5)
            .frame(height: 150)
//            .frame(height: 150)
            .padding()
    }
}

//func path(in rect: CGRect) -> Path {
//    var path = Path()
//    path.move(to: .zero)
//    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//
//    path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
//                  control1: CGPoint(x: rect.midY + 150, y: rect.midX),
//                  control2: CGPoint(x: rect.midX, y: rect.minY)
//                  )
//    path.closeSubpath()
//    return path
//}
