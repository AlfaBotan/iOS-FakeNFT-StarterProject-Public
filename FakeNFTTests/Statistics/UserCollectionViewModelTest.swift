//
//  UserCollectionViewModelTest.swift
//  FakeNFTTests
//
//  Created by Дмитрий on 24.09.2024.
//

import XCTest
@testable import FakeNFT

enum TestMockData {
    static let nftLike = "nft1"
    static let profileWithLike = Profile(name: "author",
                                         avatar: "avatar",
                                         description: "description",
                                         website: "www.ya.ru",
                                         nfts: ["nft1"],
                                         likes: [TestMockData.nftLike],
                                         id: "idProfile")
    static let profileWithoutLike = Profile(name: "author",
                                            avatar: "avatar",
                                            description: "description",
                                            website: "www.ya.ru",
                                            nfts: ["id"],
                                            likes: [],
                                            id: "idProfile")
    static let nft = Nft(createdAt: "01.01.0001",
                         name: "NFT Name",
                         images: [URL(string: "www.ya.ru")!],
                         rating: 5,
                         description: "test",
                         price: 100.1,
                         author: "author",
                         id: TestMockData.nftLike)
    static let userNfts = [TestMockData.nftLike]
    static let orderWithNft = Order(id: "idOrder", nfts: [TestMockData.nftLike])
    static let orderWithoutNft = Order(id: "idOrder", nfts: [])
}

class UserCollectionViewModelTests: XCTestCase {
    
    var viewModel: UserCollectionViewModel!
    var mockNftService: MockNftService!
    var mockProfileService: MockProfileService!
    var mockOrderService: MockOrderService!
    
    override func setUp() {
        super.setUp()
        mockNftService = MockNftService()
        mockProfileService = MockProfileService()
        mockOrderService = MockOrderService()
        
        viewModel = UserCollectionViewModel(
            userNFTs: TestMockData.userNfts,
            nftService: mockNftService,
            profileService: mockProfileService,
            orderService: mockOrderService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockNftService = nil
        mockProfileService = nil
        mockOrderService = nil
        super.tearDown()
    }
    
    func testLoadNFTsSuccess() {
        // Настройка успешного результата для loadNft
        let mockNFT = TestMockData.nft
        mockNftService.loadNftResult = .success(mockNFT)
        mockProfileService.loadProfileResult = .success(TestMockData.profileWithLike)
        mockOrderService.loadOrderResult = .success(TestMockData.orderWithNft)
        
        let expectation = self.expectation(description: "Load NFTs")
        
        // Вызов метода loadNFTs
        viewModel.loadNFTs(isRefreshing: false) {
            expectation.fulfill()
        }
        
        // Проверка, что NFT успешно загружены
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.viewModel.numberOfItems, 1)
            XCTAssertNotNil(self.viewModel.item(at: IndexPath(row: 0, section: 0)))
        }
    }
    
    func testLoadNFTsFailure() {
        // Настройка неудачного результата для loadNft
        mockNftService.loadNftResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        mockProfileService.loadProfileResult = .success(TestMockData.profileWithLike)
        mockOrderService.loadOrderResult = .success(Order(id: "id", nfts: []))
        
        let expectation = self.expectation(description: "Load NFTs failure")
        var didShowError = false
        viewModel.showErrorAlert = { _ in
            didShowError = true
        }
        
        // Вызов метода loadNFTs
        viewModel.loadNFTs(isRefreshing: false) {
            expectation.fulfill()
        }
        
        // Проверка, что произошла ошибка и не загружено ни одного NFT
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.viewModel.numberOfItems, 0)
            XCTAssertTrue(didShowError)
        }
    }
}

// Моки для сервисов
final class MockNftService: NftService {
    var loadNftResult: Result<Nft, Error>?
    var loadNftsResult: Result<Nfts, Error>?
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let result = loadNftResult {
            completion(result)
        }
    }
    
    func loadNfts(page: Int, size: Int, completion: @escaping NftsCompletion) {
        if let result = loadNftsResult {
            completion(result)
        }
    }
}

final class MockProfileService: ProfileService {
    var loadProfileResult: Result<Profile, Error>?
    var sendPutRequestCalled = false
    var sendPutRequestResult: Result<Profile, Error>?
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        if let result = loadProfileResult {
            completion(result)
        }
    }
    
    func clearStorage() {}
    
    func sendExamplePutRequest(likes: [String], avatar: String, name: String, completion: @escaping ProfilePutCompletion) {
        sendPutRequestCalled = true
        if let result = sendPutRequestResult {
            completion(result)
        }
    }
}

final class MockOrderService: OrderService {
    var loadOrderResult: Result<Order, Error>?
    var updateOrderResult: Result<Order, Error>?
    
    func loadOrder(completion: @escaping OrderCompletion) {
        if let result = loadOrderResult {
            completion(result)
        }
    }
    
    func loadCurrencyList(completion: @escaping CurrencyListCompletion) {}
    
    func updateOrder(nftsIds: [String], completion: @escaping OrderCompletion) {
        print("updateOrder called with nftsIds: \(nftsIds)")
        if let result = updateOrderResult {
            completion(result)
        }
    }
    
    func loadPayment(currencyId: String, completion: @escaping PaymentConfirmationRequest) {}
}

