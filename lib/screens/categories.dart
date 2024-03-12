import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  // final void Function(Meal meal) onToggleFavorite; //? removed because of riverpod
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}
//* Animation works only with StatefulWidget. Easy conversion Stateless <-> Stateful using refactor

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  //* use SingleTickerProviderStateMixin for 1 AnimationController, otherwise it's TickerProviderStateMixin
  late AnimationController
      _animationController; //* must use late keyword then followed by the AnimationController type for animation

  @override //* also must use initState
  void initState() {
    //* initState only executed when the widget is created
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0, //* default value is 0
      upperBound: 1, //* default value is 0
    );
    _animationController
        .forward(); //* this will start the animation, (repeat or stop is another)
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget
        .availableMeals //? database for food for each categories , UPDATE, changed dummyMeals to availableMeals
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
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
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
      ),
      // builder: (context, child) => Padding(
      //     //* wrap the Grid with padding here so only the padding gets rebuilt not the Grid (performance optimizer)
      //     padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
      //     child: child),
      builder: (context, child) => SlideTransition(
        position:
            //  _animationController.drive( //* no need , .animate also return animation
            Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        ),
        // ),
        child: child,
      ),
    );
  }
}
