import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:misty_test/domain/models/symbol/symbol.dart';

class AppDropDownItem extends StatelessWidget {
  const AppDropDownItem({
    super.key,
    required this.currentSymbol,
    required this.value,
    required this.title,
    required this.onTap,
  });

  final Symbol? currentSymbol;
  final Symbol value;
  final String title;
  final Function(Symbol? value) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<Symbol>(
          value: value,
          groupValue: currentSymbol,
          onChanged: onTap,
        ),
        const Gap(14),
        Text(
          title,
        ),
      ],
    );
  }
}
