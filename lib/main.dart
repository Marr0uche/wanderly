import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/map_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

void main() async {
	await dotenv.load(fileName: ".env");
	runApp(
	MultiProvider(
		providers: [
		ChangeNotifierProvider(create: (_) => MapProvider()),
		ChangeNotifierProvider(create: (_) => FavoritesProvider()),
		ChangeNotifierProvider(create: (_) => ThemeProvider()),
		],
		child: const MyApp(), 
	),
	);
}