# Health App

A simple Flutter exercise application that allows users to browse workouts, view details, and track their progress with timers.

## Features

* View list of available exercises fetched from REST API
* Detailed view of each exercise showing name, description, duration, and difficulty
* Exercise timer with countdown functionality
* Mark exercises as completed
* Track continuous days of exercise completion (optional feature)
* Clean, responsive UI with proper error handling

## Architecture

The app follows a feature based clean architecture approach with BLoC pattern for state management:

```
lib/
├── core/ # Shared resources (e.g., errors, networking, constants)
│ ├── app/
│ │ └── constants.dart
│ ├── error/
│ │ └── failures.dart
│ └── network/
│ └── network_client.dart
├── features/
│ └── exercise/ # Exercise feature only
│ ├── data/ # Data layer (API, models, impl)
│ │ ├── datasources/
│ │ │ └── exercise_remote_data_source.dart
│ │ ├── models/
│ │ │ └── exercise_model.dart
│ │ └── repositories/
│ │ └── exercise_repository_impl.dart
│ ├── domain/ # Business logic layer
│ │ ├── entities/
│ │ │ └── exercise.dart
│ │ └── repositories/
│ │ └── exercise_repository.dart
│ └── presentation/ # UI + BLoC state management
│ ├── bloc/
│ │ ├── exercise_bloc.dart
│ │ ├── exercise_event.dart
│ │ └── exercise_state.dart
│ ├── pages/
│ │ ├── home_page.dart
│ │ └── exercise_detail_page.dart
│ └── widgets/
│ ├── exercise_card.dart
│ └── timer_widget.dart
├── main.dart # App entry point
└── utils/
└── shared_prefs_manager.dart
```

## Technologies

* Flutter
* Dart
* BLoC Pattern (flutter_bloc)
* HTTP for API calls
* Shared Preferences for local storage

## Setup Instructions

1. Clone the repository:

```
git clone https://github.com/escannorrr/health_app
```

2. Navigate to the project directory:

```
cd health_app
```

3. Install dependencies:

```
flutter pub get
```

4. Run the app:

```
flutter run
```

## API Details

The app communicates with the following API endpoint to fetch workout data:

```
GET https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts
```

## State Management

The app uses BLoC (Business Logic Component) pattern for state management. This separates the presentation layer from the business logic, making the code more maintainable and testable.

## Local Storage

Shared Preferences is used to store:
* Completed workouts
* Daily progress tracking information
* Last workout date for tracking continuous days

## Screenshots
<p float="left">
  <img src="https://github.com/user-attachments/assets/6e1cc3d1-8f0b-40e1-bd37-7a3023689e48" width="250"/>
  <img src="https://github.com/user-attachments/assets/8996c1d0-9391-4914-9a6c-9fdb52c77077" width="250"/>
  <img src="https://github.com/user-attachments/assets/92d8d8ba-15e2-4a4d-be40-4b591e0c55cc" width="250"/>
  <img src="https://github.com/user-attachments/assets/77117ce3-ca51-4b38-b653-48d57c40a992" width="250"/>
</p>

## Future Improvements

* Add user authentication
* Add custom workout creation
* Add workout categories
* Enhance UI with animations
* Include workout history statistics
