//
//  Strings.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 07.03.2023.
//

import Foundation

/// Struct contains app localized strings
public struct Strings {
    /// Store module
    public struct Store {
        /// Main screen
        public struct Main {
            public static let content_subscriptions = "Подписки"
            public static let content_meditations = "Медитации"
            public static let content_artTherapy = "Арт практики"
            public static let content_moneyThinking = "Курс «Денежный магнит»"
            public static let my_purchase = "Мои покупки"
        }
        /// Purchased screen
        public struct Purchased {
            public static let manager_title = "Мои покупки"
            public static let manager_non_consumables = "Практики"
            public static let manager_subscriptions = "Подписки"
            public static let manager_manage_button = "Управлять подписками"
        }
        /// Purchased product detail screen
        public struct Detail {
            public static let purchaseDate = "Покупка от"
            public static let error = "Недоступно"
            public static let refundButton = "Запросить возврат"
        }
    }
}

