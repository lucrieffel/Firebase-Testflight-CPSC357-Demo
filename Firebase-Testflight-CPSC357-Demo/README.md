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
  - Firebase Analytics for usage tracking
  - Push notification setup with Firebase Cloud Messaging

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
  - Analytics - User behavior tracking
  - Cloud Messaging - Push notifications
- **Swift Data** - Local data persistence
- **Combine** - Reactive programming

## 🔒 App Privacy & Permissions

The template may require access to:
- Push Notifications (for alerts and messaging)
- Photo Library (for avatar uploads)
- Camera (for profile pictures)
- Location Services (optional, for location-based features)

## 📱 App Showcase

### 📸 Screenshots

<div align="center">
<table>
  <tr>
    <td><img src="Screenshots/Auth/LoginView.png" width="200" alt="Login Screen"></td>
    <td><img src="Screenshots/Auth/RegistrationView.png" width="200" alt="Registration"></td>
    <td><img src="Screenshots/Home/HomeView.png" width="200" alt="Home"></td>
  </tr>
  <tr>
    <td align="center"><b>Login Screen</b></td>
    <td align="center"><b>Registration</b></td>
    <td align="center"><b>Home Screen</b></td>
  </tr>
  <tr>
    <td><img src="Screenshots/Profile/ProfileView.png" width="200" alt="Profile"></td>
    <td><img src="Screenshots/Auth/ResetPasswordView.png" width="200" alt="Password Reset"></td>
    <td><img src="Screenshots/Community/CommunityView.png" width="200" alt="Community"></td>
  </tr>
  <tr>
    <td align="center"><b>Profile</b></td>
    <td align="center"><b>Password Reset</b></td>
    <td align="center"><b>Community</b></td>
  </tr>
</table>
</div>

### 🔄 Interactive Features

<div align="center">
<table>
  <tr>
    <td width="33%"><b>Navigation Flow</b><br><img src="Screenshots/Navigation/NavigationFlow.gif" width="200" alt="Navigation Flow"></td>
    <td width="33%"><b>Authentication</b><br><img src="Screenshots/Auth/AuthFlow.gif" width="200" alt="Authentication Flow"></td>
    <td width="33%"><b>Real-time Updates</b><br><img src="Screenshots/Realtime/RealtimeUpdates.gif" width="200" alt="Realtime Updates"></td>
  </tr>
</table>
</div>

## 📋 Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Firebase account
- CocoaPods or Swift Package Manager

## 🚀 Getting Started

### Prerequisites

- Xcode 15+ installed
- Swift Package Manager or CocoaPods
- Firebase account (for backend services)

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

3. Install dependencies (if using CocoaPods)
   ```bash
   pod install
   ```

4. Open the `.xcworkspace` file and run the project

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
├── NavigationRouter/       # Custom navigation system
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

### Setting Up Firebase

Before using this template, you'll need to:

1. Replace the included `GoogleService-Info.plist` with your own
2. Configure Firebase Authentication methods in Firebase Console
3. Set up your Firestore database rules
4. Configure Storage rules if you're using Firebase Storage

### Navigation

The template uses a custom router for navigation:

```swift
// Navigate to a view within the authenticated flow
router.navigate(to: .home)

// Navigate with parameters
router.navigate(to: .userProfile(userId: "123"))
```

## 🎨 Customization

### Theme and Styling

Modify the color schemes and styles in the `ColorType.swift` file to match your brand identity.

### Firebase Configuration

Edit the `AppDelegate.swift` file to configure Firebase services based on your requirements.

## 🛫 TestFlight Distribution

The template is configured for easy TestFlight distribution:

1. Configure your app in App Store Connect
2. Set up the appropriate provisioning profiles
3. Build and archive your app
4. Upload to TestFlight via Xcode or Transporter

## 🔥 Firebase Project Information

For security reasons, this template does not include actual Firebase credentials. You must create your own Firebase project and add your own `GoogleService-Info.plist` file.

## 👥 Best Practices

- Keep sensitive information out of your repository (use `.gitignore` for `GoogleService-Info.plist`)
- Use environment variables for API keys when possible
- Follow the established MVVM pattern for new features
- Write tests for ViewModels and critical business logic
- Document your code for team members

## 👥 Contributors

- Your Name
- Contributors welcome!

## 📄 License

This project is available under the MIT license. See the LICENSE file for more info.

## 📞 Support

For support or questions, please open an issue on the GitHub repository. 