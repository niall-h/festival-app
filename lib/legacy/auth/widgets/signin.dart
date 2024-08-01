import 'dart:async';

import 'package:festival_app/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef IntCallback = void Function(int selectedIndex);

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _redirecting = false;

  // toggle password visibility
  bool _showPassword = false;

  // Create email, password, and confirmation password controllers to retrieve the respective values
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final AuthResponse authResponse = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (authResponse.session == null) {
        print('session not found');
      }
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: mounted ? Theme.of(context).colorScheme.error : null,
      );
    } catch (error) {
      SnackBar(
        content: const Text("Unexpectd error occurred"),
        backgroundColor: mounted ? Theme.of(context).colorScheme.error : null,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, "/home");
      }
    }
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();

    // cancel auth subscription
    _authStateSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Icon passwordIcon;
    if (_showPassword) {
      passwordIcon = const Icon(Icons.visibility);
    } else {
      passwordIcon = const Icon(Icons.visibility_off);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Welcome back!",
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Let's sign you back in.",
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  label: Text("Email"),
                  hintText: "youremail@example.com",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                enableSuggestions: false,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(),
                  label: const Text("Password"),
                  hintText: "**********",
                  suffixIcon: IconButton(
                    icon: passwordIcon,
                    onPressed: () => setState(() {
                      _showPassword = !_showPassword;
                    }),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _signIn();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator())
                    : const Text("Sign In"),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
