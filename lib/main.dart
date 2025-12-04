import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'providers/map_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';

import 'app.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'db/database_helper.dart';

void main() async {
	await dotenv.load(fileName: ".env");

	WidgetsFlutterBinding.ensureInitialized();
	if (kIsWeb) {
		// Web version
		databaseFactory = databaseFactoryFfiWeb;
	} else {
		// Desktop version (Windows/Linux/macOS)
		databaseFactory = databaseFactoryFfi;
		sqfliteFfiInit();
	}
	await Dbhelper.instance.initDb();

	final themeProvider = ThemeProvider();
	await themeProvider.loadThemeFromPrefs();

	final FavoritesProvider favoritesProvider = FavoritesProvider();

	runApp(
		MultiProvider(
			providers: [
			ChangeNotifierProvider(create: (_) => MapProvider()),
			ChangeNotifierProvider(create: (_) => favoritesProvider),
			ChangeNotifierProvider(create: (_) => themeProvider),
			],
			child: const MyApp(), 
		),
	);
}