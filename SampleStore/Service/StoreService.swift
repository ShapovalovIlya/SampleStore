//
//  StoreService.swift
//  Ensoul
//
//  Created by Илья Шаповалов on 18.03.2023.
//

import Combine
import StoreKit

public protocol StoreServiceProtocol {
    // Available products to purchase
    /// Collection of consumable products available for purchase.
    var consumableProductsPublisher: AnyPublisher<[Product], Never> { get }
    /// Collection of non consumable products available for purchase.
    var nonConsumableProductsPublisher: AnyPublisher<[Product], Never> { get }
    /// Collection of auto-renewable products available for purchase.
    var autoRenewingProductsPublisher: AnyPublisher<[Product], Never> { get }
    /// Collection of non renewable products available for purchase.
    var nonRenewingProductsPublisher: AnyPublisher<[Product], Never> { get }
    
    // Already purchased products
    /// Collection of purchased consumable products.
    var purchasedConsumableProductsPublisher: AnyPublisher<[Product], Never> { get }
    /// Collection of purchased non consumable products.
    var purchasedNonConsumableProductsPublisher: AnyPublisher<[Product], Never> { get }
    /// Collection of purchased auto renewable products.
    var purchasedAutoRenewingProductsPublisher: AnyPublisher<[Product], Never> { get }
    /// Collection of purchased non renewable products.
    var purchasedNonRenewingProductsPublisher: AnyPublisher<[Product], Never> { get }
    /// A publisher that emits Errors from store
    var storeError: PassthroughSubject<Error, Never> { get }
    /// A publisher that emits before the object has changed.
    var objectWillChangePublisher: AnyPublisher<Void, Never> { get }
    
    /// Set Store's array of unique product identifiers.
    /// - Parameter productIds: A collection of unique in-app purchase product identifiers that you previously configured in App Store Connect.
    /// StoreKit ignores any duplicate identifiers in the collection.
    func set(productIDs: [String])
    
    /// Requests product data from the App Store and load the latest transactions that entitle a user to in-app purchases and subscriptions.
    func start()
    
   /// Initiates a purchase for the product with the App Store.
    /// - Parameter product: Information about a product configured in App Store Connect.
    /// - Returns: In case of successful purchase method return transaction.
    /// The App Store generates a transaction each time a customer purchases an in-app purchase product or renews a subscription.
    /// Method throws StoreError and return nil if transaction wasn't verify or being pended.
    @MainActor @discardableResult func purchase(_ product: Product) async throws -> Transaction?
    
    /// A purchase publisher for the product with the App Store.
    /// - Parameter product: Information about a product configured in App Store Connect.
    /// - Returns: Publisher produse succesfull transaction or StoreError
    /// The App Store generates a transaction each time a customer purchases an in-app purchase product or renews a subscription.
    /// Method throws StoreError if transaction wasn't verify or being pended.
    func purchasePublisher(_ product: Product) -> AnyPublisher<Transaction, Error>
    
    /// Method check is chosen product purchased
    /// - Parameter product: Information about a product configured in App Store Connect.
    /// - Returns: If Product is purchased method return true, other false
    func isPurchased(_ product: Product) -> Bool
    
    /// Synchronize your app’s transaction information and subscription status with information from the App Store.
    /// Calling this method displays a system prompt that asks users to authenticate with their App Store credentials.
    func restorePurchases() async throws
    
    /// Request date that App Store charged the user’s account for a purchased or restored product, or for a subscription purchase or renewal after a lapse.
    /// - Parameter product: Information about a product configured in App Store Connect.
    /// - Returns: Purchase date
    func requestPurchaseDate(for product: Product) async throws -> Date
    
    /// Request products transaction. Transaction represents the customer’s purchase of a product in your app.
    /// You can get any sort of information about purchase from transaction.
    /// - Parameter product: Information about a product configured in App Store Connect.
    /// - Returns: Publisher with transaction that entitles the user to the product. 
    func transactionPublisher(for product: Product) -> AnyPublisher<Transaction, Error>
}

