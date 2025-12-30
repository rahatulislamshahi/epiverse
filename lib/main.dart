import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:epiverse/auth/auth_screen.dart';
import 'package:epiverse/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaV3Provider` provider here as an
    // alternative to `AppleProvider`.
    appleProvider: AppleProvider.debug,
    androidProvider: AndroidProvider.debug,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const EpiverseApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class EpiverseApp extends StatelessWidget {
  const EpiverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Color(0xFF6C42F5);

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.spaceGrotesk(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
        surface: Colors.black,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Epiverse',
          theme: darkTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const AuthScreen();
          }
          return const HomeScreen();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
