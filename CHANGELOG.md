# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Firebase Authentication integration
- User-specific journal entries with `userId` and `username` fields
- Image upload functionality with Firebase Storage
- User profile management system
- Authentication state providers with Riverpod
- User-specific data access and security rules
- Image preview in journal entry form
- Username display in journal entry cards
- Mood display in journal entries
- User-specific action visibility (edit/delete)
- Enhanced error handling and loading states
- Comprehensive Firebase security rules
- User validation for all journal operations

### Changed

- Refactored JournalEntry model to include user information
- Updated JournalService with authentication checks
- Enhanced JournalProvider with user-specific operations
- Improved JournalEntryCard UI with user attribution
- Converted JournalEntryForm to ConsumerStatefulWidget
- Updated Firebase storage paths to be user-specific
- Enhanced error handling across all operations
- Improved state management with Riverpod
- Updated README with comprehensive setup instructions

### Security

- Added Firebase Authentication
- Implemented user-specific data access
- Added secure entry management
- Added user validation for all operations
- Configured Firebase security rules
- Protected user data and uploads

## [0.1.0] - 2024-01-XX

### Added

- Initial release
- Basic journal entry functionality
- Material You dynamic theming
- Calendar view
- Basic Firebase integration
- Simple journal entry form
- Entry list view
- Dark/Light theme support
