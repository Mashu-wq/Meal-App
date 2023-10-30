import 'package:flutter/material.dart';
import 'package:meal/provider/favorites_meal_provider.dart';
import 'package:meal/provider/filter_provider.dart';
import 'package:meal/screens/categories.dart';
import 'package:meal/screens/filters.dart';
import 'package:meal/screens/meals.dart';
import 'package:meal/widgets/main_drawer.dart';
import 'package:meal/provider/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
    Filter.lacrtoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,

};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {

  int _selectedPageIndex = 0;
  

  //Map<Filter, bool> _selectedFilters = kInitialFilters;
    


  

  void _selectedPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters'){
     final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (ctx) => const FiltersScreen(),
        ),
      );
      /*setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });*/
      

    }
  
  }
  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filterProvider);

    final availableMeals = meals.where((meal){
      if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if (activeFilters[Filter.lacrtoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian){
        return false;
      }
      if (activeFilters[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CatagoriesScreen(
      
      availableMeals: availableMeals,
      );
    var activepageTitle = 'Categories'; 
    if(_selectedPageIndex == 1){
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(meals: favoriteMeals);
      activepageTitle = 'Your favorites';
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(activepageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedPageIndex,
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],

      ),
    );
  }
}