import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/pet_service.dart';
import '../models/pet.dart';
import 'dashboard_screen.dart';

class AddPetProfileScreen extends StatefulWidget {
  final String breedName;
  final String breedImage;

  const AddPetProfileScreen({
    super.key,
    required this.breedName,
    required this.breedImage,
  });

  @override
  State<AddPetProfileScreen> createState() => _AddPetProfileScreenState();
}

class _AddPetProfileScreenState extends State<AddPetProfileScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthController = TextEditingController();

  final AuthService _authService = AuthService();
  final PetService _petService = PetService();

  Future<void> _savePetAndContinue() async {
    if (nameController.text.isEmpty || birthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill pet name and birth date')),
      );
      return;
    }

    try {
      // Parse birth date dd/mm/yyyy -> age approx
      final parts = birthController.text.split('/');
      int age = 0;
      if (parts.length == 3) {
        final birthDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        age = DateTime.now().year - birthDate.year;
        final now = DateTime.now();
        if ((now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day))) {
          age--;
        }
      }

      final user = await _authService.getCurrentUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final pet = Pet(
        id: '', // auto-generated
        name: nameController.text,
        species: 'Dog',
        breed: widget.breedName,
        age: age.clamp(0, 30), // sane range
        imageUrl: widget.breedImage,
      );

      final petId = await _petService.createPet(pet);
      await _petService.addPetToUser(user.id, petId);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              petName: nameController.text,
              breedName: widget.breedName,
              imagePath: widget.breedImage,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

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

                  Expanded(
                    child: Center(
                      child: Text(
                        widget.breedName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),

                ],
              ),

              const SizedBox(height: 30),

              // DOG IMAGE
              Image.asset(
                widget.breedImage,
                height: 150,
              ),

              const SizedBox(height: 40),

              // PET NAME
              buildTextField("What's your pet name?", nameController),

              const SizedBox(height: 15),

              // PET SIZE
              buildTextField("What's your pet size?", sizeController),

              const SizedBox(height: 15),

              // PET GENDER
              buildTextField("What's your pet Gender ?", genderController),

              const SizedBox(height: 15),

              // BIRTH DATE
              TextField(
                controller: birthController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "What's your pet Birth date?",
                  filled: true,
                  fillColor: const Color(0xFF4C7A80),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          birthController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const Spacer(),

              // CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C7A80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: _savePetAndContinue,

                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF4C7A80),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
