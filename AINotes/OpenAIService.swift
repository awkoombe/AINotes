import Foundation

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message?
    let delta: Message?
}

struct Message: Codable {
    let role: String?
    let content: String?
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let max_tokens: Int
    let temperature: Double
    let stream: Bool
}

class OpenAIService: ObservableObject {
    @Published var isLoading = false
    @Published var isStreaming = false
    @Published var generatedNotes: String = ""
    @Published var errorMessage: String = ""
    
    private let apiKey: String = {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            print("⚠️ No API key found in environment variables. Please set OPENAI_API_KEY in your scheme.")
            return ""
        }
        return apiKey
    }()
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func generateNotes(from input: String) async {
        await MainActor.run {
            isLoading = true
            isStreaming = false
            errorMessage = ""
            generatedNotes = ""
        }
        
        // Only check if input is empty
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else {
            await MainActor.run {
                errorMessage = "Please enter some text to generate notes."
                isLoading = false
            }
            return
        }
        
        // Validate API key format
        guard !apiKey.isEmpty else {
            await MainActor.run {
                errorMessage = "API key cannot be empty. Please set your OpenAI API key in OpenAIService.swift"
                isLoading = false
            }
            return
        }
        
        guard apiKey.starts(with: "sk-") else {
            await MainActor.run {
                errorMessage = "Invalid API key format. OpenAI API keys should start with 'sk-'. Please get a valid API key from https://platform.openai.com/api-keys"
                isLoading = false
            }
            return
        }
        
        let prompt = """
You are an intelligent assistant that provides helpful responses based on what the user needs.

INSTRUCTIONS:
1. If the user asks you to CREATE something (write, compose, make, generate content), provide the actual content they requested
2. If the user asks for INFORMATION or wants to learn about something, organize it into clear notes
3. If the user gives you raw information to organize, structure it into notes
4. Always respond in a clear, useful format

FORMATTING RULES:
- Use UPPERCASE for main section titles when organizing information
- Use "- " for bullet points
- Use "1. ", "2. ", etc. for numbered lists when order matters
- Keep creative content (poems, stories, etc.) in natural paragraph form
- Add blank lines between sections

EXAMPLES:

User asks: "Write a poem about love"
Response: A beautiful poem in verses, not notes about poetry

User asks: "Tell me about photosynthesis"
Response: 
PHOTOSYNTHESIS
- Process plants use to make food from sunlight
- Occurs in chloroplasts containing chlorophyll
- Converts carbon dioxide and water into glucose and oxygen

User asks: "Meeting notes: discussed budget, timeline, next steps"
Response:
MEETING SUMMARY
- Budget discussion completed
- Timeline reviewed and approved
- Next steps identified

Respond to this user request: \(trimmedInput)
"""
        
        let request = OpenAIRequest(
            model: "gpt-3.5-turbo",  // Changed from gpt-4o-mini to a valid model
            messages: [Message(role: "user", content: prompt)],
            max_tokens: 2000,
            temperature: 0.7,
            stream: true
        )
        
        guard let url = URL(string: baseURL) else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
            
            let (bytes, response) = try await URLSession.shared.bytes(for: urlRequest)
            
            // Check HTTP response status
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            await MainActor.run {
                isLoading = false
                isStreaming = true
            }
            
            for try await line in bytes.lines {
                guard !line.isEmpty else {
                    print("Empty line received")
                    continue
                }
                guard line != "data: [DONE]" else {
                    print("Stream completed")
                    break
                }
                
                if line.hasPrefix("data: ") {
                    print("Received data line: \(line)")
                    let jsonString = String(line.dropFirst(6))
                    if let jsonData = jsonString.data(using: .utf8),
                       let response = try? JSONDecoder().decode(OpenAIResponse.self, from: jsonData),
                       let content = response.choices.first?.delta?.content {
                        print("Decoded content: \(content)")
                        await MainActor.run {
                            generatedNotes += content
                        }
                    } else {
                        print("Failed to decode line: \(jsonString)")
                    }
                } else {
                    print("Unexpected line format: \(line)")
                }
            }
            
            await MainActor.run {
                isStreaming = false
                isLoading = false
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
                isStreaming = false
                isLoading = false
            }
        }
    }
}
