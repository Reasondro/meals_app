import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.availableMeals});
 
  // final void Function(Meal meal) onToggleFavorite; //? removed because of riverpod
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availableMeals //? database for food for each categories , UPDATE, changed dummyMeals to availableMeals
        .where(
          (meal) => meal.categories.contains(category.id),
        )
        .toList();
    // Navigator.push(context,route); //? context avaible globally with StatefulWidget, in Stateless it ain't. p.s. Same as below
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          // onToggleFavorite: onToggleFavorite, //? removed because of riverpod
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold( //? removed due to scaffold in tabs
        //   appBar: AppBar(
        //     title: const Text("Pick your category"),
        //   ),
        //   body:
        // GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder),
        GridView(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        // availableCategories.map((category) => CategoryGridItem(category: category)) //? same as below
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          )
      ],
      // ), //? removed due to scaffold in tabs
    );
  }
}
