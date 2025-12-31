import Foundation

struct CharacterListResponseDTO: Decodable {
    let info: InfoDTO
    let results: [CharacterDTO]
}

struct InfoDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: OriginDTO
    let location: LocationDTO
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    func toDomain() -> Character {
        return Character(
            id: id,
            name: name,
            status: Status(rawValue: status.capitalized) ?? .unknown,
            species: species,
            type: type,
            gender: Gender(rawValue: gender.capitalized) ?? .unknown,
            origin: origin.toDomain(),
            location: location.toDomain(),
            image: image,
            episode: episode,
            url: url,
            created: created
        )
    }
}

struct OriginDTO: Decodable {
    let name: String
    let url: String
    
    func toDomain() -> Origin {
        return Origin(name: name, url: url)
    }
}

struct LocationDTO: Decodable {
    let name: String
    let url: String
    
    func toDomain() -> Location {
        return Location(name: name, url: url)
    }
}
