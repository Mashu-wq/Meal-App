import 'package:meal/models/catagory.dart';
import 'package:flutter/material.dart';
import 'package:meal/data/dummy_data.dart';
import 'package:meal/models/meal.dart';
import 'package:meal/screens/meals.dart';
import 'package:meal/widgets/category_grid_item.dart';

class CatagoriesScreen
 extends StatelessWidget {
  const CatagoriesScreen
  ({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  void _selectedCategory(BuildContext context, Category category){

    final filterdMeals = dummyMeals.where((meal) => meal.categories.contains(category.id)).toList();
    //adding cross-screen navigation
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => MealsScreen(title:category.title, meals:filterdMeals))
    );
  }

  @override
  Widget build(BuildContext context) {
    return  GridView(
        padding:const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
      childAspectRatio: 3/2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20),
      children: [
        // ignore: non_constant_identifier_names
        //availableCategories.map((category) => CategoryGridItem(category: category))
        for (final Category in availableCategories)
        CategoryGridItem(category: Category, onSelectedCategory: (){
          _selectedCategory(context, Category);
        },)
        
      ],);
      
    
  }
}