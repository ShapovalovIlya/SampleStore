//
//  Icons.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 12.03.2023.
//

import SwiftUI

/// Single source of icons. It contains Image(systemName:), Image(_ name:) for icons.
public struct Icons {
    /// Navigation Bar icons
    public struct NavigationBar {
        public static let backButton = "chevron.backward.circle"
    }
    //MARK: - Store
    /// Store icons
    public struct Store {
        /// Main screen
        public struct Main {
            public static let buyButtonIcon = "checkmark"
            public static let navigationButton_purchased = "chevron.forward"
        }
        /// Purchased manager
        public struct Purchased {
            public static let FAQ = "info.bubble"
            public static let chevron = "chevron.forward"
        }
    }
    
}
