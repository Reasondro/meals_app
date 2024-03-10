import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const Map<Filter, bool> kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  final List<Meal> _favoriteMeals = []; //? favorite meals database
  Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false
  };

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

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == "filters") {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        //? alternative to push, pushReplacement  will not stack screens but replace
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ??
            kInitialFilters; //? the keyword "??" ensures a default value for a variable that could be null , here being the result variable that is nullable
      });
      // print(result); //? this shit is magic wtf
    }
    // else if (identifier == "meals") { //? doesn't needed it anymore because always popping bitch
    // Navigator.of(context).pop();
    // }
  }

  String? activePageTitle;

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
          meals: _favoriteMeals,
          onToggleFavorite:
              _toggleMealFavoriteStatus); //? No title here to avoid double scaffold in meals
      activePageTitle = "Your Favorites";
    } else if (_selectedPageIndex == 0) {
      activePage = CategoriesScreen(
        onToggleFavorite: _toggleMealFavoriteStatus,
        availableMeals: availableMeals,
      );
      activePageTitle = "Categories";
    }
    // else if (_selectedPageIndex == 2) { //? testing app bar index
    //   activePage = const Text("testing", style: TextStyle(color: Colors.white),);
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle!),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
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
