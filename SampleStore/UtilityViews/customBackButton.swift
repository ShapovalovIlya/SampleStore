//
//  customBackButton.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 07.03.2023.
//

import SwiftUI

/// Returns custom navigation bar back button.
/// - Parameter presentationMode: A binding to the current presentation mode of the view associated with this environment.
/// - Returns: ToolbarContent with navigation back button
@ToolbarContentBuilder public func backButton(presentationMode: Binding<PresentationMode>) -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: Icons.NavigationBar.backButton)
                .resizable()
                .foregroundColor(.white)
        }
    }
}


/// Returns custom navigation bar back button.
/// - Parameter dismiss: An action that dismisses the current presentation.
/// - Returns: ToolbarContent with navigation back button
@ToolbarContentBuilder public func backButton(dismiss: DismissAction) -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
        Button {
            dismiss.callAsFunction()
        } label: {
            Image(systemName: Icons.NavigationBar.backButton)
                .resizable()
                .foregroundColor(.white)
        }
    }
}
