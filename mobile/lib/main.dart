import 'package:flutter/material.dart';

import 'features/home/home_page.dart';

void main() {
  runApp(const RoadlyApp());
}

class RoadlyApp extends StatelessWidget {
  const RoadlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roadly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}