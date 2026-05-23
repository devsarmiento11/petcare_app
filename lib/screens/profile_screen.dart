import 'package:flutter/material.dart';
import 'editprofile_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),

            /// PROFILE HEADER (from Firestore users/{uid})
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: (uid == null)
                      ? null
                      : FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.data();
                    final name = (data?['name'] as String?) ?? user?.displayName ?? 'User';
                    final imageUrl = (data?['profileImageUrl'] as String?) ?? user?.photoURL;

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                              ? NetworkImage(imageUrl)
                              : null,
                          child: (imageUrl == null || imageUrl.isEmpty)
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello,",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    );
                  },
                ),
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
              child: Material(
                color: const Color(0xffE5E5E5),
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    final authService = AuthService();
                    try {
                      await authService.logout();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed: $e')),
                      );
                    }
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Row(
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
              ),
            ),



          ],
        ),
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
