import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';

final mealsProvider = Provider((ref) {
  //? Basic Provider works great with static data

  return dummyMeals;
});

//TODO use NotifierProvider