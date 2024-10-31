import Foundation
import Kingfisher

protocol SuccessPurchasePresenter {
    func loadNftImage()
    func onDoneButtonTapped()
}

final class SuccessPurchasePresenterImpl: SuccessPurchasePresenter {
    
    // MARK: - Public Properties
    weak var view: SuccessPurchaseViewCotroller?

    // MARK: - Public Methods
    func loadNftImage() {
        let cache = ImageCache.default
        guard let imageURLString = CartStore.nftLargeImageURL?.absoluteString else {return}
        cache.retrieveImage(forKey: imageURLString) { [weak self] result in
            switch result {
            case .success(let value):
                guard let self else {return}
                if let image = value.image {
                    self.view?.updateNftImage(image)
                } else {
                    self.view?.loadNftImage(CartStore.nftLargeImageURL)
                }
            case .failure(let error):
                print("SuccessPurchaseViewControllerImpl: Ошибка загрузки изображения: \(error)")
            }
        }
    }
    
    func onDoneButtonTapped() {
        view?.navigationController?.popToRootViewController(animated: true)
    }
}
