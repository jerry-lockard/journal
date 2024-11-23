# Journal - A Modern Flutter Journaling App

A beautiful and intelligent journaling application built with Flutter, featuring Material You dynamic theming, Firebase Realtime Database, and Gemini AI-powered insights.

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
  - Realtime Database for instant updates
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
FIREBASE_DATABASE_URL=your_database_url

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
   {
     "rules": {
       "users": {
         "$uid": {
           ".read": "$uid === auth.uid",
           ".write": "$uid === auth.uid",
           "entries": {
             "$entryId": {
               ".validate": "newData.hasChildren(['userId', 'content', 'createdAt']) && newData.child('userId').val() === auth.uid"
             }
           },
           "settings": {
             ".validate": "newData.parent().parent().parent().child('users').child(auth.uid).exists()"
           }
         }
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
       match /journal_images/{userId}/{filename} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
       match /profile_images/{userId}/{filename} {
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
├── src/
    ├── features/           # Feature-based modules
    │   ├── ai/            # AI-related features
    │   │   ├── ai.dart    # Barrel file for AI exports
    │   │   ├── providers/
    │   │   │   └── ai_provider.dart
    │   │   └── services/
    │   │       └── ai_service.dart
    │   ├── auth/          # Authentication feature
    │   │   ├── auth.dart  # Barrel file for auth exports
    │   │   ├── screens/
    │   │   │   ├── login_screen.dart
    │   │   │   └── signup_screen.dart
    │   │   ├── providers/
    │   │   │   └── auth_provider.dart
    │   │   └── services/
    │   │       └── auth_service.dart
    │   └── journal/       # Journal feature
    │       ├── journal.dart # Barrel file for journal exports
    │       ├── models/
    │       │   └── journal_entry.dart
    │       ├── providers/
    │       │   └── journal_provider.dart
    │       ├── services/
    │       │   └── journal_service.dart
    │       └── widgets/
    │           ├── journal_entry_card.dart
    │           └── journal_entry_form.dart
    └── shared/           # Shared utilities and components
        ├── shared.dart   # Barrel file for shared exports
        ├── theme/
        │   └── app_theme.dart
        └── utils/        # Shared utilities
```

### Architecture Overview

The project follows a feature-first architecture with clean separation of concerns:

1. **Features Directory**: Contains feature-specific modules
   - Each feature is self-contained with its own models, services, and UI
   - Features communicate through well-defined interfaces
   - Includes feature-specific barrel files for clean exports

2. **Shared Directory**: Houses shared components and utilities
   - Common widgets and utilities used across features
   - Theme configuration
   - Shared models and interfaces

3. **Feature Structure**:
   - `models/`: Feature-specific data models
   - `providers/`: State management using Riverpod
   - `services/`: Business logic and external service integration
   - `screens/`: Feature-specific screens
   - `widgets/`: Reusable UI components

4. **Key Features**:
   - **AI**: Gemini AI integration for journal insights
   - **Auth**: Firebase Authentication and user management
   - **Journal**: Core journaling functionality

5. **State Management**:
   - Uses Riverpod for scalable state management
   - Feature-specific providers
   - Clean separation of concerns

6. **Dependencies**:
   - Organized by feature
   - Clear separation between UI and business logic
   - Minimal cross-feature dependencies

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

- `dynamic_color`: ^1.6.6
- `google_fonts`: ^6.1.0
- `dynamic_color`: ^1.6.8
- `image_picker`: ^1.0.4

### AI/ML

- `google_generative_ai`: ^0.2.0

View `pubspec.yaml` for complete list

## Features in Detail

### Journal Entries

- Rich text content
- Image attachments
- AI-powered insights
- Tag management
- Mood tracking

### Image Management

- User-specific storage paths
- Automatic compression
- Preview functionality
- Secure access control
- Error handling

### State Management

- Riverpod providers
- Authentication state
- Journal entry state
- Loading states
- Error handling
- Type safety

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Security

- User authentication required for all operations
- Realtime Database security rules enforce user-specific access
- Storage rules protect user uploads
- Environment variables for sensitive keys
- Secure image handling

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for an amazing framework
- Firebase team for robust backend services
- Google for Gemini AI
- The open-source community
