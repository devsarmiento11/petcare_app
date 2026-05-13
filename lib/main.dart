import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/payment_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

Stripe.publishableKey =
    "pk_test_51TUDnRGn0Cl63UNEW4LyDGPFFjCQMysqICtgvUwNEa8qFJhTpaTXiV7HDoREZxEzU38BWAfgqcHgiuUmb1V05Jy500NhdtgWDq";
  await Stripe.instance.applySettings();

  await MobileAds.instance.initialize();


  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        // '/breed-selection': (context) => const BreedSelectionScreen(),
        // '/add-pet': (context) => const AddPetProfileScreen(breedName: '', breedImage: ''),
        // '/dashboard': (context) => const DashboardScreen(petName: '', breedName: '', imagePath: ''),
        // '/store': (context) => const StoreScreen(),
        // '/messages': (context) => const MessagesScreen(),
        // '/profile': (context) => const ProfileScreen(),
        '/map': (context) => const MapScreen(),
        '/booking': (context) => const BookingScreen(),
        '/payment': (context) => const PaymentScreen(),
      },
    );
  }
}
