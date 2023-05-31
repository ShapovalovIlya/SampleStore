//
//  StoreViewModel.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 29.03.2023.
//

import Foundation
import Combine
import StoreKit

public final class StoreViewModel: ObservableObject {
    
    private let storeService: StoreServiceProtocol
    
    @Published var meditationProductsPublished: [Product] = .init()
    @Published var artTherapyProductsPublished: [Product] = .init()
    @Published var moneyThinkingProductsPublished: [Product] = .init()
    @Published var subscriptionsPublished: [Product] = .init()
    @Published var isPresentingAlert = false
    
    private(set) var alertDescription: String = .init()
    
    private var cancellable = Set<AnyCancellable>()
    
    //MARK: - init(_:)
    public init(storeService: StoreServiceProtocol) {
        self.storeService = storeService
        
        storeService.objectWillChangePublisher
            .sink { _ in self.objectWillChange.send() }
            .store(in: &cancellable)
        
        self.storeService.nonConsumableProductsPublisher
            .print()
            .sink(receiveValue: set(products:))
            .store(in: &cancellable)
        
        Publishers.CombineLatest(
            self.storeService.nonRenewingProductsPublisher,
            self.storeService.autoRenewingProductsPublisher)
        .map(+)
        .assign(to: &$subscriptionsPublished)
    }
    
    //MARK: - Public methods
    func purchase(_ product: Product) {
        storeService.purchasePublisher(product)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handle(completion:), receiveValue: successAlert(from:))
            .store(in: &cancellable)
    }
    
    func isPurchased(_ product: Product) -> Bool {
        storeService.isPurchased(product)
    }
    
    func viewAppeared() {
        storeService.storeError
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveValue: present(error:))
            .store(in: &cancellable)
        storeService.start()
    }
    
    //MARK: - Private methods
    private func handle(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: break
        case .failure(let error):
            self.present(error: error)
        }
    }
    
    private func present(error: Error) {
        self.alertDescription = error.localizedDescription
        self.isPresentingAlert = true
    }
    
    private func set(products: [Product]) {
        meditationProductsPublished = products.filter({ $0.id.contains("meditation") })
        artTherapyProductsPublished = products.filter({ $0.id.contains("art_therapy") })
        moneyThinkingProductsPublished = products.filter({ $0.id.contains("money_thinking") })
    }
    
    private func successAlert(from transaction: Transaction) {
        print("StoreViewModel: \(transaction.productID) successfully purchased.")
    }
    
    //MARK: - Test environment
    static func testVM() -> StoreViewModel {
        let store = StoreService()
        return StoreViewModel(
            storeService: store)
    }
    
}
