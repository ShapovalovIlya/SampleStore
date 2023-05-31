//
//  StoreView.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 29.03.2023.
//

import SwiftUI
import StoreKit

public struct StoreView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: StoreViewModel
    let purchasedModule: () -> Content
    
    private struct Drawing {
    }
    
    public var body: some View {
        AppBackgroundView { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    SubscriptionsGrid(
                        title: Strings.Store.Main.content_subscriptions,
                        subscriptions: viewModel.subscriptionsPublished,
                        purchase: viewModel.purchase(_:),
                        isPurchased: viewModel.isPurchased(_:),
                        geometry: proxy)
                    ProductGrid(
                        title: Strings.Store.Main.content_meditations,
                        products: viewModel.meditationProductsPublished,
                        purchase: viewModel.purchase(_:),
                        isPurchased: viewModel.isPurchased(_:),
                        geometry: proxy)
                    ProductGrid(
                        title: Strings.Store.Main.content_artTherapy,
                        products: viewModel.artTherapyProductsPublished,
                        purchase: viewModel.purchase(_:),
                        isPurchased: viewModel.isPurchased(_:),
                        geometry: proxy)
                    ProductGrid(
                        title: Strings.Store.Main.content_moneyThinking,
                        products: viewModel.moneyThinkingProductsPublished,
                        purchase: viewModel.purchase(_:),
                        isPurchased: viewModel.isPurchased(_:),
                        geometry: proxy)
                }
                .padding(.leading)
            }
        }
        .onAppear(perform: viewModel.viewAppeared)
        .replaceNavigationBackButton(dismissAction: dismiss)
        .toolbar(content: trailingContent)
        .alert(
            viewModel.alertDescription,
            isPresented: $viewModel.isPresentingAlert,
            actions: { Text("OK") })
    }
    
    public init(
        viewModel: StoreViewModel,
        purchasedModule: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.purchasedModule = purchasedModule
    }
    
    //MARK: - Private methods
    private func trailingContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: purchasedModule) {
                HStack {
                    Text(Strings.Store.Main.my_purchase)
                        .descriptionStyle()
                    Image(systemName: Icons.Store.Main.navigationButton_purchased)
                }
                .foregroundColor(.white)
            }
        }
    }
    
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StoreView(
                viewModel: StoreViewModel.testVM(),
                purchasedModule: EmptyView.init)
        }
    }
}
