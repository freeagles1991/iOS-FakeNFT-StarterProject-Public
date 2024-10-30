import UIKit

final class TabBarController: UITabBarController {


    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalogTabBarIcon_nonactive"),
        selectedImage: UIImage(named: "catalogTabBarIcon_active")
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cartTabBarIcon_nonactive"),
        selectedImage: UIImage(named: "cartTabBarIcon_active")
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogAssembly = CatalogAssembly(servicesAssembly: servicesAssembly)
        let cataloViewController = catalogAssembly.build()
        let catalogNavigationController = UINavigationController(rootViewController: cataloViewController)
        
        catalogNavigationController.tabBarItem = catalogTabBarItem
        
        let cartNavigationController = configureCartVC()

        viewControllers = [catalogNavigationController, cartNavigationController]
        view.backgroundColor = .systemBackground
    }
    
    //Конфигурируем вкладку корзины
    private func configureCartVC() -> UIViewController {
        let cartAssembly = CartAssembly(servicesAssembler: servicesAssembly)
        let cartController = cartAssembly.build()
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartNavigationController.modalPresentationStyle = .fullScreen
        cartNavigationController.tabBarItem = cartTabBarItem
        return cartNavigationController
    }
    
}
