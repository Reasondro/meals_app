// meal title at the app bar, below it the meal image

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:meals_app/providers/favorites_provider.dart';

class MealDetailScreen extends ConsumerWidget {
  //? replaced StatelessWidget with ConsumerWidget (riverpod method)
  const MealDetailScreen({super.key, required this.meal});

  final Meal meal;
  // final void Function(Meal meal) onToggleFavorite; //? removed because of riverpod

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* ref added manualy because ConsumerWidget/Stateless doesn't have a globally avaible ref keyword (same like context)
    //? must add WidgetRef for ConsumerWidget build method
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    final isFavorite = favoriteMeals.contains(meal);
    void showInfoMessage(String message) {
      //? moved from tabs.dart. REMEMBER CONTEXT only avaible in built method for stateless widget
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: Text(message),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final bool wasAdded = ref
                  .read(favoriteMealsProvider
                      .notifier) //? in a function that is passed as a value to like onPressed, or simmiliar, USE READ not watch
                  .toggleMealFavoriteStatus(meal);
              if (wasAdded) {
                showInfoMessage("Meal added as a favorite.");
              } else {
                showInfoMessage("Meal removed.");
              }
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (childTB, animationTB) {
                return RotationTransition(
                  turns:
                      Tween<double>(begin: 0.5, end: 1.0).animate(animationTB),
                  child: childTB,
                );
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(
                    isFavorite), //* key here to notify flutter that something changes between Icon swap
              ), //* childTB will be the child that is Icon
            ),
          )
        ],
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          //* Column with SingleChildScroolview
          //* or ListView but reminder ListView isn't centered by default, designed to take all
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: meal
                  .id, //* again must be unique AND SAME as the destination or source (depends how you look it)
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final step in meal.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  textAlign: TextAlign.center,
                  step,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
