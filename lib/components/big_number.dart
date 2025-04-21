import 'package:flutter/material.dart';
import 'package:myapp/style/text_styles.dart';

class BigNumber extends StatelessWidget {
  final double amount;
  final String unit;

  const BigNumber({super.key, required this.amount, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(amount.toStringAsFixed(1), style: AppTextStyles.bigText),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(unit, style: AppTextStyles.bigTextSecondary),
            const SizedBox(height: 7),
          ],
        ),
      ],
    );
  }
}
