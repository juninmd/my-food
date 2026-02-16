# my_food

Meal Planning and Health Application.

This project offers a complete solution for patient diet and health management with a modern, clean UI.

## Main Features

*   **Patient Diet (MealPage)**:
    *   Daily planning (Breakfast, Lunch, Dinner).
    *   Visualization of meal options and details (ingredients, description).
    *   Daily hydration tracking (water glass counter).

*   **Nutrient Calculation**:
    *   Automatic calculation of total daily calories.
    *   Progress bars for macronutrients (Protein, Carbs, Fat).
    *   **BMI Calculator**: Dedicated tool for Body Mass Index (BMI) calculation with health categorization.

*   **Shopping List (ShoppingListPage)**:
    *   Automatic list generation based on daily meals.
    *   Grouping of identical ingredients.
    *   Functionality to check off purchased items.
    *   Copy list to clipboard.

*   **Surprise Me**:
    *   **Random Meals**: "Surprise Me" button on the main screen that generates a random meal plan for the day.
    *   **Motivational Quotes**: Display of inspiring quotes via API.
    *   **Surprise Recipe**: Extra functionality to fetch a random recipe from an external API (TheMealDB).

## Project Structure

*   `lib/pages`: Contains the main screens (MealPage, ShoppingListPage, BMICalculatorPage, RandomRecipePage).
*   `lib/models`: Data models (Meal).
*   `lib/data`: Static meal data.
*   `lib/services`: Logic for communication with external APIs.
*   `lib/utils`: Utilities (BMI Calculator).

## Running the Project

This project uses Flutter. To run:

```bash
flutter pub get
flutter run
```

## Tests

The project includes unit and widget tests to ensure the integrity of main features.

```bash
flutter test
```
