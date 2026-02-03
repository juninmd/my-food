# Agents

This file serves as a guide for AI agents working on this repository.

## Context

`my_food` is a Flutter application for meal planning and health tracking. It features meal randomization ("Surprise Me"), BMI calculation, and shopping list generation.

## Development Guidelines

-   **Language**: Dart (Flutter).
-   **Style**: Follow standard Flutter lints.
-   **Testing**: Maintain high test coverage. Use `flutter test` to run tests.
-   **Architecture**: Logic is separated into `services`, `models`, `data`, and `pages`.

## Future Roadmap

1.  **Persistent Storage**: Implement `shared_preferences` or `hive` to save daily water intake, current meal plan, and checked shopping list items across app restarts.
2.  **Semantic Release**: enhance the CI/CD pipeline to fully automate versioning and changelog generation using Conventional Commits.
3.  **Localization (l10n)**: Refactor the app to use Flutter's `gen_l10n` to support multiple languages (English and Portuguese), removing hardcoded strings.
