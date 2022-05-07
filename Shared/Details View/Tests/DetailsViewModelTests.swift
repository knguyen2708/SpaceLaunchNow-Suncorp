import Foundation
import XCTest
@testable import SpaceLaunchNow

class DetailsViewModelTests: XCTestCase {
    func test_loading() {
        let astronautDetails = AstronautDetails(
            id: 100,
            name: "Dickinson",
            nationality: "US",
            dateOfBirth: "1886-05-15",
            profileImage: URL(string: "https://abc.xyz")!,
            bio: "Important"
        )
        
        let dataSource = DataSourceMock(
            astronautsResult: .failure(NSError()),
            astronautDetailsResult: .success(astronautDetails)
        )
        
        let astronaut = Astronaut(
            id: 100,
            name: "Dickinson",
            nationality: "US",
            profileImageThumbnail: URL(string: "https://xyz.abc")!
        )
        
        let vm = DetailsViewModel(
            astronaut: astronaut,
            dataSource: dataSource
        )
        
        // Refresh
        // Default sort order should be name ascending
        
        XCTAssertEqual(vm.dataState, .loading)
        
        vm.refresh()
        
        XCTAssertEqual(vm.dataState, .available(astronautDetails))
    }
    
    func test_loading_failure() {
        struct MyError: LocalizedError {
            var errorDescription: String? { "My Error" }
        }
        
        let dataSource = DataSourceMock(
            astronautsResult: .failure(NSError()),
            astronautDetailsResult: .failure(MyError())
        )
        
        let astronaut = Astronaut(
            id: 100,
            name: "Dickinson",
            nationality: "US",
            profileImageThumbnail: URL(string: "https://xyz.abc")!
        )
        
        let vm = DetailsViewModel(
            astronaut: astronaut,
            dataSource: dataSource
        )
        
        // Refresh
        // Default sort order should be name ascending
        
        XCTAssertEqual(vm.dataState, .loading)
        
        vm.refresh()
        
        XCTAssertEqual(vm.dataState, .failure(error: "My Error"))
    }
}
