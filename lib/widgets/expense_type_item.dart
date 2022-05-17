import 'package:fin_clever/utils/constants.dart';
import 'package:fin_clever/data/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ExpenseTypeItem extends StatefulWidget {
  const ExpenseTypeItem(
      {Key? key,
      required this.category,
      required this.onSelected,
      required this.isSelected})
      : super(key: key);

  final OperationCategory category;
  final bool isSelected;
  final Function onSelected;

  @override
  State<StatefulWidget> createState() => _ExpenseTypeItemState();
}

class _ExpenseTypeItemState extends State<ExpenseTypeItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected();
      },
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: widget.isSelected ? FinColor.darkBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(29),
                  border: Border.all(
                    color: widget.isSelected
                        ? Colors.transparent
                        : FinColor.darkBlue.withAlpha(0x1A),
                    width: 1,
                  ),
                ),
                child: Icon(widget.category.icon,
                    color: widget.isSelected ? Colors.white : FinColor.darkBlue),
              )),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 72, height: 32),
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                widget.category.name,
                textAlign: TextAlign.center,
                style: FinFont.medium
                    .copyWith(fontSize: 11, color: FinColor.secondaryText),
              ),
            ),
          )
        ],
      ),
    );
  }
}
