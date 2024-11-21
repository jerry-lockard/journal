# Journal - A Modern Flutter Journaling App

A beautiful and intelligent journaling application built with Flutter, featuring Material You dynamic theming, Firebase integration, and Gemini AI-powered insights.

## Features

- **Rich Journal Entries**
  - Text content with markdown support
  - Image attachments
  - Smart tag suggestions
  - AI-generated insights
  - Mood analysis

- **Smart Organization**
  - Calendar view with entry counts
  - Date-based filtering
  - Tag-based organization
  - Search functionality

- **Beautiful Design**
  - Material You dynamic colors
  - Responsive layout
  - Dark/Light theme support
  - Modern UI components

- **AI Integration**
  - Entry summaries
  - Tag suggestions
  - Mood analysis
  - Contextual insights

- **Firebase Backend**
  - Real-time data sync
  - Secure authentication
  - Cloud storage for images
  - Offline support

## Getting Started

### Prerequisites

- Flutter SDK (^3.5.4)
- Dart SDK (^3.5.4)
- Firebase project
- Gemini API key

### Environment Setup

Clone the repository

```bash
git clone https://github.com/yourusername/journal.git
cd journal
```

Copy the environment file

```bash
cp .env.example .env
```

Update the `.env` file with your API keys and configuration

Install dependencies

```bash
flutter pub get
```

Run the app

```bash
flutter run
```

### Firebase Setup

1. Create a new Firebase project
2. Add your application to the project
3. Download the configuration files:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
4. Place the configuration files in their respective directories
5. Enable required Firebase services:
   - Authentication
   - Cloud Firestore
   - Storage

## Project Structure

```
lib/
├── src/
│   ├── models/      # Data models
│   ├── providers/   # Riverpod providers
│   ├── screens/     # UI screens
│   ├── services/    # Business logic
│   └── widgets/     # Reusable widgets
├── main.dart        # App entry point
└── firebase_options.dart
```

## Development

### Version Control

This project follows Git best practices:

- Platform-specific directories (`/android`, `/ios`, `/windows`, `/linux`, `/macos`, `/web`) are included in the repository as they contain important configuration files
- Generated files and build artifacts are properly ignored via `.gitignore`
- Sensitive information (API keys, keystores) is excluded from version control
- The `.gitignore` file is configured to handle:
  - Build artifacts and generated files
  - IDE-specific files
  - Platform-specific build outputs
  - Environment files
  - Firebase configuration
  - Code generation outputs

### Code Generation

The project uses several code generation tools:

```bash
# Run all code generators
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Dependencies

- `firebase_core`: ^2.24.2
- `firebase_auth`: ^4.15.3
- `cloud_firestore`: ^4.13.6
- `firebase_storage`: ^11.5.6
- `flutter_riverpod`: ^2.4.9
- `google_fonts`: ^6.1.0
- `dynamic_color`: ^1.6.8
- `google_generative_ai`: ^0.2.0
- View `pubspec.yaml` for complete list

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for the robust backend
- Google for the Gemini AI API

## Thank you for using journal
