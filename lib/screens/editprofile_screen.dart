import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as app_user;
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: "Kent");
  final TextEditingController lastNameController =
      TextEditingController(text: "Sarmiento");
  final TextEditingController phoneController =
      TextEditingController(text: "9874563211");

  String gender = "Male";
  String birthDate = "12-06-2004";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),

      appBar: AppBar(
        backgroundColor: const Color(0xffF4F4F4),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Avatar
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.black),
            ),

            const SizedBox(height: 10),

            const Text(
              "Kent",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            // First Name
            _buildTextField(
              controller: firstNameController,
              hint: "First Name",
            ),

            const SizedBox(height: 15),

            // Last Name
            _buildTextField(
              controller: lastNameController,
              hint: "Last Name",
            ),

            const SizedBox(height: 15),

            // Phone Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: _boxDecoration(),
              child: Row(
                children: [
                  const Text("+91"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.edit, size: 18),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Gender Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: _boxDecoration(),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: gender,
                  isExpanded: true,
                  items: ["Male", "Female"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Birthdate
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: _boxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(birthDate),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4E7A80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _updateProfile,
                child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Update Profile",
                      style: TextStyle(color: Colors.white),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.edit, size: 18),
        ],
      ),
    );
  }

  // 🔹 Box style
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    );
  }

  // 🔹 Date picker
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2004, 6, 12),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        birthDate =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    try {
      final authService = AuthService();
      final user = await authService.getCurrentUser();
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in first')),
          );
        }
        setState(() => isLoading = false);
        return;
      }
      final fullName = '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim();
      final phone = phoneController.text.trim();
      if (fullName.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name cannot be empty')),
          );
        }
        setState(() => isLoading = false);
        return;
      }
      await authService.updateProfile(user.id, fullName, phone: phone.isEmpty ? null : phone);
      final currentAuthUser = FirebaseAuth.instance.currentUser;
      if (currentAuthUser != null) {
        await currentAuthUser.updateDisplayName(fullName);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
