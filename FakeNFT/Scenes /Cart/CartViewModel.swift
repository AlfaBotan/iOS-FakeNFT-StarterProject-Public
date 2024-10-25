//  Created by Alexander Salagubov on 09.09.2024.
//

import Foundation
import UIKit
import ProgressHUD

private enum SortCriteria: String {
  case price
  case rating
  case name
  case none
}

final class CartViewModel {
  
  private let orderService: OrderService = OrderServiceImpl(networkClient: DefaultNetworkClient())
  private let nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())

  var isLoading: Bool = false {
    didSet {
      onLoading?(isLoading)
    }
  }
  
  var nftItems: Nfts = [] {
    didSet {
      onItemsUpdated?()
    }
  }
  
  var onItemsUpdated: (() -> Void)?
  var onLoading: ((Bool) -> Void)?
  private var order: Order?
  
  private var currentSortCriteria: SortCriteria {
    get {
      guard let criteria = UserDefaults.standard.string(forKey: "sortCriteria") else {
        return .none
      }
      return SortCriteria(rawValue: criteria) ?? .none
    }
    set {
      UserDefaults.standard.setValue(newValue.rawValue, forKey: "sortCriteria")
    }
  }
  
  
  private func loadOrders(completion: @escaping (Order?) -> Void) {
    orderService.loadOrder { [weak self] result in
      switch result {
      case .success(let order):
        self?.order = order
        print(order)
        completion(order)
      case .failure(let error):
        print(error.localizedDescription)
        completion(nil)
      }
    }
  }
  
  func loadItems() {
    isLoading = true
    onLoading?(true)
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    loadOrders { [weak self] order in
      dispatchGroup.leave()
      
      ProgressHUD.show()
      ProgressHUD.animationType = .circleSpinFade
      guard let order = order else {
        ProgressHUD.dismiss()
        self?.isLoading = false
        return
      }
      
      if order.nfts.isEmpty {
        ProgressHUD.dismiss()
        self?.isLoading = false
        return
      }
      
      var nftsFromNetwork: Nfts = []
      
      for nft in order.nfts {
        dispatchGroup.enter()
        self?.nftService.loadNft(id: nft) { result in
          switch result {
          case .success(let nft):
            nftsFromNetwork.append(nft)
            print(nft)
          case .failure(let error):
            print(error.localizedDescription)
          }
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) {
        self?.nftItems = nftsFromNetwork
        ProgressHUD.dismiss()
        self?.isLoading = false
        self?.onItemsUpdated?()
      }
    }
  }

  private func reset() {
    nftItems.removeAll()
  }

  func removeItem(at index: Int) {
    nftItems.remove(at: index)
    
    let nftsIds = nftItems.map { $0.id }
    orderService.updateOrder(nftsIds: nftsIds) { [weak self] result in
      switch result {
      case .success(let order):
        self?.order = order
        self?.loadItems()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
    onItemsUpdated?()
  }
  
  
  func totalAmount() -> Float {
    return nftItems.reduce(0) { $0 + $1.price }
  }
  
  func totalQuantity() -> Int {
    return nftItems.count
  }
  
  func sortByPrice() {
    nftItems.sort { $0.price < $1.price }
    currentSortCriteria = .price
  }
  
  func sortByRating() {
    nftItems.sort { $0.rating > $1.rating }
    currentSortCriteria = .rating
  }
  
  func sortByName() {
    nftItems.sort { $0.name < $1.name }
    currentSortCriteria = .name
  }
  
  func applySorting() {
    switch currentSortCriteria {
    case .price:
      sortByPrice()
    case .rating:
      sortByRating()
    case .name:
      sortByName()
    case .none:
      break
    }
  }
}

extension CartViewModel: PaymentResultHandling {
  func paymentSucceed() {
    reset()
  }
}
