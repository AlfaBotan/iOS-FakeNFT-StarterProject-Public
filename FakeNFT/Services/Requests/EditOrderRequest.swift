import Foundation

struct EditOrderRequest: NetworkRequest {

  let newOrder: NewOrderModel

  var httpMethod: HttpMethod = .put

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
  }
  var dto: Dto? {
      let formData: [String: String] = [
          "nfts": newOrder.nfts.joined(separator: ", ")
      ]
      return FormDataDto(data: formData)
  }
}

struct NewOrderModel: Encodable {
  var nfts: [String]
}

struct FormDataDto: Dto {
    let data: [String: String]

    func asDictionary() -> [String: String] {
        return data
    }
}
