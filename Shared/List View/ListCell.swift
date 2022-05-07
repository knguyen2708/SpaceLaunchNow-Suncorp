import Foundation
import UIKit

class ListCell: UITableViewCell {
    static let cellIdentifier = "list-cell"
    
    /// Astronaut the cell was most recently configured with.
    /// Needed to check whether the downloaded image is correct.
    private var astronaut: Astronaut?
    
    private var thumbnailView: UIImageView!
    private var nameLabel: UILabel!
    private var nationalityLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        initSubviews()
    }
    
    private func initSubviews() {
        contentView.insetsLayoutMarginsFromSafeArea = true
        contentView.layoutMargins = .init(top: 10, left: 15, bottom: 10, right: 15)
        
        // Create a nice layout
        // (default UITableViewCell layout doesn't look nice...)
        
        // Views
        
        thumbnailView = UIImageView()
        thumbnailView.constrainWidthTo(60)
        thumbnailView.constrainHeightTo(60)
        thumbnailView.layer.masksToBounds = true
        thumbnailView.layer.cornerRadius = 30
        thumbnailView.layer.cornerCurve = .continuous
        thumbnailView.backgroundColor = .systemGray6
        
        nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.numberOfLines = 0
        
        nationalityLabel = UILabel()
        nationalityLabel.textColor = .label
        nationalityLabel.font = .preferredFont(forTextStyle: .caption1)
        nationalityLabel.adjustsFontForContentSizeCategory = true
        nationalityLabel.numberOfLines = 0
        
        // Content stack (image on left, right stack on right)
        
        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.spacing = 14
        
        // Right stack (name/nationality)
        
        let rightStack = UIStackView()
        rightStack.axis = .vertical
        rightStack.alignment = .leading
        rightStack.isLayoutMarginsRelativeArrangement = true
        rightStack.layoutMargins = .init(top: 6, left: 0, bottom: 0, right: 0)
        rightStack.spacing = 3
        
        // Arrange things
        
        contentView.addSubview(contentStack)
        contentStack.pinEdgesToSuperviewMargins()
        
        contentStack.addArrangedSubview(thumbnailView)
        contentStack.addArrangedSubview(rightStack)
        
        rightStack.addArrangedSubview(nameLabel)
        rightStack.addArrangedSubview(nationalityLabel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    /// Configures cell with an astronaut
    func configure(with astronaut: Astronaut) {
        self.astronaut = astronaut
        
        nameLabel?.text = astronaut.name
        nationalityLabel?.text = astronaut.nationality
        
        let url = astronaut.profileImageThumbnail
        
        thumbnailView?.image = nil
        
        ImageManager.shared.get(url: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                // print("GOT IMAGE: \(url)")
                
                // If url doesn't match, it means the cell has been reused and astronaut has changed
                // Simply do nothing in that case
                
                if url == self.astronaut?.profileImageThumbnail {
                    self.thumbnailView?.image = image
                }
                
            case .failure(let error):
                print("FAILED IMAGE: \(url), \(error.localizedDescription)")
                
                // Do nothing
                break
            }
            
        })
    }
}
