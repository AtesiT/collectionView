//  Используем URL, поэтому оставляем Foundation
import Foundation

struct Course: Decodable {
    let name: String
    let imageUrl: URL
    let number_of_lessons: Int
    let number_of_tests: Int
    
}
