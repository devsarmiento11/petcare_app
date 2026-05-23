import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'store_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  final String petName;
  final String breedName;
  final String imagePath;
  final String petId;

  const MainShell({
    super.key,
    required this.petName,
    required this.breedName,
    required this.imagePath,
    required this.petId,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Keep screens alive in memory - no recreation!
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens once with real pet data - they stay in memory!
    _screens = [
      DashboardScreen(
        petName: widget.petName,
        breedName: widget.breedName,
        imagePath: widget.imagePath,
      ),
      const StoreScreen(),
      MessagesScreen(petId: widget.petId, petName: widget.petName),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    // Smooth, instant switching - no Navigator.push needed!
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff4E7A80),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Store",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
