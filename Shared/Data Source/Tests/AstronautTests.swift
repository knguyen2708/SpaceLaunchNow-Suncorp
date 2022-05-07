import Foundation
import XCTest
@testable import SpaceLaunchNow

class AstronautTests: XCTestCase {
    func test_decode() {
        let json = """
        {
            "id": 276,
            "url": "https://spacelaunchnow.me/api/ll/2.2.0/astronaut/276/",
            "name": "Franz Viehböck",
            "status": {
                "id": 2,
                "name": "Retired"
            },
            "type": {
                "id": 2,
                "name": "Government"
            },
            "date_of_birth": "1960-08-24",
            "date_of_death": null,
            "nationality": "Austrian",
            "bio": "Franz Artur Viehböck (born August 24, 1960 in Vienna) is an Austrian electrical engineer, and was Austria's first cosmonaut. He was titulated „Austronaut“ by his country's media. He visited the Mir space station in 1991 aboard Soyuz TM-13, returning aboard Soyuz TM-12 after spending just over a week in space.",
            "twitter": null,
            "instagram": null,
            "wiki": "https://en.wikipedia.org/wiki/Franz_Viehb%C3%B6ck",
            "agency": {
                "id": 8,
                "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/8/",
                "name": "Austrian Space Agency",
                "featured": false,
                "type": "Government",
                "country_code": "AUT",
                "abbrev": "ALR",
                "description": "The Austrian Space Agency was founded in 1972 and joined the ESA as a member in 1987. In 2005, control of the ALR was transferred to the Austrian Agency for Aerospace. They coordinated the first flight of an Austrian in space with a Soyuz launch in 1990.",
                "administrator": "Andreas Geisler",
                "founding_year": "1972",
                "launchers": "",
                "spacecraft": "Spacelab | GALILEO",
                "parent": null,
                "image_url": null
            },
            "profile_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/astronaut_images/franz2520viehb25c325b6ck_image_20181201223901.jpg",
            "profile_image_thumbnail": "https://abc.xyz",
            "last_flight": "1991-10-02T05:59:38Z",
            "first_flight": "1991-10-02T05:59:38Z"
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode(Astronaut.self, from: jsonData)
        
        XCTAssertEqual(object.id, 276)
        XCTAssertEqual(object.name, "Franz Viehböck")
        XCTAssertEqual(object.nationality, "Austrian")
        XCTAssertEqual(object.profileImageThumbnail, URL(string: "https://abc.xyz")!)
    }
}
