import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalogTabBarIcon_nonactive"),
        selectedImage: UIImage(named: "catalogTabBarIcon_active")
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        let catalogAssembly = CatalogAssembly(servicesAssembler: servicesAssembly)
        let cataloViewController = catalogAssembly.build()
        let catalogNavigationController = UINavigationController(rootViewController: cataloViewController)
        
        catalogNavigationController.tabBarItem = catalogTabBarItem
        viewControllers = [catalogNavigationController]
        view.backgroundColor = .systemBackground
    }
}
