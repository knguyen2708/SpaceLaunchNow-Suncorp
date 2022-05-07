import Foundation
import XCTest
@testable import SpaceLaunchNow

class AstronautDetailsTest: XCTestCase {
    func test_decode() {
        let json = """
        {
            "id": 225,
            "url": "https://spacelaunchnow.me/api/ll/2.2.0/astronaut/225/",
            "name": "Marcos Pontes",
            "status": {
                "id": 1,
                "name": "Active"
            },
            "type": {
                "id": 2,
                "name": "Government"
            },
            "agency": {
                "id": 12,
                "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/12/",
                "name": "Brazilian Space Agency",
                "type": "Government"
            },
            "date_of_birth": "1963-03-11",
            "date_of_death": null,
            "nationality": "Brazilian",
            "twitter": null,
            "instagram": null,
            "bio": "abc xyz",
            "profile_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/astronaut_images/marcos2520pontes_image_20181201212435.jpg",
            "profile_image_thumbnail": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/default/cache/b5/9b/b59bb16a31087708ffb212d3e6938946.jpg",
            "wiki": "https://en.wikipedia.org/wiki/Marcos_Pontes",
            "last_flight": "2006-03-30T02:30:00Z",
            "first_flight": "2006-03-30T02:30:00Z"
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode(AstronautDetails.self, from: jsonData)
        
        XCTAssertEqual(object.id, 225)
        XCTAssertEqual(object.name, "Marcos Pontes")
        XCTAssertEqual(object.dateOfBirth, "1963-03-11")
        XCTAssertEqual(object.dateOfBirth_parsed, DateComponents(calendar: .current, year: 1963, month: 3, day: 11).date!)
        XCTAssertEqual(object.bio, "abc xyz")
    }
}
