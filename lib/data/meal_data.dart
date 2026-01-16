import '../models/meal.dart';

class MealData {
  static const List<Meal> breakfastOptions = [
    Meal(
      name: 'Pão com Ovo',
      imagePath: 'assets/images/lanche.jpg',
      calories: 300,
      protein: 15,
      carbs: 30,
      fat: 12,
      description: 'Pão integral com ovos mexidos.',
      ingredients: ['Pão integral', 'Ovos', 'Manteiga', 'Sal'],
    ),
    Meal(
      name: 'Mingau de Aveia',
      imagePath: 'assets/images/lanche.jpg',
      calories: 250,
      protein: 8,
      carbs: 45,
      fat: 5,
      description: 'Aveia cozida com leite e canela.',
      ingredients: ['Aveia', 'Leite', 'Canela', 'Açúcar'],
    ),
    Meal(
      name: 'Frutas com Iogurte',
      imagePath: 'assets/images/lanche.jpg',
      calories: 200,
      protein: 6,
      carbs: 40,
      fat: 2,
      description: 'Salada de frutas com iogurte natural.',
      ingredients: ['Banana', 'Maçã', 'Iogurte Natural', 'Mel'],
    ),
  ];

  static const List<Meal> lunchOptions = [
    Meal(
      name: 'Frango com Batata Doce',
      imagePath: 'assets/images/lanche.jpg',
      calories: 500,
      protein: 40,
      carbs: 60,
      fat: 10,
      description: 'Peito de frango grelhado com purê de batata doce.',
      ingredients: ['Peito de frango', 'Batata doce', 'Azeite', 'Sal'],
    ),
    Meal(
      name: 'Salada Ceasar',
      imagePath: 'assets/images/lanche.jpg',
      calories: 400,
      protein: 25,
      carbs: 15,
      fat: 25,
      description: 'Alface, croutons e molho especial.',
      ingredients: ['Alface', 'Croutons', 'Queijo parmesão', 'Molho Caesar', 'Frango'],
    ),
    Meal(
      name: 'Peixe Grelhado',
      imagePath: 'assets/images/lanche.jpg',
      calories: 450,
      protein: 35,
      carbs: 20,
      fat: 20,
      description: 'Filé de tilápia com legumes.',
      ingredients: ['Tilápia', 'Brócolis', 'Cenoura', 'Azeite'],
    ),
  ];

  static const List<Meal> dinnerOptions = [
    Meal(
      name: 'Sopa de Legumes',
      imagePath: 'assets/images/lanche.jpg',
      calories: 250,
      protein: 5,
      carbs: 40,
      fat: 8,
      description: 'Sopa leve com variedade de legumes.',
      ingredients: ['Batata', 'Cenoura', 'Abobrinha', 'Cebola', 'Alho'],
    ),
    Meal(
      name: 'Omelete de Queijo',
      imagePath: 'assets/images/lanche.jpg',
      calories: 350,
      protein: 20,
      carbs: 5,
      fat: 28,
      description: 'Omelete recheado com queijo minas.',
      ingredients: ['Ovos', 'Queijo minas', 'Orégano', 'Sal'],
    ),
    Meal(
      name: 'Sanduíche Natural',
      imagePath: 'assets/images/lanche.jpg',
      calories: 300,
      protein: 15,
      carbs: 35,
      fat: 10,
      description: 'Pão de forma com patê de atum.',
      ingredients: ['Pão de forma', 'Atum', 'Maionese', 'Alface'],
    ),
  ];
}
