import 'package:flutter/material.dart';
import 'grooming_screen.dart';
import 'health_screen.dart';
import 'tracking_screen.dart';


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

body: SafeArea(
        child: SingleChildScrollView(
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffDCE8E2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      // Logo centered top
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/healthpetcare.png',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Text centered below
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Center(
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

                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// OTHER SERVICES
              Row(
                children: [

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GroomingScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xffE5E8F1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            // Logo centered top
                            Positioned(
                              top: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/grooming.png',
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // Text centered below
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  "Grooming",
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

                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TrackingScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xffEDE5DF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            // Logo centered top
                            Positioned(
                              top: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/tracking.png',
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // Text centered below
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  "Tracking",
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
                            ),
                          ],
                        ),
                      ),
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
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [

                    nearbyCard("Moon Pet Hospital", "assets/images/hostpital.jpg"),
                    nearbyCard("Pawsome Clinic", "assets/images/paws.jpg"),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget nearbyCard(String name, [String? imagePath]) {
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (imagePath != null && imagePath.isNotEmpty)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      height: 55,
                      width: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),

            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

            const SizedBox(height: 4),

            const Row(
              children: [
                Text("1.3 km"),
                SizedBox(width: 6),
                Icon(Icons.star, size: 16, color: Colors.amber),
                SizedBox(width: 2),
                Text("4.4", style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              "View Location",
              style: const TextStyle(color: Colors.blue),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

          ],
        ),
      ),
    );
  }
}