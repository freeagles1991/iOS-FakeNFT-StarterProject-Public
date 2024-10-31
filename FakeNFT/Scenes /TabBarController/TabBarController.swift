import UIKit

final class TabBarController: UITabBarController {
    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        view.backgroundColor = .systemBackground
    }
    
    private func setupTabBar() {
        let catalogNavigationController = configureCatalogVC()
        let cartNavigationController = configureCartVC()
        let profileController = createProfileModule()
        
        viewControllers = [profileController, catalogNavigationController, cartNavigationController]
    }
    
    private func configureCatalogVC() -> UINavigationController {
        let catalogAssembly = CatalogAssembly(servicesAssembly: servicesAssembly)
        let catalogViewController = catalogAssembly.build()
        let catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = createTabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            imageName: "catalogTabBarIcon_nonactive",
            selectedImageName: "catalogTabBarIcon_active"
        )
        return catalogNavigationController
    }
    
    private func configureCartVC() -> UINavigationController {
        let cartAssembly = CartAssembly(servicesAssembler: servicesAssembly)
        let cartController = cartAssembly.build()
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartNavigationController.modalPresentationStyle = .fullScreen
        cartNavigationController.tabBarItem = createTabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            imageName: "cartTabBarIcon_nonactive",
            selectedImageName: "cartTabBarIcon_active"
        )
        return cartNavigationController
    }
    
    private func createProfileModule() -> UIViewController {
        let profileBuilder = AssemblyBuilderProfile(servicesAssembly: servicesAssembly)
        let profileController = profileBuilder.createProfileModule()
        profileController.tabBarItem = createTabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            imageName: "profileTabBarIcon_nonactive",
            selectedImageName: "profileTabBarIcon_active"
        )
        return profileController
    }
    
    //MARK: - Create Tab Bar Item
    private func createTabBarItem(title: String, imageName: String, selectedImageName: String) -> UITabBarItem {
        return UITabBarItem(
            title: title,
            image: UIImage(named: imageName),
            selectedImage: UIImage(named: selectedImageName)
        )
    }
}
