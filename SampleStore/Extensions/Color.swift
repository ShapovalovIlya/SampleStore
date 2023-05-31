//
//  Color.swift
//  Ensoul
//
//  Created by  Юлия Григорьева on 02.03.2023.
//

import SwiftUI

public extension Color {

    static let background = Color("Deep Purple 2", bundle: .main)
    static let purpleColor = Color("Deep Purple", bundle: .main)
    static let buttonColor = Color("Blue 2", bundle: .main)
    static let brightPurpleColor = Color("Bright Purple", bundle: .main)
    static let backgroundGradient = RadialGradient(colors: [Color.buttonColor, Color.background],
                                   center: .topLeading,
                                   startRadius: 5,
                                   endRadius: 400)
    static let backGradient = RadialGradient(colors: [Color.buttonColor, Color.background],
                                    center: .topLeading,
                                    startRadius: 5,
                                    endRadius: 400)


}
