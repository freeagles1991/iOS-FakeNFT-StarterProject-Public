import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        view.backgroundColor = .systemBackground
    }
    
    private func setupViewControllers() {
        let catalogController = createCatalogModule()
        let profileController = createProfileModule()
        
        viewControllers = [profileController, catalogController]
    }
    
    private func createCatalogModule() -> UIViewController {
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = createTabBarItem(title: NSLocalizedString("Tab.catalog", comment: ""), imageName: "square.stack.3d.up.fill", tag: 1)
        return catalogController
    }
    
    private func createProfileModule() -> UIViewController {
        let builder = AssemblyBuilderProfile(servicesAssembly: servicesAssembly)
        let profileController = builder.createProfileModule()
        profileController.tabBarItem = createTabBarItem(title: "profile", imageName: "person.crop.circle.fill", tag: 0)
        return profileController
    }
    
    private func createTabBarItem(title: String, imageName: String, tag: Int) -> UITabBarItem {
        return UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: tag)
    }
}
