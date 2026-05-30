import 'package:flutter/material.dart';

import 'views/home_page.dart';

void main() {
  runApp(const NumberFactsApp());
}

class NumberFactsApp extends StatelessWidget {
  const NumberFactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Факты о числах',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
