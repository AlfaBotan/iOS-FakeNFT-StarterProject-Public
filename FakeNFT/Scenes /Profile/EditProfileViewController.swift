import UIKit

final class EditProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel!
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePhotoTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.addSubview(darkOverlay)
        return imageView
    }()
    
    private lazy var overlayLabel: UILabel = {
        let label = UILabel()
        label.text = "Сменить \nфото"
        label.numberOfLines = 0
        label.font = .caption3medium
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var darkOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .headline3
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .segmentInactive
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.rightView = createClearButton()
        textField.rightViewMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .headline3
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.backgroundColor = .segmentInactive
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        textView.font = .bodyRegular
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.textAlignment = .left
        return textView
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.font = .headline3
        return label
    }()
    
    private lazy var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .segmentInactive
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closing"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        populateFields()
    }
    
    private func createClearButton() -> UIButton {
        let button = UIButton(type: .custom)
        let clearImage = UIImage(systemName: "xmark.circle.fill")
        button.setImage(clearImage, for: .normal)
        button.tintColor = .lightGray
        button.widthAnchor.constraint(equalToConstant: 17).isActive = true
        button.heightAnchor.constraint(equalToConstant: 17).isActive = true
        button.addTarget(self, action: #selector(clearTextFieldTapped), for: .touchUpInside)
        return button
    }
    
    private func setupViews() {
        view.addSubview(avatarImageView)
        view.addSubview(overlayLabel)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(websiteLabel)
        view.addSubview(websiteTextField)
        view.addSubview(closeButton)
        
        // Устанавливаем констрейнты
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteTextField.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Аватарка
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // Констрейнты для darkOverlay
            darkOverlay.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            darkOverlay.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            darkOverlay.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            darkOverlay.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            // Лейбл поверх аватарки
            overlayLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            overlayLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            // Лейбл "Имя"
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // TextField для имени
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Лейбл "Описание"
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // TextView для описания
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            
            // Лейбл "Сайт"
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // TextField для сайта
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Кнопка закрытия
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func populateFields() {
        nameTextField.text = viewModel.userName.value
        descriptionTextView.text = viewModel.userDescription.value
        websiteTextField.text = viewModel.userWebsite.value
        avatarImageView.image = viewModel.userImage.value
    }
    
    @objc private func changePhotoTapped() {
        print("Change photo tapped")
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func clearTextFieldTapped() {
        nameTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Обновляем данные во ViewModel
        viewModel.userName.value = nameTextField.text ?? ""
        viewModel.userDescription.value = descriptionTextView.text ?? ""
        viewModel.userWebsite.value = websiteTextField.text ?? ""
        
        // Сохраняем изменения в UserDefaults через ViewModel
        viewModel.saveProfile()
    }
}