public final class StoreService: ObservableObject, StoreServiceProtocol {
    public typealias Transaction = StoreKit.Transaction
    public typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
    public typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState
    
    private var updateListenerTask: Task<Void, Error>?
    private var cancellable: Set<AnyCancellable> = .init()
    private var productIDs: [String] = .init()
    
    //MARK: - Private publishers
    // Available products to purchase
    @Published private var consumableProducts: [Product] = .init()
    @Published private var nonConsumableProducts: [Product] = .init()
    @Published private var autoRenewingProducts: [Product] = .init()
    @Published private var nonRenewingProducts: [Product] = .init()
    
    // Already purchased products
    @Published private var purchasedConsumableProducts: [Product] = .init()
    @Published private var purchasedNonConsumableProducts: [Product] = .init()
    @Published private var purchasedAutoRenewingProducts: [Product] = .init()
    @Published private var purchasedNonRenewingProducts: [Product] = .init()
    
    //MARK: - Public publishers
    // Available products publishers
    lazy public var consumableProductsPublisher: AnyPublisher<[Product], Never> = .init($consumableProducts)
    lazy public var nonConsumableProductsPublisher: AnyPublisher<[Product], Never> = .init($nonConsumableProducts)
    lazy public var autoRenewingProductsPublisher: AnyPublisher<[Product], Never> = .init($autoRenewingProducts)
    lazy public var nonRenewingProductsPublisher: AnyPublisher<[Product], Never> = .init($nonRenewingProducts)
    public let storeError: PassthroughSubject<Error, Never> = .init()
    
    // Already purchased products publishers
    lazy public var purchasedConsumableProductsPublisher: AnyPublisher<[Product], Never> = .init($purchasedConsumableProducts)
    lazy public var purchasedNonConsumableProductsPublisher: AnyPublisher<[Product], Never> = .init($purchasedNonConsumableProducts)
    lazy public var purchasedAutoRenewingProductsPublisher: AnyPublisher<[Product], Never> = .init($purchasedAutoRenewingProducts)
    lazy public var purchasedNonRenewingProductsPublisher: AnyPublisher<[Product], Never> = .init($purchasedNonRenewingProducts)
    lazy public var objectWillChangePublisher: AnyPublisher<Void, Never> = .init(objectWillChange.eraseToAnyPublisher())
    
    //MARK: - init/deinit
    /// Initialize new instance of Store. Right after initialization store starts listen for transactions.
    public init() {
        self.updateListenerTask = Task.detached(priority: .background, operation: transactionListener)
    }
    
    deinit {
        self.updateListenerTask?.cancel()
    }
    
    //MARK: - Public methods
    public func start() {
        Task(priority: .high) {
            do {
                try await request(products: productIDs)
                try await updateCustomerProductStatus()
            } catch {
                self.storeError.send(error)
            }
        }
    }
    
    public func set(productIDs: [String]) {
        self.productIDs = productIDs
    }
    
