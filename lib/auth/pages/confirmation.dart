import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.email_outlined,
              size: 65,
              semanticLabel: "Email icon",
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Check your email",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium!.copyWith(),
            ),
            const SizedBox(
              height: 20,
            ),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  const TextSpan(
                    text: "We just emailed you a verification link to ",
                  ),
                  TextSpan(
                    text: email,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text:
                        ". Click the link, and you'll be signed in automatically.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
