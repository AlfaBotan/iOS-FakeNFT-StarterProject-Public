import UIKit

class ProfileViewModel {
    var userName: Observable<String> = Observable("")
    var userDescription: Observable<String> = Observable("")
    var userWebsite: Observable<String> = Observable("")
    var userImage: Observable<UIImage?> = Observable(nil)
    
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
        
        if let image = userImage.value {
            if let imageData = image.pngData() {
                UserDefaults.standard.set(imageData, forKey: userImageKey)
            }
        }
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
        
        if let imageData = UserDefaults.standard.data(forKey: userImageKey), let image = UIImage(data: imageData) {
            userImage.value = image
        } else {
            userImage.value = UIImage(named: "ProfileMokIMG")
        }
    }
    
    func didSelectMenuItem(at index: Int) {
        // Обработка выбора меню
    }
    
    func didTapWebsite(url: URL) {
        // Обработка перехода на сайт
    }
}
