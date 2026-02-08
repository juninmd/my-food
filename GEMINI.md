# Gemini Memory

## Learning Log

### 2024-05-24 - Initial Audit
-   **Insight**: The project lacks persistent storage, meaning user data (water intake, meal selection) is lost on restart.
-   **Insight**: `ShoppingListPage` logic is embedded in the UI and lacks widget tests, though the aggregation logic has unit tests.
-   **Action**: Added roadmap items to `AGENTS.md` for persistence and localization.
-   **Action**: Created standard contribution documents.
-   **Action**: Planned to add widget tests for `ShoppingListPage`.

### 2024-05-24 - Antigravity Audit (Jules)
-   **Insight**: `BMICalculatorPage` failed to dispose `TextEditingController`s, leading to memory leaks.
-   **Insight**: `MealPage` (and `ApiService`) failed to close the `http.Client`. Implemented a conditional dispose pattern to support dependency injection in tests.
-   **Insight**: Inconsistent documentation languages (README in PT, CONTRIBUTING in EN).
-   **Action**: Fixed resource leaks in `BMICalculatorPage` and `MealPage`.
-   **Action**: Added `dispose()` to `ApiService`.
-   **Action**: Added test for `ApiService` lifecycle.

### Latest Update (Jules)
-   **Action**: Configured Semantic Release with `release.config.js`.
-   **Action**: Updated CI/CD pipeline `.github/workflows/flutter_release.yml` to use `semantic-release` on `main` branch.
-   **Action**: Configured automatic version injection into `pubspec.yaml` using `@semantic-release/exec`.

## Project Context
-   **Framework**: Flutter
-   **State Management**: `setState` (Local)
-   **Dependencies**: `http`, `carousel_slider`.
