import UIKit

//final class TabBarController: UITabBarController {
//
//    var servicesAssembly: ServicesAssembly!
//
//    private let catalogTabBarItem = UITabBarItem(
//        title: NSLocalizedString("Tab.catalog", comment: ""),
//        image: UIImage(systemName: "square.stack.3d.up.fill"),
//        tag: 0
//    )
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let catalogController = TestCatalogViewController(
//            servicesAssembly: servicesAssembly
//        )
//        catalogController.tabBarItem = catalogTabBarItem
//
//        viewControllers = [catalogController]
//
//        view.backgroundColor = .systemBackground
//    }
//}

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let profileTabBarItem = UITabBarItem(
        title: "profile",
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let builder = AssemblyBuilderProfile(servicesAssembly: servicesAssembly)
        
        let profileController = builder.createProfileModule()
        profileController.tabBarItem = profileTabBarItem
        
        viewControllers = [profileController, catalogController]

        view.backgroundColor = .systemBackground
    }
}
