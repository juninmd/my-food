import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../data/diet_data.dart';
import '../models/food_item.dart';
import '../models/meal.dart';

class MealPage extends StatefulWidget {
  final DietData dietData;
  const MealPage({Key? key, required this.dietData}) : super(key: key);

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: widget.dietData,
      builder: (context, child) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  toolbarHeight: size.height * 0.1,
                  collapsedHeight: size.height * 0.1,
                  expandedHeight: size.height * 0.2,
                  title: const Text(
                    "Alimentação",
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                  actions: [
                     IconButton(
                      icon: const Icon(Icons.shuffle),
                      tooltip: 'Me Surpreenda',
                      onPressed: () {
                         widget.dietData.surpriseMe();
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Refeições geradas aleatoriamente!')),
                         );
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      stretchModes: <StretchMode>[
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      background: Stack(fit: StackFit.expand, children: <Widget>[
                        Image.asset(
                          "assets/images/bg3.jpg",
                          fit: BoxFit.cover,
                          color: const Color(0xaa212121),
                          colorBlendMode: BlendMode.darken,
                        ),
                      ])),
                ),
              ];
            },
            body: Container(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildNutrientSummary(context),
                  ...widget.dietData.meals.map((meal) => _buildMealSection(context, meal)).toList(),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Adicione aqui a lógica para enviar a foto da refeição atual
            },
            child: Icon(Icons.camera_alt),
          ),
        );
      },
    );
  }

  Widget _buildNutrientSummary(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             Text(
              "Resumo Diário",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientItem("Calorias", "${widget.dietData.totalCalories}"),
                _buildNutrientItem("Prot", "${widget.dietData.totalProtein}g"),
                _buildNutrientItem("Carb", "${widget.dietData.totalCarbs}g"),
                _buildNutrientItem("Gord", "${widget.dietData.totalFat}g"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMealSection(BuildContext context, Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card( // Added Card for better separation
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ClipRRect( // Added ClipRRect for rounded images
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      meal.selectedFood.imageAsset,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.selectedFood.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${meal.selectedFood.calories} calorias",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Adicione aqui a lógica para curtir a refeição
                    },
                    icon: const Icon(Icons.favorite_border),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showSwapModal(context, meal);
                },
                child: const Text('Trocar Alimento'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSwapModal(BuildContext context, Meal meal) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        FoodItem currentSelection = meal.selectedFood;
        int initialIndex = widget.dietData.availableFoods.indexOf(meal.selectedFood);
        if (initialIndex == -1) initialIndex = 0;

        return Container(
          height: 400,
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Selecione um alimento:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    initialPage: initialIndex,
                    onPageChanged: (index, reason) {
                        currentSelection = widget.dietData.availableFoods[index];
                    }
                  ),
                  items: widget.dietData.availableFoods.map((food) {
                    return Builder(
                      builder: (BuildContext context) {
                        return _buildCarouselItem(food);
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    widget.dietData.swapFood(meal, currentSelection);
                    Navigator.pop(context);
                  },
                  child: const Text('Confirmar Troca'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildCarouselItem(FoodItem food) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
             borderRadius: BorderRadius.circular(10),
             child: Image.asset(
              food.imageAsset,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          food.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          "${food.calories} kcal | P: ${food.protein}g | C: ${food.carbs}g | G: ${food.fat}g",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
