import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ShineShelfApp());
}

class ShineShelfApp extends StatelessWidget {
  const ShineShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'ShineShelf',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
            brightness: Brightness.light, 
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
          ),
          themeMode: ThemeMode.system, // Supports Light/Dark mode
          home: auth.isAuthenticated ? const HomeScreen() : const AuthScreen(),
        ),
      ),
    );
  }
}
