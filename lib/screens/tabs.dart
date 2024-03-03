import 'package:flutter/material.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/meal.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  final List<Meal> _favoriteMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final bool isExisting = _favoriteMeals.contains(meal);
    if (isExisting == false) {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage(("Marked as favorite!"));
    } else {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage("Meal is no longer a favorite");
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  var activePageTitle = "Categories";

  @override
  Widget build(BuildContext context) {
    Widget activePage =
        CategoriesScreen(onToggleFavorite: _toggleMealFavoriteStatus);

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
          meals: _favoriteMeals,
          onToggleFavorite:
              _toggleMealFavoriteStatus); //? No title here to avoid double scaffold in meals
      activePageTitle = "Your Favorites";
    }
    // else if (_selectedPageIndex == 2) { //? testing app bar index
    //   activePage = const Text("testing", style: TextStyle(color: Colors.white),);
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          // print(index); //? proof of index
          _selectPage(index);
        },
        items: const [
          //? index starts at 0, then increment by 1 by each item
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.accessible_forward_rounded), label: "Testing"), //? index 2 here
        ],
      ),
    );
  }
}
