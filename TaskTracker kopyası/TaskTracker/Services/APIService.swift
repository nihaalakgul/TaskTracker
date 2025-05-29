import Foundation

class APIService {
    static let shared = APIService()
    let baseURL = "http://localhost:3006/tasks"

    // GET: Görevleri listele
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let tasks = try JSONDecoder().decode([Task].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // POST: Yeni görev ekle
    func addTask(task: Task, completion: @escaping () -> Void) {
        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "title": task.title,
            "description": task.description,
            "isCompleted": task.isCompleted
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }

    // PUT: Görev güncelle
    func updateTask(task: Task, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(baseURL)/\(task.id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "title": task.title,
            "description": task.description,
            "isCompleted": task.isCompleted
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }

    // DELETE: Görev sil
    func deleteTask(taskId: Int, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(baseURL)/\(taskId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}

