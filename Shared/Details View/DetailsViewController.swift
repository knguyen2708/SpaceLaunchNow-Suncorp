import Foundation
import UIKit
import Combine

class DetailsViewController: UIViewController {
    private let viewModel: DetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(astronaut: Astronaut) {
        self.viewModel = DetailsViewModel(astronaut: astronaut)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError() }
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        print("\(self) deinit")
    }
    
    var detailsScrollView: UIScrollView!
    var profileImageView: UIImageView!
    var profileImageWidthConstraint: NSLayoutConstraint!
    var infoLabel: UILabel! // Nationality + Date of birth
    var bioLabel: UILabel!
    
    var loadingView: UIActivityIndicatorView!
    var errorView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.astronaut.name
        
        initSubviews()
        observeViewModel()
        
        viewModel.refresh()
    }
    
    private func initSubviews() {
        view.backgroundColor = .systemBackground
        
        // Details views
        
        initDetailsViews()
        
        // Loading view
        
        loadingView = UIActivityIndicatorView(style: .large)
        view.addSubview(loadingView)
        loadingView.centerInSuperview()
        
        // Error view
        
        errorView = UILabel()
        errorView.textColor = .systemRed
        errorView.font = .preferredFont(forTextStyle: .body)
        errorView.adjustsFontForContentSizeCategory = true
        errorView.numberOfLines = 0
        errorView.textAlignment = .center
        view.addSubview(errorView)
        errorView.centerInSuperview()
    }
    
    private func initDetailsViews() {
        // Scroll view
        
        detailsScrollView = UIScrollView()
        
        view.addSubview(detailsScrollView)
        detailsScrollView.pinEdgesToSuperview()
        
        // Stack view
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        stack.spacing = 15
        
        detailsScrollView.addSubview(stack)
        stack.pinEdgesToSuperview()
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalTo: detailsScrollView.widthAnchor)
        ])
        
        // Profile image view
        // Width constraint is stored to ensure the size matches with actual image when it is loaded
        
        profileImageView = UIImageView()
        profileImageWidthConstraint = profileImageView.constrainWidthTo(140)
        profileImageView.constrainHeightTo(175)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 3
        profileImageView.layer.cornerCurve = .continuous
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .systemGray6
        
        stack.addArrangedSubview(profileImageView)
        
        // Info (nationality + dob) view
        
        infoLabel = UILabel()
        infoLabel.textColor = .label
        infoLabel.font = .preferredFont(forTextStyle: .headline)
        infoLabel.adjustsFontForContentSizeCategory = true
        infoLabel.numberOfLines = 0
        
        stack.addArrangedSubview(infoLabel)
        
        // Bio view
        
        bioLabel = UILabel()
        bioLabel.textColor = .label
        bioLabel.font = .preferredFont(forTextStyle: .body)
        bioLabel.adjustsFontForContentSizeCategory = true
        bioLabel.numberOfLines = 0
        
        stack.addArrangedSubview(bioLabel)
        
    }
    
    private func observeViewModel() {
        viewModel.$dataState
            .sink { [unowned self] dataState in
                switch dataState {
                case .loading:
                    loadingView.isHidden = false
                    loadingView.startAnimating()
                    
                    errorView.isHidden = true
                    detailsScrollView.isHidden = true
                    
                case .available(let details):
                    detailsScrollView.isHidden = false
                    populateDetailsView(details)
                    
                    loadingView.isHidden = true
                    errorView.isHidden = true
                    
                case .failure(let error):
                    errorView.isHidden = false
                    errorView.text = error
                    
                    loadingView.isHidden = true
                    detailsScrollView.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func populateDetailsView(_ details: AstronautDetails) {
        profileImageView.image = nil
        
        ImageManager.shared.get(url: details.profileImage, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.profileImageView.image = image
                
                if image.size.width > 0 && image.size.height > 0 {
                    self.profileImageWidthConstraint.constant = self.profileImageView.frame.height * image.size.width / image.size.height
                }
                
            case .failure(_):
                break
            }
        })
        
        let dateOfBirth_formatted: String = details.dateOfBirth_parsed.flatMap {
            DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .none)
        } ?? details.dateOfBirth
        
        infoLabel.text = "\(details.nationality) | Born \(dateOfBirth_formatted)"
        bioLabel.text = details.bio
    }
}
