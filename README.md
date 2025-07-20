# 🍳 Συνταγές Μαγειρικής (Recipe Collection App)

A comprehensive Flutter mobile application for storing and managing cooking recipes with local data persistence using Hive database.

## 📱 Features

### Core Functionality
- **Recipe Management**: Create, view, edit, and delete cooking recipes
- **Local Storage**: All recipes are stored locally using Hive database for offline access
- **Image Support**: Add photos to recipes by selecting from device gallery
- **Rating System**: Rate recipes from 0-5 stars with interactive star rating widget
- **Sorting Options**: Sort recipes by name, difficulty, rating, or preparation time
- **Swipe to Delete**: Remove recipes with intuitive swipe gesture
- **Dark/Light Theme**: Toggle between light and dark mode themes

### Recipe Properties
Each recipe contains:
- **Title**: Name of the recipe
- **Description**: Detailed cooking instructions
- **Preparation Time**: Time required in minutes
- **Difficulty**: Easy (Εύκολο), Medium (Μεσαίο), or Hard (Δύσκολο)
- **Image**: Photo of the dish
- **Rating**: User rating from 0-5 stars

## 🏗️ App Structure

### Screens
- **Home Screen**: Main view displaying all recipes in a ListView with sorting and theme toggle
- **Recipe Detail Screen**: Full recipe view with all details and rating functionality
- **Add Recipe Screen**: Form for creating new recipes with image picker integration

### Widgets
- **Recipe Card**: Compact recipe display for the home screen list
- **Star Rating**: Interactive 5-star rating component
- **Custom Theme**: Unified light/dark theme system

## 🛠️ Technical Implementation

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.1
  image_picker: ^1.0.4
  path: ^1.8.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

### Architecture
- **Model**: Recipe class with Hive annotations for local storage
- **Screens**: Separate screens for home, details, and recipe creation
- **Widgets**: Reusable components for recipe cards and star ratings
- **Theme**: Centralized theme management for consistent UI

### Data Persistence
- **Hive Database**: NoSQL database for fast local storage
- **Image Storage**: Images saved to application documents directory
- **Type Adapters**: Generated adapters for Recipe model serialization

## 📦 File Structure

```
lib/
├── main.dart                    # App entry point and theme configuration
├── models/
│   ├── recipe.dart             # Recipe model with Hive annotations
│   └── recipe.g.dart           # Generated Hive adapter
├── screens/
│   ├── home_screen.dart        # Main recipe list view
│   ├── recipe_detail_screen.dart # Individual recipe display
│   └── add_recipe_screen.dart  # Recipe creation form
├── widgets/
│   ├── recipe_card.dart        # Recipe card component
│   └── star_rating.dart        # Interactive star rating widget
└── theme/
    └── app_theme.dart          # Light and dark theme definitions
```

## 🎨 UI/UX Features

### Design Elements
- **Material Design**: Clean, modern interface following Material Design principles
- **Responsive Layout**: Adaptive UI that works across different screen sizes
- **Color Coding**: Visual difficulty indicators with color-coded badges
- **Smooth Animations**: Intuitive transitions and interactions
- **Image Fallbacks**: Graceful handling of missing or corrupted images

### User Experience
- **Intuitive Navigation**: Easy-to-use navigation between screens
- **Form Validation**: Input validation for recipe creation
- **Feedback Messages**: Success/error messages for user actions
- **Empty State**: Helpful message when no recipes are available
- **Confirmation Dialogs**: Safety prompts for destructive actions

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio/VS Code with Flutter extensions
- Android device or emulator for testing

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate Hive adapters:
   ```bash
   flutter packages pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Building APK
```bash
flutter build apk --release
```

## 📋 Assignment Requirements

This app was developed as a semester project for Mobile Device Programming course with the following specifications:

### Required Features ✅
- **Home Screen**: ListView with recipe cards showing title, image, and difficulty
- **Recipe Detail Screen**: Full recipe information display
- **Recipe Cards**: Compact recipe representation with star rating system
- **Add Recipe Screen**: Form with image picker integration
- **Local Storage**: Persistent data storage using Hive
- **Swipe to Delete**: Gesture-based recipe removal
- **Sorting**: Multiple sorting options (difficulty, rating, preparation time)

### Bonus Features ✅
- **Theming**: Complete dark/light mode implementation
- **Interactive Rating**: Tap-to-rate functionality on recipe cards
- **Enhanced UI**: Modern, polished user interface
- **Image Management**: Proper image storage and error handling

## 🎯 Academic Context

- **Course**: Προγραμματισμός Κινητών Συσκευών (Mobile Device Programming)
- **Deadline**: May 31, 2025
- **Team Size**: 2 members (required)
- **Grade Weight**: 50% of final grade
- **Deliverables**: 
  - Flutter project source code
  - APK executable file
  - Detailed implementation report with screenshots

## 📱 Supported Platforms

- **Primary**: Android (APK build included)
- **Secondary**: iOS (with minor modifications)
- **Development**: Tested on Android emulator and physical devices

## 📄 License

This project was developed for educational purposes as part of university coursework.
