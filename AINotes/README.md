# Notes App with AI Generation

A SwiftUI app that transforms your thoughts into well-structured notes using OpenAI's ChatGPT API.

## Features

- Clean, modern UI with animated mesh gradients
- Text input for your thoughts and ideas
- AI-powered note generation using OpenAI ChatGPT
- Real-time loading states and error handling
- Beautiful card-based layout for generated notes
- Sign-up modal with custom animations

## Setup

### 1. OpenAI API Key

To use the AI note generation feature, you need to set up your OpenAI API key:

1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Create a new API key
3. Open `Notes/OpenAIService.swift`
4. Replace `"YOUR_OPENAI_API_KEY"` with your actual API key:

```swift
private let apiKey = "sk-your-actual-api-key-here"
```

### 2. Build and Run

1. Open `Notes.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project (⌘+R)

## Usage

1. Enter your thoughts, ideas, or any text in the text editor
2. Tap "Generate Notes" to transform your input into structured notes
3. View the generated notes in the card below
4. Use the X button to clear the generated notes

## Architecture

- **ContentView**: Main UI with input and generated notes display
- **OpenAIService**: Handles API calls to OpenAI ChatGPT
- **PrimaryButton**: Custom animated button with mesh gradient
- **SignUpView**: Modal sign-up interface
- **AnimatedMeshGradient**: Beautiful gradient animation component

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- OpenAI API key

## Notes

- The app uses GPT-3.5-turbo for cost-effective note generation
- Generated notes are formatted with proper structure and bullet points
- Error handling includes network issues and API key validation
- The UI is designed to work on all iPhone sizes with proper safe area handling 