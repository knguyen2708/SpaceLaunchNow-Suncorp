import Foundation

struct AstronautDetails: Hashable, Decodable {
    let id: Int
    let name: String
    let nationality: String
    let dateOfBirth: String
    let profileImage: URL
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nationality
        case dateOfBirth = "date_of_birth"
        case profileImage = "profile_image"
        case bio
    }
}

extension AstronautDetails {
    /// Parsed date of birth, or `nil` if date string is invalid.
    var dateOfBirth_parsed: Date? {
        Self.dateFormatter.date(from: dateOfBirth)
    }
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        return df
    }()
}

/*
Sample JSON:

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
    "bio": "Marcos Cesar Pontes (born March 11, 1963) is a Brazilian Air Force pilot, engineer, AEB astronaut and author. He became the first South American and the first Lusophone to go into space when he launched into the International Space Station aboard Soyuz TMA-8 on March 30, 2006. He is the only Brazilian to have completed the NASA astronaut training program, although he switched to training in Russia after NASA's Space Shuttle program encountered problems.",
    "profile_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/astronaut_images/marcos2520pontes_image_20181201212435.jpg",
    "profile_image_thumbnail": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/default/cache/b5/9b/b59bb16a31087708ffb212d3e6938946.jpg",
    "wiki": "https://en.wikipedia.org/wiki/Marcos_Pontes",
    "flights": [
        {
            "id": "04c37c93-9024-4b56-a419-71d8c8650512",
            "url": "https://spacelaunchnow.me/api/ll/2.2.0/launch/04c37c93-9024-4b56-a419-71d8c8650512/",
            "launch_library_id": 891,
            "slug": "https://spacelaunchnow.me/launch/soyuz-fg-soyuz-tma-8",
            "name": "Soyuz-FG | Soyuz TMA-8",
            "status": {
                "id": 3,
                "name": "Success"
            },
            "net": "2006-03-30T02:30:00Z",
            "window_end": "2006-03-30T02:30:00Z",
            "window_start": "2006-03-30T02:30:00Z",
            "inhold": false,
            "tbdtime": false,
            "tbddate": false,
            "probability": -1,
            "holdreason": null,
            "failreason": null,
            "hashtag": null,
            "launch_service_provider": {
                "id": 63,
                "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/63/",
                "name": "Russian Federal Space Agency (ROSCOSMOS)",
                "type": "Government"
            },
            "rocket": {
                "id": 521,
                "configuration": {
                    "id": 34,
                    "launch_library_id": 36,
                    "url": "https://spacelaunchnow.me/api/ll/2.2.0/config/launcher/34/",
                    "name": "Soyuz",
                    "family": "Soyuz-U",
                    "full_name": "Soyuz FG",
                    "variant": "FG"
                }
            },
            "mission": {
                "id": 202,
                "launch_library_id": 289,
                "name": "Soyuz TMA-8",
                "description": "Soyuz TMA-8 begins Expedition 13 by carrying 3 astronauts and cosmonauts to the International Space Station. \nRussian Commander, cosmonaut Pavel Vinogradov alongside Flight Engineers, Jeffrey Williams (NASA) & spaceflight participant Marcos Pontes (Space Adventures) will launch aboard the Soyuz spacecraft from the Baikonur Cosmodrome in Kazakhstan and then rendezvous with the station. \nIt landed on September 29, 2006, 01:13 UTC",
                "type": "Human Exploration",
                "orbit": "Low Earth Orbit",
                "orbit_abbrev": "LEO"
            },
            "pad": {
                "id": 32,
                "agency_id": null,
                "name": "1/5",
                "info_url": null,
                "wiki_url": "",
                "map_url": "https://www.google.com/maps/place/45Â°55'12.0\"N+63Â°20'31.2\"E",
                "latitude": "45.92",
                "longitude": "63.342",
                "location": {
                    "id": 15,
                    "name": "Baikonur Cosmodrome, Republic of Kazakhstan",
                    "country_code": "KAZ",
                    "map_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/launch_images/location_15_20200803142517.jpg",
                    "total_launch_count": 1531,
                    "total_landing_count": 0
                },
                "map_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/launch_images/pad_32_20200803143513.jpg",
                "total_launch_count": 487
            },
            "image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/launcher_images/soyuz_image_20190717035537.jpg",
            "infographic": null
        }
    ],
    "landings": [
        {
            "id": 211,
            "url": "https://spacelaunchnow.me/api/ll/2.2.0/spacecraft/flight/211/",
            "destination": "International Space Station",
            "mission_end": "2006-04-08T23:48:00Z",
            "spacecraft": {
                "id": 86,
                "url": "https://spacelaunchnow.me/api/ll/2.2.0/spacecraft/86/",
                "name": "Soyuz TMA-7",
                "serial_number": "Soyuz TMA 11F732A17 #217",
                "status": {
                    "id": 4,
                    "name": "Single Use"
                },
                "description": "Soyuz TMA-7 was a Soyuz spacecraft which launched on 1 October 2005 03:55 UTC. It transported two members of the Expedition 12 crew and one participant to the International Space Station. The Expedition 12 crew consisted of Valery Tokarev and William McArthur. The participant was tourist Gregory Olsen.",
                "configuration": {
                    "id": 1,
                    "url": "https://spacelaunchnow.me/api/ll/2.2.0/config/spacecraft/1/",
                    "name": "Soyuz",
                    "type": {
                        "id": 1,
                        "name": "Unknown"
                    },
                    "agency": {
                        "id": 63,
                        "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/63/",
                        "name": "Russian Federal Space Agency (ROSCOSMOS)",
                        "type": "Government"
                    },
                    "in_use": true,
                    "image_url": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/orbiter_images/soyuz_image_20201015191152.jpg"
                }
            },
            "launch": {
                "id": "0e886a0d-2e51-445b-bb5e-93b1f7083733",
                "url": "https://spacelaunchnow.me/api/ll/2.2.0/launch/0e886a0d-2e51-445b-bb5e-93b1f7083733/",
                "launch_library_id": 893,
                "slug": "https://spacelaunchnow.me/launch/soyuz-fg-soyuz-tma-7",
                "name": "Soyuz-FG | Soyuz TMA-7",
                "status": {
                    "id": 3,
                    "name": "Success"
                },
                "net": "2005-10-01T03:55:00Z",
                "window_end": "2005-10-01T03:55:00Z",
                "window_start": "2005-10-01T03:55:00Z",
                "inhold": false,
                "tbdtime": false,
                "tbddate": false,
                "probability": -1,
                "holdreason": null,
                "failreason": null,
                "hashtag": null,
                "launch_service_provider": {
                    "id": 63,
                    "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/63/",
                    "name": "Russian Federal Space Agency (ROSCOSMOS)",
                    "type": "Government"
                },
                "rocket": {
                    "id": 513,
                    "configuration": {
                        "id": 34,
                        "launch_library_id": 36,
                        "url": "https://spacelaunchnow.me/api/ll/2.2.0/config/launcher/34/",
                        "name": "Soyuz",
                        "family": "Soyuz-U",
                        "full_name": "Soyuz FG",
                        "variant": "FG"
                    }
                },
                "mission": {
                    "id": 126,
                    "launch_library_id": 290,
                    "name": "Soyuz TMA-7",
                    "description": "Soyuz TMA-7 begins Expedition 12 by carrying 3 astronauts and cosmonauts to the International Space Station. \nRussian Commander, cosmonaut Valery Tokarev alongside Flight Engineers, William McArthur (NASA) & spaceflight participant Gregory Olsen (Space Adventures) will launch aboard the Soyuz spacecraft from the Baikonur Cosmodrome in Kazakhstan and then rendezvous with the station. \nIt landed on \tApril 8, 2006, 23:48:00 UTC",
                    "type": "Human Exploration",
                    "orbit": "Low Earth Orbit",
                    "orbit_abbrev": "LEO"
                },
                "pad": {
                    "id": 32,
                    "agency_id": null,
                    "name": "1/5",
                    "info_url": null,
                    "wiki_url": "",
                    "map_url": "https://www.google.com/maps/place/45Â°55'12.0\"N+63Â°20'31.2\"E",
                    "latitude": "45.92",
                    "longitude": "63.342",
                    "location": {
                        "id": 15,
                        "name": "Baikonur Cosmodrome, Republic of Kazakhstan",
                        "country_code": "KAZ",
                        "map_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/launch_images/location_15_20200803142517.jpg",
                        "total_launch_count": 1531,
                        "total_landing_count": 0
                    },
                    "map_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/launch_images/pad_32_20200803143513.jpg",
                    "total_launch_count": 487
                },
                "image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/launcher_images/soyuz_image_20190717035537.jpg",
                "infographic": null
            }
        }
    ],
    "last_flight": "2006-03-30T02:30:00Z",
    "first_flight": "2006-03-30T02:30:00Z"
}
*/
