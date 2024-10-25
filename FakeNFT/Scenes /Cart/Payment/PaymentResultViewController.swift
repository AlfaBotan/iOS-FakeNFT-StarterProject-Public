import UIKit
import ProgressHUD

final class PaymentResultViewController: UIViewController {
  private weak var resultHandler: PaymentResultHandling?

  private let orderService: OrderService = OrderServiceImpl(networkClient: DefaultNetworkClient())

  private lazy var backToCatalogButton: UIButton = {
    let backToCatalogButton = UIButton()
    backToCatalogButton.setTitle(Strings.Cart.backToCartBtn, for: .normal)
    backToCatalogButton.setTitleColor(UIColor.textButton, for: .normal)
    backToCatalogButton.titleLabel?.font = UIFont.bodyBold
    backToCatalogButton.layer.cornerRadius = 16
    backToCatalogButton.layer.masksToBounds = true
    backToCatalogButton.backgroundColor = UIColor.closeButton
    backToCatalogButton.addTarget(self, action: #selector(backToCatalog), for: .touchUpInside)
    backToCatalogButton.translatesAutoresizingMaskIntoConstraints = false
    return backToCatalogButton
  }()

  private lazy var succesLabel: UILabel = {
    let succesLabel = UILabel()
    succesLabel.font = UIFont.headline3
    succesLabel.text = Strings.Cart.successMsg
    succesLabel.textColor = UIColor.segmentActive
    return succesLabel
  }()

  private lazy var holderImage: UIImageView = {
    let holderImage = UIImageView()
    holderImage.image = UIImage(named: "paymentHolder")
    holderImage.contentMode = .scaleAspectFit
    return holderImage
  }()

  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [holderImage, succesLabel])
    stack.axis = .vertical
    stack.spacing = 0
    stack.alignment = .leading
    return stack
  }()

  init(resultHandler: PaymentResultHandling?) {
    self.resultHandler = resultHandler
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .systemBackground
    super.viewDidLoad()
    setupAppearance()
  }

  @objc private func backToCatalog() {
    clearOrder()
  }

  func clearOrder() {
    orderService.updateOrder(nftsIds: []) { [weak self] (result: Result<Order, Error>) in
      guard let self else { return }
      switch result {
      case .success(let updatedOrder):
        print("Order successfully updated: \(updatedOrder)")
        resultHandler?.paymentSucceed()
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 1
        tabBarController?.tabBar.isHidden = false
      case .failure(let error):
        print("Error updating order: \(error)")
        ProgressHUD.showError()
      }
    }
  }

  func setupAppearance() {
    succesLabel.numberOfLines = 2
    succesLabel.textAlignment = .center

    navigationController?.setNavigationBarHidden(true, animated: true)

    [stack, backToCatalogButton, holderImage, succesLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0) }

    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

      holderImage.heightAnchor.constraint(equalToConstant: 278),
      holderImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
      holderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      succesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 494),
      succesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      succesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
      succesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

      backToCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      backToCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      backToCatalogButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
      backToCatalogButton.heightAnchor.constraint(equalToConstant: 60),
    ])
  }
}
