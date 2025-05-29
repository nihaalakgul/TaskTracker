//
//  MotivationService.swift
//  TaskTracker
//
//  Created by Nihal Akgül on 25.05.2025.
//


import Foundation

struct Quote: Decodable {
    let text: String
    let author: String?
}

class MotivationService {
    static let shared = MotivationService()

    private let urlString = "https://type.fit/api/quotes"

    func fetchRandomQuote(completion: @escaping (String) -> Void) {
        guard let url = URL(string: urlString) else {
            completion("Hedefini hatırla, devam et!")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion("Başarı küçük adımlarla gelir.")
                return
            }

            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                if let random = quotes.randomElement() {
                    completion(random.text)
                } else {
                    completion("Her gün yeni bir başlangıçtır.")
                }
            } catch {
                completion("Bugün her şeyi yapabilecek güçtesin")
            }
        }.resume()
    }
}
