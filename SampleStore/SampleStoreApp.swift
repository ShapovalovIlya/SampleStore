//
//  SampleStoreApp.swift
//  SampleStore
//
//  Created by Илья Шаповалов on 31.05.2023.
//

import SwiftUI

@main
struct SampleStoreApp: App {
    let store: StoreServiceProtocol
    let viewModel: StoreViewModel
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StoreView(
                    viewModel: viewModel,
                    purchasedModule: EmptyView.init)
            }
            .onAppear(perform: setupNavigationBarAppearance)
        }
    }
    
    private func setupNavigationBarAppearance() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.clear
        standardAppearance.shadowImage = nil
        standardAppearance.shadowColor = .none
        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().compactAppearance = standardAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
    }
    
    init() {
        self.store = StoreService()
        store.set(productIDs: productIDs)
        self.viewModel = StoreViewModel(storeService: store)
    }
}

let productIDs: [String] = [
    "com.ensoul.meditation_abundance",
    "com.ensoul.meditation_manifestation_of_intention",
    "com.ensoul.meditation_love",
    "com.ensoul.meditation_elixir_of_life",
    "com.ensoul.meditation_set_solar_energy",
    "com.ensoul.meditation_river_of_life",
    "com.ensoul.meditation_morning_gratitude",
    "com.ensoul.meditation_ball_of_light",
    "com.ensoul.meditation_god_gifts_are_my_gifts",
    "com.ensoul.meditation_hooponopono",
    "com.ensoul.meditation_wish_tree",
    
    "com.ensoul.art_therapy_health",
    "com.ensoul.art_therapy_tranquility_and_relaxation",
    "com.ensoul.art_therapy_open_heart_center",
    "com.ensoul.art_therapy_abundance_and_prosperity",
    "com.ensoul.art_therapy_fulfillment_of_dreams",
    "com.ensoul.art_therapy_self_worth",
    "com.ensoul.art_therapy_i_am_worthy",
    
    "com.ensoul.money_thinking_beliefs_and_attitudes",
    "com.ensoul.money_thinking_monetary_energy_and_expansion",
    "com.ensoul.money_thinking_habits_of_poor_and_rich",
    "com.ensoul.money_thinking_strength_and_abundance_of_family",
    "com.ensoul.money_thinking_intuition_and_law_of_attraction",
    "com.ensoul.money_thinking_laws_of_money_energy",
    "com.ensoul.subscription_month_art_therapy",
    "com.ensoul.subscription_month_meditations",
    "com.ensoul.subscription_month_money_thinking",
    "com.ensoul.subscription_pro"
]
