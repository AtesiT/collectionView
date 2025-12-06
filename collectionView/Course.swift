//  Используем URL, поэтому оставляем Foundation
import Foundation

struct Course: Decodable {
//    let name: String
//    let imageUrl: URL
//    let number_of_lessons: Int
//    let number_of_tests: Int
    let name: String
    let language: String
    let id: String
    
    //  If JSON names will not as we have then:
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case id = "id"
    }
}
