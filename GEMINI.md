# Gemini Memory

## Learning Log

### 2024-05-24 - Initial Audit
-   **Insight**: The project lacks persistent storage, meaning user data (water intake, meal selection) is lost on restart.
-   **Insight**: `ShoppingListPage` logic is embedded in the UI and lacks widget tests, though the aggregation logic has unit tests.
-   **Action**: Added roadmap items to `AGENTS.md` for persistence and localization.
-   **Action**: Created standard contribution documents.
-   **Action**: Planned to add widget tests for `ShoppingListPage`.

## Project Context
-   **Framework**: Flutter
-   **State Management**: `setState` (Local)
-   **Dependencies**: `http`, `carousel_slider`.
