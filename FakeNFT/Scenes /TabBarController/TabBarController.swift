import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

//        let catalogController = TestCatalogViewController(
//            servicesAssembly: servicesAssembly
//        )
//        catalogController.tabBarItem = catalogTabBarItem
//
//        viewControllers = [catalogController]
//
//        view.backgroundColor = .systemBackground
        
        let catalogPresenter: CatalogPresenter = CatalogPresenterImpl()
        let cataloViewController = CatalogViewController(presenter: catalogPresenter)
        cataloViewController.tabBarItem = catalogTabBarItem
        viewControllers = [cataloViewController]
        view.backgroundColor = .systemBackground
    }
}
