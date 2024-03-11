import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  //! Not allowed to edit to edit an existing value in memory, must create a new one
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final bool mealsIsFavorite = state.contains(meal);
//? state here has the same type that we declare besides the StateNotifer ( that is a List of Meal)
    if (mealsIsFavorite) {
      state = state
          .where((m) => m.id != meal.id)
          .toList(); //? removing an existing meal in the favorite list
      return false;
    } else {
      state = [
        ...state,
        meal
      ]; //? use of spread operator "..." => to extract an item of a list/set (iterable) into another collection or as arguments to a function.
      return true;
    }
  }
}

final favoriteMealsProvider = StateNotifierProvider<
    FavoriteMealsNotifier,
    List<
        Meal>>((ref) =>
    FavoriteMealsNotifier()); //? StateNotifierProvider works great for data that can change
  //? *1 List<Meal> affects the data type the ref.watch yields

// final favoriteMealsProvider = StateNotifierProvider((ref) {
//   return FavoriteMealsNotifier();
// }); //? StateNotifierProvider works great for data that can change
