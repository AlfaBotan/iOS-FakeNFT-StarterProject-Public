import UIKit
import Kingfisher

class ProfileViewModel {
    
    static let shared = ProfileViewModel()
    
    private init() {}
    
    var userName: Observable<String> = Observable("")
    var userDescription: Observable<String> = Observable("")
    var userWebsite: Observable<String> = Observable("")
    var userImage: Observable<URL?> = Observable(nil)
    
    var imageURL: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.profileImageKey)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: Constants.profileImageKey)
        }
    }
    
    private let userNameKey = "userName"
    private let userDescriptionKey = "userDescription"
    private let userWebsiteKey = "userWebsite"
    private let userImageKey = "userImage"
    
    let menuItems = [
        NSLocalizedString("Profile.myNft", comment: "myNft"),
        NSLocalizedString("Profile.favoritesNft", comment: "favoritesNft"),
        NSLocalizedString("Profile.aboutAuthor", comment: "aboutAuthor")
    ]
    
    func viewDidLoad() {
        loadProfile() // Загружаем профиль из UserDefaults при запуске
    }
    
    // Сохранение данных в UserDefaults
    func saveProfile() {
        UserDefaults.standard.set(userName.value, forKey: userNameKey)
        UserDefaults.standard.set(userDescription.value, forKey: userDescriptionKey)
        UserDefaults.standard.set(userWebsite.value, forKey: userWebsiteKey)
    }
    
    func makeShowImageAllert() -> UIAlertController {
        let alertController = UIAlertController(title: "Enter Image URL", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter image URL"
        }
        
        let doneAction = UIAlertAction(title: "Save", style: .default) { [weak self]  _ in
            
            guard let self = self else { return }
            
            if let imageURL = alertController.textFields?.first?.text, !imageURL.isEmpty {
                self.imageURL = imageURL
                userImage.value = URL(string: imageURL)
                print("Image URL saved: \(imageURL)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func didSelectMenuItem(at index: Int) {
        // Обработка выбора меню
    }
    
    func didTapWebsite(url: URL) {
        // Обработка перехода на сайт
    }
    
    // Сохранение данных в UserDefaults
    func viewWillDisappear() {
        saveProfile()
    }
    
    // Загрузка данных из UserDefaults
    private func loadProfile() {
        if let savedName = UserDefaults.standard.string(forKey: userNameKey) {
            userName.value = savedName
        } else {
            userName.value = "Joaquin Phoenix"
        }
        
        if let savedDescription = UserDefaults.standard.string(forKey: userDescriptionKey) {
            userDescription.value = savedDescription
        } else {
            userDescription.value = "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
        }
        
        if let savedWebsite = UserDefaults.standard.string(forKey: userWebsiteKey) {
            userWebsite.value = savedWebsite
        } else {
            userWebsite.value = "JoaquinPhoenix.com"
        }
        
        if let imageURL {
            userImage.value = URL(string: imageURL)
        } else {
            userImage.value = nil
        }
    }
}

private enum Constants {
    static let profileImageKey = "profileImageURL"
}