    @MainActor @discardableResult public func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        return try await handlePurchase(result)
    }
    
    public func purchasePublisher(_ product: Product) -> AnyPublisher<Transaction, Error> {
        Future { promise in
            Task {
                do {
                    if let transaction = try await self.purchase(product) {
                        promise(.success(transaction))
                    } else {
                        promise(.failure(SKError(.unauthorizedRequestData)))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func isPurchased(_ product: Product) -> Bool {
        switch product.type {
        case .consumable:
            return purchasedConsumableProducts.contains(product)
        case .nonConsumable:
            return purchasedNonConsumableProducts.contains(product)
        case .nonRenewable:
            return purchasedNonRenewingProducts.contains(product)
        case .autoRenewable:
            return purchasedAutoRenewingProducts.contains(product)
        default:
            return false
        }
    }
    
    public func restorePurchases() async throws {
        try await AppStore.sync()
    }
    
    public func requestPurchaseDate(for product: Product) async throws -> Date {
        let result = await product.currentEntitlement
        guard let result = result else {
            throw SKError(.unauthorizedRequestData)
        }
        let transaction = try checkVerified(result)
        
        return transaction.purchaseDate
    }
    
    public func transactionPublisher(for product: Product) -> AnyPublisher<Transaction, Error> {
        Future<VerificationResult<Transaction>, Error> { promise in
            Task {
                if let result = await product.currentEntitlement {
                    promise(.success(result))
                } else {
                    promise(.failure(SKError(.unauthorizedRequestData)))
                }
            }
        }
        .tryMap(checkVerified)
        .eraseToAnyPublisher()
    }
    
    //MARK: - Private methods
    private func handlePurchase(_ result: Product.PurchaseResult) async throws -> Transaction? {
        switch result {
        case .success(let verification):
            
            let transaction = try checkVerified(verification)
            try await updateCustomerProductStatus()
            await transaction.finish()
            return transaction
            
        case .userCancelled: throw StoreKitError.userCancelled
        case .pending: return nil
        @unknown default: throw StoreKitError.unknown
        }
    }
    
    private func updateAvailableProducts(with products: [Product]) {
        var newConsumable = [Product]()
        var newNonConsumable = [Product]()
        var newNonRenewable = [Product]()
        var newAutoRenewable = [Product]()
        
        for product in products {
            switch product.type {
            case .consumable: newConsumable.append(product)
            case .nonConsumable: newNonConsumable.append(product)
            case .nonRenewable: newNonRenewable.append(product)
            case .autoRenewable: newAutoRenewable.append(product)
            default: print("Unknown product: \(product)")
            }
        }
        
        self.consumableProducts = sortByPrice(newConsumable)
        self.nonConsumableProducts = sortByPrice(newNonConsumable)
        self.nonRenewingProducts = sortByPrice(newNonRenewable)
        self.autoRenewingProducts = sortByPrice(newAutoRenewable)
    }
    
    @MainActor private func request(products ids: [String]) async throws {
        let storeProducts = try await Product.products(for: ids)
        updateAvailableProducts(with: storeProducts)
    }
    
    @MainActor private func updateCustomerProductStatus() async throws {
        var purchasedNonConsumables = [Product]()
        var purchasedAutoRenewables = [Product]()
        var purchasedNonRenewables = [Product]()
        
        for await result in Transaction.currentEntitlements {
            let transaction = try checkVerified(result)
            
            switch transaction.productType {
            case .nonConsumable:
                if let product = nonConsumableProducts.first(where: { $0.id == transaction.productID }) {
                    purchasedNonConsumables.append(product)
                }
            case .autoRenewable:
                if let product = autoRenewingProducts.first(where: { $0.id == transaction.productID }) {
                    purchasedAutoRenewables.append(product)
                }
            case .nonRenewable:
                guard
                    let product = nonRenewingProducts.first(where: { $0.id == transaction.productID }),
                    let expirationDate = Calendar(identifier: .gregorian).date(byAdding: .init(month: 1), to: transaction.purchaseDate),
                    Date() < expirationDate
                else {
                    break
                }
                purchasedNonRenewables.append(product)
            default: print("Unknown productID: \(transaction.productID)")
            }
        }
        
        self.purchasedNonConsumableProducts = purchasedNonConsumables
        self.purchasedAutoRenewingProducts = purchasedAutoRenewables
        self.purchasedNonRenewingProducts = purchasedNonRenewables
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case let .unverified(_, error): throw error
        case let .verified(safe): return safe
        }
    }
    
    private func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { $0.price < $1.price })
    }
    
    @Sendable private func transactionListener() async throws {
        for await result in Transaction.updates {
            let transaction = try checkVerified(result)
            
            try await updateCustomerProductStatus()
            await transaction.finish()
        }
    }

}
