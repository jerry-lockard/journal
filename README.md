# Journal - A Modern Flutter Journaling App

A beautiful and intelligent journaling application built with Flutter, featuring Material You dynamic theming, Firebase integration, and Gemini AI-powered insights.

## Features

- 👤 **User Authentication**
  - Firebase Authentication integration
  - User-specific journal entries
  - Secure data access
  - Profile management

- 📝 **Rich Journal Entries**
  - Text content with markdown support
  - Image attachments with preview
  - Smart tag suggestions
  - AI-generated insights
  - Mood analysis
  - User attribution

- 📅 **Smart Organization**
  - Calendar view with entry counts
  - Date-based filtering
  - Tag-based organization
  - User-specific entries
  - Search functionality

- 🎨 **Beautiful Design**
  - Material You dynamic colors
  - Responsive layout
  - Dark/Light theme support
  - Modern UI components
  - Image previews
  - User-centric design

- 🤖 **AI Integration**
  - Entry summaries
  - Tag suggestions
  - Mood analysis
  - Contextual insights
  - Smart content analysis

- 🔥 **Firebase Backend**
  - Real-time data sync
  - Secure authentication
  - User-specific storage
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

Update the `.env` file with your API keys and configuration:

```env
# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_storage_bucket

# Google Gemini AI
GEMINI_API_KEY=your_gemini_api_key
```

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
2. Enable Authentication:
   - Go to Authentication > Sign-in methods
   - Enable Email/Password authentication
   - Configure other providers as needed

3. Set up Cloud Firestore:
   - Create a new database
   - Start in production mode
   - Set up security rules:

   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /entries/{entryId} {
         allow read: if request.auth != null && resource.data.userId == request.auth.uid;
         allow write: if request.auth != null && request.resource.data.userId == request.auth.uid;
       }
     }
   }
   ```

4. Configure Storage:
   - Enable Firebase Storage
   - Set up security rules:

   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /images/{userId}/{filename} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

5. Add your application:
   - Download configuration files:
     - `google-services.json` (Android)
     - `GoogleService-Info.plist` (iOS)
   - Place them in their respective directories

## Project Structure

```bash
lib/
├── main.dart
└── src/
    ├── models/
    │   └── journal_entry.dart      # Journal entry data model
    ├── screens/
    │   └── home_screen.dart        # Main screen with entries
    ├── services/
    │   ├── journal_service.dart    # Firebase operations
    │   ├── ai_service.dart         # Gemini AI integration
    │   └── firebase_service.dart   # Firebase setup
    ├── providers/
    │   ├── journal_provider.dart   # State management
    │   └── ai_provider.dart        # AI state management
    ├── theme/
    │   └── app_theme.dart          # Material You theming
    ├── utils/
    └── widgets/
        ├── custom_calendar.dart    # Calendar widget
        ├── journal_entry_card.dart # Entry display
        └── journal_entry_form.dart # Entry creation/editing
```

## Dependencies

### Firebase

- `firebase_core`: ^2.24.2
- `firebase_auth`: ^4.15.3
- `cloud_firestore`: ^4.13.6
- `firebase_storage`: ^11.5.6

### State Management

- `flutter_riverpod`: ^2.4.9
- `freezed_annotation`: ^2.4.1

### UI/UX

- `google_fonts`: ^6.1.0
- `dynamic_color`: ^1.6.8
- `image_picker`: ^1.0.4

### AI/ML

- `google_generative_ai`: ^0.2.0

View `pubspec.yaml` for complete list

## Features in Detail

### User Authentication

- Email/password authentication
- User profile management
- Secure session handling
- Protected routes

### Journal Entries

- Rich text content
- Image attachments
- AI-powered insights
- Tag management
- Mood tracking

### Image Management

- Image selection from gallery
- Automatic compression
- User-specific storage
- Preview functionality
- Secure access control

### State Management

- Riverpod providers
- Authentication state
- Journal entry state
- Loading states
- Error handling

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Security

- User authentication required for all operations
- Firestore security rules enforce user-specific access
- Storage rules protect user uploads
- Environment variables for sensitive keys
- Secure image handling

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for the robust backend
- Google for the Gemini AI API
- The open-source community for inspiration
