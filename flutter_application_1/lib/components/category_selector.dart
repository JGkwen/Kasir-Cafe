import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final void Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
