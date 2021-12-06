import 'package:fin_clever/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_type_item.dart';

class OperationCategorySelector extends StatefulWidget {
  const OperationCategorySelector({Key? key, required this.categories}) : super(key: key);

  final List<OperationCategory> categories;

  @override
  _OperationCategorySelectorState createState() => _OperationCategorySelectorState();
}

class _OperationCategorySelectorState extends State<OperationCategorySelector> {

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final operation = context.watch<Operation>();
    return SizedBox(
      height: 94,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          return Center(
            child: ExpenseTypeItem(
              category: widget.categories[index],
              isSelected: operation.selectedCategoryIndex == index ? true : false,
              onSelected: () {
                setState(() {
                  selected = !selected;
                });
                operation.selectCategory(index);
              },
            ),
          );
        },
      ),
    );
  }
}
