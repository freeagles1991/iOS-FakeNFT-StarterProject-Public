import Foundation
import UIKit

final public class StarRatingView: UIView {
    private let maxStars = 5
    private var starViews: [UIImageView] = []
    
    public var rating: Int = 0 {
        didSet {
            updateStarImages()
        }
    }
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        for _ in 0..<maxStars {
            let starImageView = UIImageView()
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = UIImage(named: "emptyStar")
            
            addSubview(starImageView)
            starViews.append(starImageView)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        for (index, starView) in starViews.enumerated() {
            starView.leadingAnchor.constraint(equalTo: index == 0 ? leadingAnchor : starViews[index - 1].trailingAnchor, constant: 4).isActive = true
            starView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            starView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            starView.widthAnchor.constraint(equalTo: starView.heightAnchor).isActive = true
        }
        
        starViews.last?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func updateStarImages() {
        let filledStars = rating / 20
        
        for (index, starView) in starViews.enumerated() {
            if index < filledStars {
                starView.image = UIImage(named: "star_active")
            } else {
                starView.image = UIImage(named: "star_nonactive")
            }
        }
    }
}
