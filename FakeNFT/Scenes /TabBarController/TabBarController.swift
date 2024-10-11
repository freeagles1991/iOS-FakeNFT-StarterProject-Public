import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(systemName: "basket.fill"),
        tag: 2
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        //Конфигурируем вкладку корзины
        let cartAssembly = CartAssembly(servicesAssembler: servicesAssembly)
        let cartController = cartAssembly.build()
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartNavigationController.modalPresentationStyle = .fullScreen
        cartNavigationController.tabBarItem = cartTabBarItem

        viewControllers = [catalogController, cartNavigationController]

        view.backgroundColor = .systemBackground
    }
    
}
