import 'package:app/screens/home_content.dart';
import 'package:app/screens/spill_gates_content.dart';
import 'package:app/screens/info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isDarkMode = false;

  final List<Widget> _pages = [
    const HomeContent(),
    const SpillGatesContent(),
    const InfoContent(),
  ];

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  /// **Load Theme Preference from Local Storage**
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  /// **Toggle Theme & Save Preference**
  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
    });
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFE3F2FD), // Light/Dark Mode
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: floatingBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isDarkMode: isDarkMode,
      ),
    );
  }

  /// **Custom AppBar with User Profile & Menu**
  AppBar customAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'HydroSafe',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF1565C0), // Deep blue
      elevation: 5,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 1) {
              _toggleTheme();
            } else if (value == 2) {
              debugPrint("User Logged Out");
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Toggle Dark Mode'),
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// **Floating Bottom Navigation Bar with Shadow & Theme Support**
Widget floatingBottomNavBar({
  required int selectedIndex,
  required ValueChanged<int> onItemTapped,
  required bool isDarkMode,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_back_door),
            label: 'Spill Gates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF1565C0), // Deep Blue
        unselectedItemColor: Colors.grey,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        showUnselectedLabels: false,
        onTap: onItemTapped,
      ),
    ),
  );
}
