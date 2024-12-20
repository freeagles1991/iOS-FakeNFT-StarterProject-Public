import Foundation
import UIKit

protocol SortingDelegate: AnyObject {
    func sortNFTs(by sortingMethod: SortingMethod)
}

final class SortingHelper {
    private static let sortingMethodKey = "savedSortingMethodInCart"
    private static let sortingMethodKeyForMyNFTs = "savedSortingMethodInMyNFTs"
    
    enum Constants {
        static let cancelButtonString = NSLocalizedString("Sorting_CancelButton", comment: "Cancel button title for sorting")
        static let titleString = NSLocalizedString("Sorting_Title", comment: "Title for sorting screen")
    }

    static var savedSortingMethodInCart: SortingMethod {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: sortingMethodKey),
               let method = SortingMethod(rawValue: rawValue) {
                return method
            }
            return .name
        }
        
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: sortingMethodKey)
        }
    }
    
    static var savedSortingMethodInMyNFTs: SortingMethod {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: sortingMethodKeyForMyNFTs),
               let method = SortingMethod(rawValue: rawValue) {
                return method
            }
            return .name
        }
        
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: sortingMethodKeyForMyNFTs)
        }
    }
    
    static func makeSortingAlertViewModel(sortingDelegate: SortingDelegate) -> AlertViewModel? {
        let sortingOptions: [SortingMethod] = [.price, .name, .rating]
        let alertActions = sortingOptions.map { sortingMethod in
            AlertViewModel.AlertAction(title: sortingMethod.displayName, style: .default) {
                SortingHelper.savedSortingMethodInCart = sortingMethod
                sortingDelegate.sortNFTs(by: sortingMethod)
            }
        }
        let cancelAction = AlertViewModel.AlertAction(title: Constants.cancelButtonString, style: .cancel, handler: nil)
        let alertViewModel = AlertViewModel(
            title: Constants.titleString,
            message: nil,
            actions: alertActions + [cancelAction],
            preferredStyle: .actionSheet
        )
        return alertViewModel
    }
}
