# Firebase-Testflight-CPSC357-Demo

<div align="center">
<img src="Assets.xcassets/AppIcon.appiconset/AppIcon.png" width="120" alt="Firebase iOS Template Logo">
</div>

## 📱 Overview

A comprehensive open-source template for developing full-stack iOS applications with Firebase. This template provides a solid foundation for building iOS applications with authentication, real-time database, cloud storage, and TestFlight integration.

## ✨ Features

- **Authentication**
  - Complete Firebase Authentication implementation
  - Login with email/password
  - Registration with email verification
  - Password reset functionality
  - Profile management and updates
  - Secure authentication flow

- **Navigation & Routing**
  - Custom navigation router for seamless screen transitions
  - Separation of authenticated and unauthenticated flows
  - Hierarchical navigation structure
  - Deep linking support

- **Architecture**
  - MVVM (Model-View-ViewModel) architecture
  - Clean separation of concerns
  - SwiftUI integration
  - Observable view models for reactive UI updates
  - Dependency injection for better testability

- **Firebase Integration**
  - Firebase Firestore database integration
  - Real-time data updates
  - Offline data persistence
  - Cloud Storage for file uploads

- **UI Components**
  - Reusable custom UI components
  - Responsive layouts that work across device sizes
  - Dark/light mode support
  - Accessibility considerations

- **TestFlight Ready**
  - Ready to deploy to TestFlight for beta testing
  - Configuration for beta distribution
  - Version and build number management

- **Network Handling**
  - Network connectivity monitoring
  - Graceful offline mode handling
  - Error handling and user feedback

## 🛠️ Technologies

- **Swift** - Primary programming language
- **SwiftUI** - UI framework for building the user interface
- **Firebase**
  - Authentication - User management and auth flows
  - Firestore - NoSQL cloud database
  - Storage - File storage solution
  - Analytics - Usage tracking (optional)
- **Swift Data** - Local data persistence
- **Combine** - Reactive programming


## 📋 Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Firebase (Google) account
- CocoaPods or Swift Package Manager

## 🚀 Getting Started

### Prerequisites

- Xcode 15+ installed
- Firebase (Google) account

### Installation

1. Clone this repository
   ```bash
   git clone https://github.com/yourusername/firebase-ios-template.git
   cd firebase-ios-template
   ```

2. Set up your Firebase project
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Add an iOS app to your Firebase project
   - Download your `GoogleService-Info.plist` and add it to your project
   - Enable the authentication methods you want to use
   - Set up Firestore/Realtime Database as needed


3. Open the `.xcworkspace` file to launch XCode and run the project

## 🏗️ Project Structure

```
Firebase-iOS-Template/
├── App/                    # App entry point and configuration
├── Model/                  # Data models and structures
├── ViewModels/             # ViewModels for business logic
├── Views/                  # SwiftUI views organized by feature
│   ├── Auth/               # Authentication-related views
│   ├── Home/               # Main app views
│   ├── Community/          # Community-related views
├── NavigationRouter/       # Custom navigation system (helpful for routing notifications to views)
├── Components/             # Reusable UI components
├── Utils/                  # Utility functions and extensions
├── NetworkMonitor/         # Network connectivity monitoring
├── Notifications/          # Push notification handling
```

## 🧩 Usage

### Authentication

The template provides a complete authentication flow including:

```swift
// Login example
authViewModel.signIn(email: email, password: password)

// Registration example
authViewModel.register(email: email, password: password, name: name)

// Password reset
authViewModel.resetPassword(email: email)
```

### Navigation Router

The template uses a custom router for navigation:
```swift
// Navigate to a view within the authenticated flow
router.navigate(to: .home)
```

## 🎨 Customization

### Theme and Styling

Modify the color schemes and styles in the `ColorType.swift` file to match your App's design identity.

### Firebase Configuration

Edit the `AppDelegate.swift` file to configure Firebase services based on your requirements.

Follow the instructions from Firebase when you create a new project to ensure you have the correct setup:
- Make sure to copy over `GoogleService-Info.plist` to your project root
- Add the Firebase SDK by adding package dependencies in Swift
- In your app entry point, add the app delegate

## 🛫 TestFlight Distribution

The template is configured for easy TestFlight distribution:

1. Add a compatible App Icon according to the [iOS guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
2. Add the appropriate signing & capabilities (notifications, healthkit, etc.)
3. Modify your Info.plist with the required iOS usage descriptions
4. Navigate to Product > Archive and distribute your app to App Store Connect
   - Note that you need a valid Apple Developer subscription to deploy to TestFlight and use App Store Connect

## 🔥 Firebase Project Information

For security reasons, this template does not include actual Firebase credentials. You must create your own Firebase project and add your own `GoogleService-Info.plist` file.

## 👥 Best Practices

- Keep sensitive information out of your repository (use `.gitignore` for `GoogleService-Info.plist`)
- Use environment variables for API keys when possible
- Follow the established MVVM pattern for new features
- Write tests for ViewModels and critical app logic
- Document your code for team members

## 👥 Contributors

- Luc Rieffel
- More contributors welcome!

## 📄 License

This project is available under the MIT license. See the LICENSE file for more info.

## 📞 Support

For support or questions, please open an issue on the GitHub repository. 