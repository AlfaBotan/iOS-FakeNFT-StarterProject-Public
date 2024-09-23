@testable import FakeNFT
import XCTest

final class CartViewModelUnitTest: XCTestCase {
  func testSortByName() {
    let sut = CartViewModel()

    sut.nftItems = [.init(createdAt: "2023-07-11T05:27:40.359Z[GMT]", name: "James Burt", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/1.png")!], rating: 2, description: "eos habeo percipit duis malesuada", price: 11.14, author: "https://exciting_pare.fakenfts.org/", id: "cc74e9ab-2189-465f-a1a6-8405e07e9fe4"), .init(createdAt: "2023-06-08T05:52:06.646Z[GMT]", name: "Daryl Lucas", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/1.png")!], rating: 4, description: "animal solet pharetra perpetua usu alienum", price: 13.99, author: "https://strange_gates.fakenfts.org/", id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b")]

    sut.sortByName()

    XCTAssert(sut.nftItems[0].name < sut.nftItems[1].name)
    }

  func testSortByPrice() {
    let sut = CartViewModel()

    sut.nftItems = [.init(createdAt: "2023-07-11T05:27:40.359Z[GMT]", name: "James Burt", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/1.png")!], rating: 2, description: "eos habeo percipit duis malesuada", price: 11.14, author: "https://exciting_pare.fakenfts.org/", id: "cc74e9ab-2189-465f-a1a6-8405e07e9fe4"), .init(createdAt: "2023-06-08T05:52:06.646Z[GMT]", name: "Daryl Lucas", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/1.png")!], rating: 4, description: "animal solet pharetra perpetua usu alienum", price: 13.99, author: "https://strange_gates.fakenfts.org/", id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b")]

    sut.sortByPrice()

    XCTAssert(sut.nftItems[0].price < sut.nftItems[1].price)
    }

  func testSortByRating() {
    let sut = CartViewModel()

    sut.nftItems = [.init(createdAt: "2023-07-11T05:27:40.359Z[GMT]", name: "James Burt", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/1.png")!], rating: 2, description: "eos habeo percipit duis malesuada", price: 11.14, author: "https://exciting_pare.fakenfts.org/", id: "cc74e9ab-2189-465f-a1a6-8405e07e9fe4"), .init(createdAt: "2023-06-08T05:52:06.646Z[GMT]", name: "Daryl Lucas", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/1.png")!], rating: 4, description: "animal solet pharetra perpetua usu alienum", price: 13.99, author: "https://strange_gates.fakenfts.org/", id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b")]

    sut.sortByRating()

    XCTAssert(sut.nftItems[0].rating > sut.nftItems[1].rating)
    }
}
