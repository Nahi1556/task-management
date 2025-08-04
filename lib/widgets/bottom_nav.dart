import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => onTabSelected(0),
              color: currentIndex == 0 ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => onTabSelected(1),
              color: currentIndex == 1 ? Colors.blue : Colors.black,
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () => onTabSelected(2),
              color: currentIndex == 2 ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => onTabSelected(3),
              color: currentIndex == 3 ? Colors.blue : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
