import 'package:fin_clever/models/app_user.dart';
import 'package:fin_clever/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider/current_user.dart';
import 'expense_type_item.dart';

class JunkCategorySelector extends StatefulWidget {
  const JunkCategorySelector({Key? key, required this.categories})
      : super(key: key);

  final List<OperationCategory> categories;

  @override
  _JunkCategorySelectorState createState() => _JunkCategorySelectorState();
}

class _JunkCategorySelectorState extends State<JunkCategorySelector> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<CurrentUser>();
    return SizedBox(
      height: 94,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          return Center(
            child: ExpenseTypeItem(
              category: widget.categories[index],
              isSelected: user.user?.junkCategories
                      ?.split(',')
                      .contains(widget.categories[index].key) ==
                  true,
              onSelected: () {
                var newCats = [];
                newCats.addAll(user.user?.junkCategories?.split(',') ?? []);
                if (newCats.contains(widget.categories[index].key)) {
                  newCats.remove(widget.categories[index].key);
                } else {
                  newCats.add(widget.categories[index].key);
                }
                user.updateUser(user.user?.copyWith(junkCategories: newCats.toSet().toList().join(',')), sendToServer: true);
              },
            ),
          );
        },
      ),
    );
  }
}
