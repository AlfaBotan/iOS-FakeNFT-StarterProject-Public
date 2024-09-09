import UIKit

class ProfileViewModel {
    var userName: Observable<String> = Observable("")
    var userDescription: Observable<String> = Observable("")
    var userWebsite: Observable<String> = Observable("")
    var userImage: Observable<UIImage?> = Observable(nil)
    
    let menuItems = [
        NSLocalizedString("Profile.myNft", comment: "myNft"),
        NSLocalizedString("Profile.favoritesNft", comment: "favoritesNft"),
        NSLocalizedString("Profile.aboutAuthor", comment: "aboutAuthor")
    ]
    
    func viewDidLoad() {
        userName.value = "Joaquin Phoenix"
        userDescription.value = "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
        userWebsite.value = "JoaquinPhoenix.com"
        userImage.value = UIImage(named: "ProfileMokIMG")
    }
    
    func didSelectMenuItem(at index: Int) {
        // Обработка выбора меню
    }
    
    func didTapWebsite(url: URL) {
        // Обработка перехода на сайт
    }
}
