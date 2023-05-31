//
//  AppBackgroundView.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 02.04.2023.
//

import SwiftUI

/// AppBackgroundView is a container view that defines its content as a function of its own size and coordinate space.
/// This view provide regular Ensoul background with WaveView.
public struct AppBackgroundView<Content>: View where Content: View {
    private let content: (GeometryProxy) -> Content
    private let multiplier: CGFloat = 0.045
    
    public var body: some View {
        GeometryReader { geometryProxy in
            ZStack(alignment: .top) {
                Color.background.ignoresSafeArea()
                WaveView()
                content(geometryProxy)
            }
        }
    }
    
    public init(
        @ViewBuilder content: @escaping (GeometryProxy) -> Content
    ) {
        self.content = content
    }
}

struct AppBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        AppBackgroundView { _ in
            VStack {
                Spacer()
                Text("Hello!")
                    .titleStyle()
                Spacer()
            }
        }
    }
}
