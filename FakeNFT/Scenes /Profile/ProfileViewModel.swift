import UIKit
import Kingfisher

class ProfileViewModel {
    
    static let shared = ProfileViewModel()
    
    private init() {
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), storage: ProfileStorageImpl())
    }
    
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
    private var profile: Profile? = nil
    private let profileService: ProfileService
    private let userNameKey = "userName"
    private let userDescriptionKey = "userDescription"
    private let userWebsiteKey = "userWebsite"
    private let userImageKey = "userImage"
    
    let menuItems = [
        NSLocalizedString("Profile.myNft", comment: "myNft"),
        NSLocalizedString("Profile.favoritesNft", comment: "favoritesNft"),
        NSLocalizedString("Profile.aboutAuthor", comment: "aboutAuthor")
    ]
    
    func viewDidLoad(completion: @escaping () -> Void) {
            loadProfile(completion: completion)
        }
    
    // Сохранение данных в UserDefaults
    func saveProfile() {
        
        UserDefaults.standard.set(userName.value, forKey: userNameKey)
        UserDefaults.standard.set(userDescription.value, forKey: userDescriptionKey)
        UserDefaults.standard.set(userWebsite.value, forKey: userWebsiteKey)
        guard let profile = profile, let imageURL = imageURL else { return }
        profileService.sendExamplePutRequest(likes: profile.likes, avatar: imageURL, name: userName.value) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                print("Profile saved")
            case .failure:
                print("Error saving profile")
            }
        }
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
    private func loadProfile(completion: @escaping () -> Void) {
        profileService.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                print("SUCCESS \(profile)")
                self?.profile = profile
                self?.userName.value = profile.name
                self?.userDescription.value = profile.description
                self?.userWebsite.value = profile.website
                self?.userImage.value = URL(string: profile.avatar)
                completion()  // Уведомляем, что данные успешно загружены
            case .failure(let error):
                print("ERROR \(error.localizedDescription)")
                completion()  // Вызовем completion даже в случае ошибки
            }
        }
    }
}

private enum Constants {
    static let profileImageKey = "profileImageURL"
}
