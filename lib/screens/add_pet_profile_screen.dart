import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/pet_service.dart';
import '../models/pet.dart';
import 'main_shell.dart';

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

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    sizeController.dispose();
    genderController.dispose();
    birthController.dispose();
    super.dispose();
  }

  int _calculateAge(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length != 3) return 0;
    final birth = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age.clamp(0, 30);
  }

  Future<void> _savePetAndContinue() async {
    if (nameController.text.isEmpty || birthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill pet name and birth date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final age = _calculateAge(birthController.text);

      final user = await _authService.getCurrentUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final pet = Pet(
        id: '',
        name: nameController.text,
        species: 'Dog',
        breed: widget.breedName,
        age: age,
        imageUrl: widget.breedImage,
        gender: genderController.text.isEmpty ? null : genderController.text,
        size: sizeController.text.isEmpty ? null : sizeController.text,
        birthDate: birthController.text.isEmpty ? null : birthController.text,
      );


      final petId = await _petService.createPet(pet);
      await _petService.addPetToUser(user.id, petId);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainShell(
              petName: nameController.text,
              breedName: widget.breedName,
              imagePath: widget.breedImage,
              petId: petId,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                    onPressed: () => Navigator.pop(context),
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
              Image.asset(widget.breedImage, height: 150),

              const SizedBox(height: 40),

              // PET NAME
              buildTextField("What's your pet name?", nameController),

              const SizedBox(height: 15),

              // PET SIZE
              GestureDetector(
                onTap: () async {
                  final size = await showModalBottomSheet<String>(
                    context: context,
                    backgroundColor: const Color(0xFFF3F3F3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      const sizeOptions = <String>[
                        'Toy Dogs\nWeight: 3–12 pounds',
                        'Small Dogs\nWeight: 12–25 pounds',
                        'Medium Dogs\nWeight: 25–50 pounds',
                        'Large Dogs\nWeight: 50–100 pounds',
                        'Giant Dogs\nWeight: Over 100 pounds',
                      ];

                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Select pet size category',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            ...sizeOptions.map(
                              (option) => ListTile(
                                title: Text(option),
                                onTap: () => Navigator.pop(context, option),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  );

                  if (size != null) {
                    setState(() {
                      sizeController.text = size;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: sizeController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "What's your pet size?",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF4C7A80),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white70,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // PET GENDER
              GestureDetector(
                onTap: () async {
                  final selected = await showModalBottomSheet<String>(
                    context: context,
                    backgroundColor: const Color(0xFFF3F3F3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Select gender",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.male),
                              title: const Text("Male"),
                              onTap: () => Navigator.pop(context, 'Male'),
                            ),
                            ListTile(
                              leading: const Icon(Icons.female),
                              title: const Text("Female"),
                              onTap: () => Navigator.pop(context, 'Female'),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  );

                  if (selected != null) {
                    setState(() {
                      genderController.text = selected;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: genderController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "What's your pet gender?",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF4C7A80),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white70,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // BIRTH DATE
              TextField(
                controller: birthController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "What's your pet birth date?",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF4C7A80),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                    ),
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
                              "${pickedDate.day.toString().padLeft(2, '0')}/"
                              "${pickedDate.month.toString().padLeft(2, '0')}/"
                              "${pickedDate.year}";
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
                  onPressed: _isLoading ? null : _savePetAndContinue,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Continue",
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
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

