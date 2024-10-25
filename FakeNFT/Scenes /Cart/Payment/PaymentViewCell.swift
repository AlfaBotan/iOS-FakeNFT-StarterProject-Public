import UIKit

final class PaymentViewCell: UICollectionViewCell {

  private lazy var currencyTitle: UILabel = {
    let currencyTitle = UILabel()
    currencyTitle.font = UIFont.caption2
    currencyTitle.textColor = UIColor.textPrimary
    return currencyTitle
  }()

  private lazy var currencySymbol: UILabel = {
    let currencySymbol = UILabel()
    currencySymbol.font = UIFont.caption2
    currencySymbol.textColor = UIColor.currencyType
    return currencySymbol
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [currencyTitle, currencySymbol])
    stackView.axis = .vertical
    stackView.spacing = 0
    return stackView
  }()

  private lazy var currencyImage: UIImageView = {
    let currencyImage = UIImageView()
    currencyImage.layer.cornerRadius = 6
    currencyImage.layer.masksToBounds = true
    currencyImage.backgroundColor = UIColor.black
    return currencyImage
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureCell(currency: Currency){
    currencyTitle.text = currency.title
    currencySymbol.text = currency.name
    currencyImage.kf.setImage(with: currency.image, placeholder: UIImage(systemName: "nft1"))
  }

  private func setupAppearance() {
    [stackView, currencyImage].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }

    NSLayoutConstraint.activate([
      currencyImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      currencyImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      currencyImage.heightAnchor.constraint(equalToConstant: 36),
      currencyImage.widthAnchor.constraint(equalToConstant: 36),

      stackView.centerYAnchor.constraint(equalTo: currencyImage.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: currencyImage.trailingAnchor, constant: 12),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
    ])
  }

}
