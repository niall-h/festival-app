import 'package:festival_app/auth/pages/login.dart';
import 'package:festival_app/pages/home.dart';
import 'package:festival_app/auth/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const SUPABASE_URL = "https://akisxlurkddltplbucvl.supabase.co";
const SUPABASE_ANON_KEY =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFraXN4bHVya2RkbHRwbGJ1Y3ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQ5Nzg5NjEsImV4cCI6MjAzMDU1NDk2MX0.9MJMqfzLzT0Vx68YtLFq8eEp1QbpZ540iIK-LfWbb9k";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var lightTheme = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );
    var darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Festival Planner App',
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        "/": (_) => const SplashPage(),
        "/login": (_) => const LoginPage(),
        "/home": (_) => const HomePage(),
      },
    );
  }
}
