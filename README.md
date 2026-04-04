# redmi.dm

A feature-rich cross-platform mobile application built with Flutter, designed as a social networking platform with real-time messaging, community groups, timeline posts, and subscription-based premium features.

---

## Table of Contents

- [Project Overview](#project-overview)
- [App Idea & Core Concept](#app-idea--core-concept)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Installation & Run Guide](#installation--run-guide)
- [Usage](#usage)
- [Future Improvements](#future-improvements)
- [Contribution](#contribution)
- [License](#license)
- [Author](#author)

---

## Project Overview

**redmi.dm** (internally named `jobless`) is a comprehensive social networking mobile application built using Flutter. The app provides users with a platform to connect, share posts, join interest-based groups, engage in real-time messaging, and access premium subscription features. It supports both Android and iOS platforms with localization for multiple languages (English, Arabic, Spanish).

---

## App Idea & Core Concept

The application aims to create a social ecosystem where users can:
- Build personal profiles and connect with friends
- Share posts, feelings, and media on a personalized timeline
- Create and join group communities for focused discussions
- Engage in real-time one-on-one and group messaging
- Discover and interact with location-based content
- Access premium features through subscription plans

---

## Key Features

### Authentication & Onboarding
- Email/password-based authentication with OTP verification
- Location selection during registration
- Job category selection onboarding flow
- Email verification workflow

### Social Features
- **Timeline Posts**: Create, view, and interact with posts (like, comment, report)
- **Friend System**: Send/receive friend requests, manage friend lists
- **Groups**: Create, join, and manage groups with member invitations
- **Group Posts**: Dedicated timeline for group-specific content
- **Search**: Discover users, groups, and content
- **Block & Report**: User moderation with blocking and reporting capabilities

### Messaging
- **Real-time Chat**: One-on-one messaging with WebSocket integration
- **Group Messaging**: Create and manage group conversations
- **Message Groups**: Add/remove members, edit group details
- **Chat Lists**: Organized inbox with conversation previews

### Profile & Settings
- **Personal Info**: View and update profile information
- **Status Updates**: Set and manage user status
- **Settings**: Privacy controls, password change, account management
- **Support & Legal**: About, privacy policy, terms & conditions

### Premium Features
- **Subscription System**: RevenueCat-powered in-app purchases
- **Payment Integration**: Stripe payment processing
- **Premium Entitlements**: Access exclusive features with active subscription

### Additional Features
- **Push Notifications**: Real-time notification center
- **Localization**: Multi-language support (EN, AR, ES)
- **Dark/Light Theme**: Theme customization support
- **Responsive UI**: ScreenUtil-based adaptive layouts
- **File & Media Handling**: Image picker, file uploads, PDF viewing
- **Google Maps Integration**: Location-based features

---

## Architecture

The application follows a **Model-View-Controller (MVC)** architectural pattern with dependency injection and reactive state management.

```
┌─────────────────────────────────────────────────────┐
│                    Presentation Layer                │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │
│  │   Views      │  │   Widgets    │  │  Routes   │ │
│  │  (Screens)   │  │ (Components) │  │  (Get)    │ │
│  └──────┬───────┘  └──────────────┘  └───────────┘ │
│         │                                           │
├─────────┼───────────────────────────────────────────┤
│         ▼                                           │
│              Business Logic Layer                    │
│  ┌──────────────────────────────────────────────┐   │
│  │          Controllers (GetX)                  │   │
│  │  - Auth  - Home  - Message  - Profile        │   │
│  │  - Group - Notification - Settings           │   │
│  └──────────────────┬───────────────────────────┘   │
│                     │                               │
├─────────────────────┼───────────────────────────────┤
│                     ▼                               │
│              Data Layer                              │
│  ┌────────────┐  ┌────────────┐  ┌──────────────┐  │
│  │  Models    │  │  Services  │  │  Helpers     │  │
│  │            │  │  (API)     │  │  (Prefs)     │  │
│  └────────────┘  └────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────┘
```

### Key Architectural Decisions
- **GetX** for state management, routing, and dependency injection
- **Repository Pattern** for API data abstraction
- **Service Layer** for external integrations (API, WebSocket, Payments)
- **SharedPreferences** for local data persistence
- **Singleton Pattern** for shared resources (API client, socket manager)

---

## Tech Stack

### Core Framework
- **Flutter** (SDK >= 3.4.3)
- **Dart** language

### State Management & Routing
- **GetX** (4.7.2) - Reactive state management, routing, DI

### UI & UX
- **flutter_screenutil** - Responsive screen sizing
- **flutter_svg** - SVG asset rendering
- **flutter_spinkit** - Loading animations
- **lottie** - Lottie animations
- **shimmer** - Shimmer loading effects
- **cached_network_image** - Image caching
- **flutter_staggered_grid_view** - Grid layouts
- **circle_nav_bar** - Circular navigation bar
- **flutter_chat_bubble** - Chat bubble UI

### Networking & Real-time
- **http** - HTTP client
- **socket_io_client** - WebSocket real-time communication
- **dartz** - Functional programming (Either types)

### Payments & Subscriptions
- **flutter_stripe** (11.2.0) - Stripe payment integration
- **purchases_flutter** (8.9.0) - RevenueCat subscription management

### Maps & Location
- **google_maps_flutter** (2.12.1) - Google Maps integration
- **geolocator** - Location services
- **geocoding** - Address geocoding

### Storage & Files
- **shared_preferences** - Local key-value storage
- **sqflite** (2.4.2) - SQLite database
- **image_picker** - Camera/gallery access
- **file_picker** - File selection
- **path_provider** - File system paths
- **permission_handler** (12.0.0+) - Runtime permissions

### Utilities
- **intl** & **intl_phone_field** - Internationalization & phone formatting
- **pin_code_fields** - OTP input fields
- **grouped_list** - Grouped list views
- **mime** & **mime_type** - MIME type detection
- **image** - Image processing
- **flutter_html** (3.0.0-alpha.6) - HTML rendering
- **flutter_pdfview** (1.4.0+) & **flutter_cached_pdfview** - PDF viewing

### Dev Tools
- **flutter_launcher_icons** (0.14.3) - App icon generation
- **flutter_lints** (5.0.0) - Linting rules

---

## Project Structure

```
jobless-app/
├── lib/
│   ├── controllers/              # GetX controllers (business logic)
│   │   ├── auth_controller/      # Login, signup, email verification
│   │   ├── friendlist_controller/# Friend request & list management
│   │   ├── group_controller/     # Group CRUD operations
│   │   ├── home_controller/      # Timeline posts, blocking, reporting
│   │   ├── message_controller/   # Chat & messaging logic
│   │   ├── notification_controller/
│   │   ├── profile_controller/   # User profile management
│   │   ├── settings_controller/  # App settings
│   │   ├── subscription_controller/ # RevenueCat integration
│   │   ├── category_controller.dart
│   │   ├── file_controller.dart
│   │   ├── localization_controller.dart
│   │   ├── onboarding_controller.dart
│   │   ├── splash_controller.dart
│   │   └── theme_controller.dart
│   │
│   ├── helpers/                  # Utility helpers
│   │   ├── di.dart               # Dependency injection
│   │   ├── prefs_helpers.dart    # SharedPreferences wrapper
│   │   └── route.dart            # GetX route definitions
│   │
│   ├── models/                   # Data models
│   │   ├── error_response.dart
│   │   └── language_model.dart
│   │
│   ├── service/                  # API & external services
│   │   ├── api_check.dart        # API connectivity check
│   │   ├── api_client.dart       # HTTP client configuration
│   │   ├── api_constants.dart    # API endpoints & constants
│   │   ├── google_api_service.dart
│   │   ├── payment_service.dart  # Stripe payment handling
│   │   └── socket_maneger.dart   # WebSocket manager
│   │
│   ├── themes/                   # Theme configurations
│   │   ├── dark_theme.dart
│   │   └── light_theme.dart
│   │
│   ├── utils/                    # Constants & utilities
│   │   ├── app_constants.dart    # App-wide constants
│   │   ├── app_colors.dart       # Color palette
│   │   ├── app_icons.dart        # Icon assets paths
│   │   ├── app_image.dart        # Image asset paths
│   │   ├── app_string.dart       # String constants
│   │   ├── message.dart          # Localization messages
│   │   └── style.dart            # Text styles & utilities
│   │
│   ├── views/
│   │   ├── base/                 # Reusable UI components
│   │   │   ├── bottom_menu.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   └── ...
│   │   └── screen/               # Screen implementations
│   │       ├── Auth/             # Login, signup, verification
│   │       ├── Home/             # Home timeline & search
│   │       ├── Message/          # Messaging screens
│   │       ├── Notification/     # Notification center
│   │       ├── Profile/          # Profile, groups, settings
│   │       ├── Splash/           # Splash screen
│   │       ├── Widget/           # Custom widgets
│   │       └── onboarding_screen/# Onboarding flow
│   │
│   ├── main.dart                 # App entry point
│   └── revenue_const.dart        # RevenueCat constants
│
├── assets/
│   ├── font/                     # Custom fonts (Outfit, DMSans)
│   ├── icons/                    # SVG icons
│   ├── image/                    # Image assets
│   ├── language/                 # Localization files
│   └── lotti/                    # Lottie animations
│
├── android/                      # Android platform configuration
├── ios/                          # iOS platform configuration
├── pubspec.yaml                  # Project dependencies & config
└── README.md                     # Project documentation
```

---

## Installation & Run Guide

### Prerequisites

- **Flutter SDK** >= 3.4.3
- **Dart SDK** >= 3.4.3
- **Android Studio** / **Xcode** (for emulators)
- **Java JDK** 11+ (for Android builds)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd jobless-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   
   Create a `lib/s_key.dart` file with the following structure:
   ```dart
   class SKey {
     static const String publishLiveKey = 'your_stripe_publishable_key';
     // Add other API keys as needed
   }
   ```

4. **Update API Configuration**
   
   Modify `lib/service/api_constants.dart` with your backend URLs:
   ```dart
   static String baseUrl = "https://your-api-domain.com/v1";
   static String imageBaseUrl = "https://your-api-domain.com";
   static String socketUrl = "wss://your-websocket-domain.com";
   ```

5. **Configure RevenueCat** (for subscriptions)
   
   Update `lib/controllers/subscription_controller/revenue_cat_controller.dart`:
   ```dart
   configuration = PurchasesConfiguration("your_revenuecat_api_key");
   ```

6. **Run the app**
   ```bash
   # Check connected devices
   flutter devices

   # Run on Android
   flutter run

   # Run on iOS
   flutter run -d ios

   # Run on specific device
   flutter run -d <device-id>
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## Usage

### First Launch Flow
1. **Splash Screen** → App initialization & authentication check
2. **Onboarding** → Introduction screens with skip option
3. **Registration** → Location selection → Job category selection → Email verification → OTP confirmation
4. **Login** → Email/password → Home screen (for returning users)

### Main Navigation

The app uses a bottom navigation menu with four primary sections:

| Tab | Description |
|-----|-------------|
| **Home** | Timeline feed, post creation, search |
| **Messages** | Inbox with direct and group conversations |
| **Notifications** | Activity alerts and system notifications |
| **Profile** | Personal info, groups, friends, settings |

### Core Workflows

**Creating a Post:**
- Tap the post input field on Home screen
- Navigate to Feeling Post screen
- Add content and submit

**Starting a Conversation:**
- Navigate to Messages tab
- Tap "+" to create new chat or group
- Select friends and start messaging

**Managing Groups:**
- Access via Profile → My Groups
- Create groups, invite members, manage settings
- View group-specific timelines

**Subscription Management:**
- Profile → Subscription screen
- View available packages via RevenueCat
- Complete purchase through Stripe

---

## Future Improvements

- [ ] Video call integration for direct messaging
- [ ] Story/Status feature with 24-hour expiration
- [ ] Advanced content moderation & AI-based filtering
- [ ] Push notification improvements (Firebase Cloud Messaging)
- [ ] Offline mode with local database synchronization
- [ ] Advanced search filters (location, interests, activity)
- [ ] Post scheduling and draft saving
- [ ] Multi-media post support (albums, carousels)
- [ ] Event creation and management within groups
- [ ] Analytics dashboard for user engagement metrics
- [ ] Enhanced accessibility support (screen readers, high contrast)
- [ ] Web platform support
- [ ] End-to-end encryption for messages
- [ ] Content translation for multi-language posts

---

## Contribution

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Guidelines

- Follow existing code structure and naming conventions
- Ensure all tests pass before submitting PR
- Write clear commit messages
- Update documentation for significant changes
- Test on both Android and iOS before submission

---

## License

This project is proprietary software. All rights reserved.

Unauthorized copying, modification, distribution, or use of this software via any medium is strictly prohibited without explicit permission from the copyright holder.

---

## Author

**redmi.dm Development Team**

- Built with Flutter
- Powered by GetX architecture

---

*Last updated: April 2026*
