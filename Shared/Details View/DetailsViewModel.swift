import Foundation
import Combine

/// `DetailsViewController`'s view model.
class DetailsViewModel: ObservableObject {
    let astronaut: Astronaut
    @Published var dataState: DataState = .loading
    
    let dataSource: DataSourceProtocol
    
    init(
        astronaut: Astronaut,
        dataSource: DataSourceProtocol = DataSource()
    ) {
        self.astronaut = astronaut
        self.dataSource = dataSource
    }
    
    /// Refreshes data
    func refresh() {
        self.dataState = .loading
        
        dataSource.astronautDetails(id: self.astronaut.id, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let astronautDetails):
                self.dataState = .available(astronautDetails)
                
            case .failure(let error):
                self.dataState = .failure(error: error.localizedDescription)
            }
        })
    }
    
    /// Data state
    enum DataState: Hashable {
        case loading
        case available(AstronautDetails)
        case failure(error: String)
    }
}
