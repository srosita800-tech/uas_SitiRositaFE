import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    super.key,
    this.text = 'ATAU',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.divider)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.divider)),
        ],
      ),
    );
  }
}