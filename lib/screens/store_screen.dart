import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _selectedIndex = 0;

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

      appBar: AppBar(
        backgroundColor: const Color(0xff4E7A80),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Shop",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.black),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 15),

            /// SEARCH BAR
            TextField(
              decoration: InputDecoration(
                hintText: "Search product",
                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CATEGORY ICONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                categoryItem(Icons.pets, "Food", true),
                categoryItem(Icons.medical_services, "Vet Items", false),
                categoryItem(Icons.chair, "Accessories", false),
                categoryItem(Icons.sensors, "IOT Devices", false),

              ],
            ),

            const SizedBox(height: 25),

            /// RECOMMENDED HEADER
            Row(
              children: [

                const Text(
                  "Recommended Food",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff4E7A80),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Check Retail Stores",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),

            const SizedBox(height: 15),

            /// PRODUCT GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.75,

                children: const [

                  ProductCard(
                    brand: "Furry",
                    name: "Josera Mini Deluxe",
                    price: "₱1000.00",
                    weight: "900g",
                    image: "assets/josera.png",
                  ),

                  ProductCard(
                    brand: "Bella",
                    name: "Pedigree Chicken & Vege",
                    price: "₱1590.00",
                    weight: "3kg",
                    image: "assets/pedigree.png",
                  ),

                  ProductCard(
                    brand: "Roudy",
                    name: "BlackHawk Puppy Lamb &",
                    price: "₱2550.00",
                    weight: "20kg",
                    image: "assets/blackhawk.png",
                  ),

                  ProductCard(
                    brand: "Furry",
                    name: "Royal Canin Labrador P",
                    price: "₱1140.00",
                    weight: "3kg",
                    image: "assets/royalcanin.png",
                  ),

                ],
              ),
            ),

          ],
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

  /// CATEGORY ICON
  static Widget categoryItem(IconData icon, String label, bool selected) {
    return Column(
      children: [

        Container(
          height: 55,
          width: 55,

          decoration: BoxDecoration(
            color: selected ? const Color(0xff4E7A80) : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Icon(
            icon,
            color: selected ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(height: 5),

        Text(label, style: const TextStyle(fontSize: 11)),

      ],
    );
  }
}

/// PRODUCT CARD
class ProductCard extends StatelessWidget {

  final String brand;
  final String name;
  final String price;
  final String weight;
  final String image;

  const ProductCard({
    super.key,
    required this.brand,
    required this.name,
    required this.price,
    required this.weight,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: const Color(0xff4E7A80),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                brand,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Image.asset(
                image,
                height: 90,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(price),

            Text(weight, style: const TextStyle(fontSize: 12)),

          ],
        ),
      ),
    );
  }
}