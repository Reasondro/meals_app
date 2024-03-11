import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:meals_app/data/dummy_data.dart'; //? replaced by provider method
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
// import 'package:meals_app/models/meal.dart'; //? not needed because of favorites_provider
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart'; //? added because of filters_provider that removed the filters from filters.dart

const Map<Filter, bool> kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: true
};

class TabsScreen extends ConsumerStatefulWidget {
  //? previously StatefulWidget , but replaced with ConsumerStatefulWidget (riverpod method)
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    //? replaced State with ConsumerState (riverpod method)

    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  //? replaced State with ConsumerState (riverpod method)
  int _selectedPageIndex = 0;

  // final List<Meal> _favoriteMeals = []; //? favorite meals database, UPDATE: REPLACED by favoriteMeals (riverpod method)
  // Map<Filter, bool> _selectedFilters = { //? not needed anymore, riverpod method
  //   Filter.glutenFree: false,
  //   Filter.lactoseFree: false,
  //   Filter.vegetarian: false,
  //   Filter.vegan: false
  // };

  // void _showInfoMessage(String message) { //? moved to meals_detail_screen
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 4),
  //       content: Text(message),
  //     ),
  //   );
  // }

  // void _toggleMealFavoriteStatus(Meal meal) { //? REPLACE BY toggleMealFavoriteStatus (riverpod method)
  //   final bool isExisting = _favoriteMeals.contains(meal);
  //   if (isExisting == false) {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //     });
  //     _showInfoMessage(("Marked as favorite!"));
  //   } else {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage("Meal is no longer a favorite");
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == "filters") {
      await Navigator.of(context).push<Map<Filter, bool>>(
        //* the push type parameter is not required, but it is a good practice to specify which data type we are returning. and what data we are pushing to the popped screen (filters) , but it's actually the reverse that is going on
        //* alternative to push, pushReplacement  will not stack screens but replace
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(
              // currentFilters: _selectedFilters, //? removed because riverpod method
              ),
        ),
      );
      // setState(() { //? removed because riverpod method
      //   _selectedFilters = result ??
      //       kInitialFilters; //* the keyword "??" ensures a default value for a variable that could be null , here being the result variable that is nullable
      // });
      // print(result); //? this shit is magic wtf
    }
    // else if (identifier == "meals") { //? doesn't needed it anymore because always popping bitch
    // Navigator.of(context).pop();
    // }
  }

  String? activePageTitle;

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(
        mealsProvider); //* recommended .watch (for data/variables) , the other one read is a 1 time thingy, watch always listen
    final activeFilters = ref.watch(filtersProvider);
    final availableMeals = meals.where((meal) {
      //? changed dummyMeals with meals (riverpod method)
      if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus, //? removed because of riverpod
      availableMeals: availableMeals,
    );

    if (_selectedPageIndex == 1) {
      //? riverpod automatically extracts the "state" property value from notifier class. hence ref.watch() yields -> List<Meal> *1
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        // onToggleFavorite:  _toggleMealFavoriteStatus, //? removed because of riverpod
        meals: favoriteMeals,
      ); //? No title here to avoid double scaffold in meals
      activePageTitle = "Your Favorites";
    } else if (_selectedPageIndex == 0) {
      activePage = CategoriesScreen(
        // onToggleFavorite: _toggleMealFavoriteStatus, //? removed because of riverpod
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
