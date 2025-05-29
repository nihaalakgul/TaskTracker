import Foundation

struct Task: Codable, Identifiable {
    var id: Int
    var title: String
    var description: String
    var isCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case isCompleted = "is_completed"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        let isCompletedInt = try container.decode(Int.self, forKey: .isCompleted)
        isCompleted = isCompletedInt != 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(isCompleted ? 1 : 0, forKey: .isCompleted)
    }

    init(id: Int, title: String, description: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
}

