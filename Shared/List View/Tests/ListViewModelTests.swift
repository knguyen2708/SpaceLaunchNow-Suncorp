import Foundation
import XCTest
@testable import SpaceLaunchNow

class ListViewModelTests: XCTestCase {
    func test_loading_and_sorting() {
        let dataSource = DataSourceMock(
            astronautsResult: .success(
                [
                    Astronaut(
                        id: 1,
                        name: "Ben",
                        nationality: "Laos",
                        profileImageThumbnail: URL(string: "https://xyz.abc")!
                    ),
                    Astronaut(
                        id: 5,
                        name: "Annie",
                        nationality: "US",
                        profileImageThumbnail: URL(string: "https://abc.xyz")!
                    )
                ]
            ),
            astronautDetailsResult: .failure(NSError())
        )
        
        let vm = ListViewModel(dataSource: dataSource)
        
        // Refresh
        // Default sort order should be name ascending
        
        XCTAssertEqual(vm.dataState, .loading)
        
        vm.refreshAstronauts()
        
        XCTAssertEqual(vm.dataState, .available)
        XCTAssertEqual(vm.astronauts.map(\.id), [1, 5])
        
        XCTAssertEqual(vm.sortedAstronauts.map(\.name), ["Annie", "Ben"])
        
        // Change sort order to name descending
        
        vm.sortOrder = .nameDescending
        
        XCTAssertEqual(vm.sortedAstronauts.map(\.name), ["Ben", "Annie"])
        
        // Change back to name ascending
        
        vm.sortOrder = .nameAscending
        
        XCTAssertEqual(vm.sortedAstronauts.map(\.name), ["Annie", "Ben"])
    }
    
    func test_loading_failure() {
        struct MyError: LocalizedError {
            var errorDescription: String? { "My Error" }
        }
        
        let dataSource = DataSourceMock(
            astronautsResult: .failure(MyError()),
            astronautDetailsResult: .failure(MyError())
        )
        
        let vm = ListViewModel(dataSource: dataSource)
        
        // Refresh
        // Default sort order should be name ascending
        
        XCTAssertEqual(vm.dataState, .loading)
        
        vm.refreshAstronauts()
        
        XCTAssertEqual(vm.dataState, .failure(error: "My Error"))
        XCTAssertEqual(vm.astronauts.count, 0)
    }
}
