import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      selectedItemColor: isDarkMode ? Colors.purpleAccent : Colors.deepPurple,
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 10,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: currentIndex == 0
                  ? (isDarkMode
                      ? Colors.deepPurple.shade900
                      : Colors.purpleAccent)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.home,
              size: 30,
              color: currentIndex == 0
                  ? Colors.white
                  : (isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: currentIndex == 1
                  ? (isDarkMode
                      ? Colors.deepPurple.shade900
                      : Colors.purpleAccent)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.calendar_today,
              size: 30,
              color: currentIndex == 1
                  ? Colors.white
                  : (isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: currentIndex == 2
                  ? (isDarkMode
                      ? Colors.deepPurple.shade900
                      : Colors.purpleAccent)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.add,
              size: 30,
              color: currentIndex == 2
                  ? Colors.white
                  : (isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
