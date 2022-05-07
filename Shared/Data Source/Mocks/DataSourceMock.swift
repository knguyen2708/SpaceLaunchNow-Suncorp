import Foundation
@testable import SpaceLaunchNow

/// Data source mock with fixed responses
struct DataSourceMock: DataSourceProtocol {
    let astronautsResult: Result<[Astronaut], Error>
    let astronautDetailsResult: Result<AstronautDetails, Error>
    
    func austronauts(completion: @escaping (Result<[Astronaut], Error>) -> Void) {
        completion(astronautsResult)
    }
    
    func astronautDetails(id: Int, completion: @escaping (Result<AstronautDetails, Error>) -> Void) {
        completion(astronautDetailsResult)
    }
}
