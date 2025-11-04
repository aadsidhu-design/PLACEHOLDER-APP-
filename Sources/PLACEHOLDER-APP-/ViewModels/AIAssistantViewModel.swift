
import Foundation

class AIAssistantViewModel: ObservableObject {
    @Published var response: String = "" 

    func getBusinessIdeas(userInterests: [String]) {
        let apiKey = "AIzaSyDwtGElGSno15x83lQvgSvsaTIX98ca4A4"
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=\(apiKey)"

        let prompt = "Based on these interests: \(userInterests.joined(separator: ", ")), generate 3 business ideas."

        let parameters: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]

        guard let url = URL(string: endpoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(GoogleAIResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.response = decodedResponse.candidates.first?.content.parts.first?.text ?? "No ideas found."
                    }
                }
            }
        }.resume()
    }
}

struct GoogleAIResponse: Codable {
    let candidates: [Candidate]
}

struct Candidate: Codable {
    let content: Content
}

struct Content: Codable {
    let parts: [Part]
}

struct Part: Codable {
    let text: String
}
