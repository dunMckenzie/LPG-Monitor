import 'package:flutter/material.dart';

class HeaderPage extends StatelessWidget {
  static const keyDarkMode = 'key-dark-mode';
  const HeaderPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          buildHeader(),
          const SizedBox(height: 32),
        ],
      );

  Widget buildHeader() => const Center(
          child: Text(
        'Settings',
      ));
}
