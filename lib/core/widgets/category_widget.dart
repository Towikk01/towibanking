import 'package:flutter/cupertino.dart';

class CategoryWidget extends StatelessWidget {
  final String category;
  final IconData icon;

  const CategoryWidget({super.key, required this.icon, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // Add padding to the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: CupertinoColors.systemGrey6, // Add a background color
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure the column takes minimal space
        children: [
          Icon(icon, size: 24), // Display icon with size
          const SizedBox(height: 4), // Space between icon and text
          Text(
            category,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
