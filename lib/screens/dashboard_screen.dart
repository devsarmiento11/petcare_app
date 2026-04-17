import 'package:flutter/material.dart';
import 'store_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String petName;
  final String breedName;
  final String imagePath;

  const DashboardScreen({
    super.key,
    required this.petName,
    required this.breedName,
    required this.imagePath,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StoreScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MessagesScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// HEADER
              Row(
                children: [

                  const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(width: 10),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello,", style: TextStyle(fontSize: 12)),
                      Text(
                        "Kent",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Icon(Icons.search),
                  const SizedBox(width: 15),
                  const Icon(Icons.menu),
                ],
              ),

              const SizedBox(height: 15),

              const Divider(),

              const SizedBox(height: 10),

              /// ACTIVE PET PROFILE TITLE
              Row(
                children: [

                  const Icon(Icons.pets),

                  const SizedBox(width: 5),

                  const Text(
                    "Active Pet Profile",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const Spacer(),

                  const Icon(Icons.add),
                ],
              ),

              const SizedBox(height: 10),

              /// PET PROFILE CARD
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    )
                  ],
                ),

                child: Row(
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.petName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text("Dog | ${widget.breedName}"),
                      ],
                    ),

                    const Spacer(),

                    CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          AssetImage(widget.imagePath),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// SERVICES
              Row(
                children: [

                  const Text(
                    "Services",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const Spacer(),

                  const Text("See All"),
                ],
              ),

              const SizedBox(height: 15),

              /// HEALTH SERVICE
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffDCE8E2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    // Logo positioned top-left
                    Positioned(
                      top: 12,
                      left: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/dog-pets-healthcare-care-medical-clinic-sick-treatment-colorful-modern-mascot-logo-icon-illustration-vector.jpg',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Text centered
                    const Center(
                      child: Text(
                        "Health",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// OTHER SERVICES
              Row(
                children: [

                  Expanded(
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xffE5E8F1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(child: Text("Grooming")),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xffEDE5DF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(child: Text("Tracking")),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// PET CARE NEARBY
              Row(
                children: [

                  const Text(
                    "Pet Care Nearby You",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const Spacer(),

                  const Text("See All"),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [

                    nearbyCard("Moon Pet Hospital"),
                    nearbyCard("Pawsome Clinic"),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),

      /// BOTTOM NAVBAR
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

  Widget nearbyCard(String name) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text("1.3 km • ⭐ 4.4"),

            const Spacer(),

            const Text(
              "View Location",
              style: TextStyle(color: Colors.blue),
            ),

          ],
        ),
      ),
    );
  }
}