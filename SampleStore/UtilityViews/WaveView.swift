//
//  WaveView.swift
//  Ensoul
//
//  Created by  Юлия Григорьева on 12.03.2023.
//

import SwiftUI

public struct WaveView: View {
    @State private var change = false
    
    public var body: some View {
        ZStack(alignment: .top) {
            Wave(yOffset: change ? 0.7 : -0.7)
                .fill(LinearGradient(colors: [Color.purpleColor, Color.blue], startPoint: .leading, endPoint: .trailing))
                .frame(height: 150)
                .shadow(radius: 5)
                .padding(.horizontal, -30)
                .animation(Animation.easeInOut(duration: 1.5).repeatCount(5), value: change)
            Wave(yOffset: change ? 0.7 : -0.7)
                .fill(Color.buttonColor)
                .opacity(0.8)
                .frame(height: 130)
                .shadow(radius: 5)
                .padding(.horizontal, -10)
                .animation(Animation.easeInOut(duration: 2).repeatCount(5), value: change)
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            change.toggle()
        }
    }
    
    public init() {}
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView()
    }
}
