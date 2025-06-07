# Dil Pratik Frontend

This is the frontend application for Dil Pratik, built with Flutter.

## Setup

1. Make sure you have Flutter installed and configured properly:
```bash
flutter doctor
```

2. Get dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory with:
```
API_URL=http://localhost:8000
```

4. Run the application:

For web:
```bash
flutter run -d chrome
```

For Windows:
```bash
flutter run -d windows
```

## Building for Production

For web:
```bash
flutter build web
```

For Windows:
```bash
flutter build windows
```

The built files will be available in the `build` directory.
