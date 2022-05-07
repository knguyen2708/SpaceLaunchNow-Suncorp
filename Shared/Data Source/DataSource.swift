import Foundation

/// Object that gets data from server.
///
/// Protocol is used for mocking.
protocol DataSourceProtocol {
    /// Gets all astronauts
    func austronauts(completion: @escaping (Result<[Astronaut], Error>) -> Void)
    
    /// Gets astronaut details given ID
    func astronautDetails(id: Int, completion: @escaping (Result<AstronautDetails, Error>) -> Void)
}


struct DataSource: DataSourceProtocol {
    let restClient = RestClient()
    
    func austronauts(completion: @escaping (Result<[Astronaut], Error>) -> Void) {
        let url = URL(string: "http://spacelaunchnow.me/api/3.5.0/astronaut/")!
        
        struct Output: Decodable {
            let results: [Astronaut]
        }
        
        restClient.get(url: url, completion: { (result: Result<Output, Error>)  in
            switch result {
            case .success(let output):
                completion(.success(output.results))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func astronautDetails(id: Int, completion: @escaping (Result<AstronautDetails, Error>) -> Void) {
        let url = URL(string: "http://spacelaunchnow.me/api/3.5.0/astronaut/")!.appendingPathComponent("\(id)")

        restClient.get(url: url, completion: { (result: Result<AstronautDetails, Error>)  in
            switch result {
            case .success(let details):
                completion(.success(details))

            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
