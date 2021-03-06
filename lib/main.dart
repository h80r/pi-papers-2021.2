import 'package:flutter/material.dart';

import 'package:pi_papers_2021_2/pages/histogram_page.dart';
import 'package:pi_papers_2021_2/pages/home_page.dart';
import 'package:pi_papers_2021_2/pages/arithmetic_page.dart';
import 'package:pi_papers_2021_2/pages/geometric_page.dart';
import 'package:pi_papers_2021_2/pages/smothing_page.dart';
import 'package:pi_papers_2021_2/pages/spatial_page.dart';

import 'package:pi_papers_2021_2/style/color_palette.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr. Image',
      initialRoute: '/',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorPalette.background,
      ),
      routes: {
        '/': (ctx) => const HomePage(),
        '/arithmetic_operation': (ctx) => const ArithmeticPage(),
        '/geometric_transformation': (ctx) => const GeometricPage(),
        '/histogram_processing': (ctx) => const HistogramPage(),
        '/smoothing_filter': (ctx) => const SmoothingPage(),
        '/spatial_filtering': (ctx) => const SpatialFilteringPage(),
      },
    );
  }
}
