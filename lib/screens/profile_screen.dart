import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'store_screen.dart';
import 'messages_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(
            petName: "My Pet",
            breedName: "Breed",
            imagePath: "assets/dogs.png",
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StoreScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MessagesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 15),

            /// PROFILE HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: [

                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(width: 12),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Hello,",
                        style: TextStyle(fontSize: 12),
                      ),

                      Text(
                        "Kent",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  const Spacer(),

                  const Icon(Icons.arrow_forward_ios, size: 16),

                ],
              ),
            ),

            const SizedBox(height: 15),

            const Divider(),

            /// MENU LIST
            Expanded(
              child: ListView(
                children: const [

                  ProfileItem(
                    icon: Icons.shopping_bag_outlined,
                    title: "Orders",
                  ),

                  ProfileItem(
                    icon: Icons.credit_card,
                    title: "My Details\nDelivery Address",
                  ),

                  ProfileItem(
                    icon: Icons.payment,
                    title: "Payment Methods",
                  ),

                  ProfileItem(
                    icon: Icons.local_offer_outlined,
                    title: "Promo Cord",
                  ),

                  ProfileItem(
                    icon: Icons.notifications_none,
                    title: "Notification",
                  ),

                  ProfileItem(
                    icon: Icons.help_outline,
                    title: "Help",
                  ),

                  ProfileItem(
                    icon: Icons.info_outline,
                    title: "About",
                  ),

                ],
              ),
            ),

            /// LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.all(16),

              child: Container(
                width: double.infinity,
                height: 55,

                decoration: BoxDecoration(
                  color: const Color(0xffE5E5E5),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.logout),

                    SizedBox(width: 10),

                    Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),

      /// BOTTOM NAVIGATION
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

/// PROFILE MENU ITEM
class ProfileItem extends StatelessWidget {

  final IconData icon;
  final String title;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),

        const Divider(height: 1),

      ],
    );
  }
}