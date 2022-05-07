import UIKit
import Combine

/// List (home) screen
///
/// Note: I tried to use table view diffable data source here,
/// however the API is different in Xcode 12 and 13.
/// Not sure which version be used by reviewer, so I just use the old `UITableViewDataSource`.
///
class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel = ListViewModel()
    
    private var sortBarButtonItem: UIBarButtonItem!
    private var refreshBarButtonItem: UIBarButtonItem!
    
    /// Table view
    private var tableView: UITableView!
    
    // private var tableDataSource = UITableViewDiffableDataSource<Int, Astronaut>(...)
    
    /// View displayed when data fails to load
    private var loadingView: UIActivityIndicatorView!
    
    /// View displayed when data fails to load
    private var errorView: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationItem()
        initSubviews()
        observeViewModel()
        
        viewModel.refreshAstronauts()
    }
    
    private func initNavigationItem() {
        // Navigation item
        
        navigationItem.title = "Space Launch Now (Suncorp)"
        
        self.refreshBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self, action: #selector(refresh)
        )
        
        navigationItem.leftBarButtonItem = refreshBarButtonItem
        
        self.sortBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.circle.fill"),
            style: .plain,
            target: self, action: #selector(presentSort)
        )
        
        navigationItem.rightBarButtonItem = sortBarButtonItem
    }
    
    @objc private func refresh() {
        viewModel.refreshAstronauts()
    }
    
    /// Creates sort bar button item
    @objc private func presentSort() {
        let sheet = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        sheet.popoverPresentationController?.barButtonItem = sortBarButtonItem
        
        sheet.addAction(UIAlertAction(title: "Name Ascending", style: .default, handler: { _ in
            self.viewModel.sortOrder = .nameAscending
        }))
        
        sheet.addAction(UIAlertAction(title: "Name Descending", style: .default, handler: { _ in
            self.viewModel.sortOrder = .nameDescending
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(sheet, animated: true, completion: nil)
    }
    
    private func initSubviews() {
        view.backgroundColor = .systemBackground
        
        // Table view
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.pinEdgesToSuperview()
        
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    private func observeViewModel() {
        viewModel.$dataState
            .sink { [unowned self] dataState in
                switch dataState {
                case .loading:
                    loadingView.isHidden = false
                    loadingView.startAnimating()
                    
                    errorView.isHidden = true
                    tableView.isHidden = true
                    
                    sortBarButtonItem.isEnabled = false
                    
                case .available:
                    tableView.isHidden = false
                    tableView.reloadData()
                    
                    loadingView.isHidden = true
                    errorView.isHidden = true
                    
                    sortBarButtonItem.isEnabled = true
                    
                case .failure(let error):
                    errorView.isHidden = false
                    errorView.text = error
                    
                    loadingView.isHidden = true
                    tableView.isHidden = true
                    
                    sortBarButtonItem.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.$sortedAstronauts
            .sink { [unowned self] astronauts in
                self.tableData = astronauts
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Table view
    
    private var tableData: [Astronaut] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let astronaut = tableData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.cellIdentifier, for: indexPath) as! ListCell
        cell.configure(with: astronaut)
        
        return cell
    }
    
    /*
    /// Reload data source using a list of astronauts
    private func reloadDataSource(_ astronauts: [Astronaut]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Astronaut>()
        
        snapshot.appendItems(astronauts)
        
        tableDataSource.apply(snapshot, animatingDifferences: true)
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let astronaut = tableData[indexPath.row]
        let detail = DetailsViewController(astronaut: astronaut)
        
        navigationController!.pushViewController(detail, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Misc
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Cell layout responds to content size category
        
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            // tableView.reloadData()
        }
    }
}
