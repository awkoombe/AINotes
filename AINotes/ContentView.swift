import SwiftUI
import MarkdownUI

struct ContentView: View {
    @State private var inputText: String = ""
    @StateObject private var openAIService = OpenAIService()
    @State private var showSignUp: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Input Card
                    VStack(spacing: 20) {
                        Text("Generate Notes")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Transform your thoughts into well-structured notes using artificial intelligence.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextEditor(text: $inputText)
                            .frame(height: 200)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.primary.opacity(0.1), lineWidth: 1)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
                            )
                        
                        PrimaryButton(
                            isLoading: openAIService.isLoading,
                            isDisabled: inputText.isEmpty || openAIService.isStreaming,
                            action: {
                                Task {
                                    await openAIService.generateNotes(from: inputText)
                                }
                            }
                        )
                    }
                    .padding(32)
                    .background(Color(.systemBackground))
                    .cornerRadius(44)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding()
                    .blur(radius: showSignUp ? 10 : 0)
                    .disabled(showSignUp)
                    
                    // Generated Notes Card
                    if !openAIService.generatedNotes.isEmpty || openAIService.isLoading || openAIService.isStreaming || !openAIService.errorMessage.isEmpty {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Generated Notes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        openAIService.generatedNotes = ""
                                        openAIService.errorMessage = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            if openAIService.isLoading {
                                VStack(spacing: 12) {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                    Text("Preparing to generate...")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                            } else if openAIService.isStreaming && openAIService.generatedNotes.isEmpty {
                                VStack(spacing: 12) {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                    Text("Generating your notes...")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                            } else if !openAIService.errorMessage.isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.title2)
                                        .foregroundColor(.orange)
                                    Text(openAIService.errorMessage)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                            } else {
                                FormattedNotesView(notes: openAIService.generatedNotes)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(32)
                        .background(Color(.systemBackground))
                        .cornerRadius(44)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: openAIService.generatedNotes.isEmpty)
                    }
                }
                .padding(.top, 20)
                .blur(radius: showSignUp ? 5 : 0)
               
            }
            
            // Account Button - Floating at top right
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            showSignUp.toggle()
                        }
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 16)
                    .padding(.trailing)
                }
                Spacer()
            }
            .zIndex(1)
            .ignoresSafeArea()
            
            // SignUp View with animation
            if showSignUp {
                ZStack {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showSignUp = false
                            }
                        }
                    
                    VStack {
                        SignUpView()
                            .transition(.move(edge: .top).combined(with: .opacity))
                        Spacer()
                    }
                    .padding(.top, 60)
                }
                .zIndex(2)
            }
        }
    }
}

// Custom view for formatted notes
struct FormattedNotesView: View {
    let notes: String
    
    var body: some View {
        Markdown(notes)
            .markdownTheme(.gitHub)
            .textSelection(.enabled)
            .padding(.horizontal, 16)
    }
}

#Preview {
    ContentView()
}
