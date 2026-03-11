import 'package:flutter/material.dart';

import 'add_pet_profile_screen.dart';

class BreedSelectionScreen extends StatefulWidget {
  const BreedSelectionScreen({super.key});

  @override
  State<BreedSelectionScreen> createState() => _BreedSelectionScreenState();
}

class _BreedSelectionScreenState extends State<BreedSelectionScreen> {

  int? selectedIndex;

  final List<Map<String, String>> breeds = [
    {"name": "Labrador", "image": "assets/labrador.png"},
    {"name": "Golden Retriever", "image": "assets/golden.png"},
    {"name": "Papillon", "image": "assets/papillon.png"},
    {"name": "German Shepherd", "image": "assets/german.png"},
    {"name": "English Springer\nSpaniel", "image": "assets/spaniel.png"},
    {"name": "Border Collie", "image": "assets/collie.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 10),

            // HEADER
            Row(
              children: [

                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const Spacer(),

                const Column(
                  children: [
                    Text(
                      "Add pet profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Breed",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const Spacer(),
                const SizedBox(width: 48),

              ],
            ),

            const SizedBox(height: 10),

            // GRID
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                itemCount: breeds.length,

                itemBuilder: (context, index) {

                  final breed = breeds[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEBDA),
                        borderRadius: BorderRadius.circular(20),

                        border: isSelected
                            ? Border.all(
                                color: Colors.blue,
                                width: 3,
                              )
                            : null,
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            breed["name"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Image.asset(
                            breed["image"]!,
                            height: 90,
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // START BUTTON (only appears if selected)
            if (selectedIndex != null)
              Padding(
                padding: const EdgeInsets.all(20),

                child: SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F757C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPetProfileScreen(
                            breedName: breeds[selectedIndex!]["name"]!,
                            breedImage: breeds[selectedIndex!]["image"]!,
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      "Start now",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}