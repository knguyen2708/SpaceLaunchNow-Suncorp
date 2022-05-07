import Foundation
import Combine

/// `ListViewController`'s view model
class ListViewModel: ObservableObject {
    let dataSource: DataSourceProtocol

    /// Data state.
    ///
    /// `astronauts` and `sortedAstronauts` are only meaningful when `dataState` is `.success`.
    @Published var dataState: DataState = .loading
    
    /// Astronauts retrieved from server (not sorted).
    @Published var astronauts: [Astronaut] = []
    
    /// Sort order
    @Published var sortOrder: SortOrder = .nameAscending
    
    /// Sorted astronauts, computed from `astronauts` and `sortOrder`.
    @Published var sortedAstronauts: [Astronaut] = []

    private var cancellables = Set<AnyCancellable>()
    
    init(
        dataSource: DataSourceProtocol = DataSource()
    ) {
        self.dataSource = dataSource
        
        // Observe astronauts and sortOrder
        // and update sortedAstronaut when they change
        
        Publishers.CombineLatest(
            $astronauts,
            $sortOrder
        )
        .sink { [unowned self] (astronauts, sortOrder) in
            self.sortedAstronauts = astronauts.sorted(by: { x, y in
                switch sortOrder {
                case .nameAscending: return x.name.uppercased() < y.name.uppercased()
                case .nameDescending: return x.name.uppercased() > y.name.uppercased()
                }
            })
        }
        .store(in: &cancellables)
    }
    
    /// Refreshes astronauts by retrieving them from server
    func refreshAstronauts() {
        self.dataState = .loading
        
        dataSource.austronauts(completion: { result in
            switch result {
            case .success(let astronauts):
                self.astronauts = astronauts
                self.dataState = .available
                
            case .failure(let error):
                self.astronauts = []
                self.dataState = .failure(error: error.localizedDescription)
            }
        })
    }
    
    enum DataState: Hashable {
        case loading
        case available
        case failure(error: String)
    }
    
    enum SortOrder {
        case nameAscending, nameDescending
    }
}
