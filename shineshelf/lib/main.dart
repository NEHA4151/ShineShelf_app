import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (ctx, auth, themeProvider, _) => MaterialApp(
          title: 'ShineShelf',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
            brightness: Brightness.light, 
            scaffoldBackgroundColor: const Color(0xFFF5F5DC), // Beige background 
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
          ),
          themeMode: themeProvider.themeMode, 
          home: auth.isAuthenticated ? const HomeScreen() : const AuthScreen(),
        ),
      ),
    );
  }
}
