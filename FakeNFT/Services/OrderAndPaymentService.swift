import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void
typealias CurrencyListCompletion = (Result<[Currency], Error>) -> Void
typealias PaymentConfirmationRequest = (Result<Payment, Error>) -> Void

protocol OrderService {
  func loadOrder(completion: @escaping OrderCompletion)
  func loadCurrencyList(completion: @escaping CurrencyListCompletion)
  func updateOrder(nftsIds: [String], completion: @escaping OrderCompletion)
  func loadPayment(currencyId: String, completion: @escaping PaymentConfirmationRequest)
}

final class OrderServiceImpl: OrderService {

  private let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func loadOrder(completion: @escaping OrderCompletion) {
    networkClient.send(request: NFTOrderRequest(), type: Order.self) { result in
      switch result {
      case .success(let order):
        completion(.success(order))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func loadCurrencyList(completion: @escaping CurrencyListCompletion) {
    networkClient.send(request: CurrencyListRequest(), type: [Currency].self) { result in
      switch result {
      case .success(let currencies):
        print("Received currencies: \(currencies)")
        completion(.success(currencies))
      case .failure(let error):
        print("Error loading currency list: \(error)")
        completion(.failure(error))
      }
    }
  }

  func updateOrder(nftsIds: [String], completion: @escaping OrderCompletion) {
    let newOrderModel = NewOrderModel(nfts: nftsIds)
    let request = EditOrderRequest(newOrder: newOrderModel)
    networkClient.send(request: request, type: Order.self) { result in
      switch result {
      case .success(let order):
        completion(.success(order))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func loadPayment(currencyId: String, completion: @escaping PaymentConfirmationRequest) {
    networkClient.send(request: PaymentRequest(), type: Payment.self) { result in
      switch result {
      case .success(let payment):
        print("Received currencies: \(payment)")
        completion(.success(payment))
      case .failure(let error):
        print("Error loading currency list: \(error)")
        completion(.failure(error))
      }
    }
  }
}
