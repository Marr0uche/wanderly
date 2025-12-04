import 'package:flutter/material.dart';
import 'map_page.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/map_provider.dart';

class HomePage extends StatelessWidget {
	const HomePage({super.key});

	@override
	Widget build(BuildContext context) {
		final themeVM = Provider.of<ThemeProvider>(context);
		final mapVM = Provider.of<MapProvider>(context);
		

		return Scaffold(
			appBar: AppBar(
				title: const Text("Wanderly"),
				actions: [
					IconButton(
						icon: Icon(themeVM.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
						onPressed: () => themeVM.toggleTheme(),
					),
				],
			),
			body:
			Stack(
				children: [
					SingleChildScrollView(
						child: Column(children: [const MapPage(), const Divider()]),
					),
					if (mapVM.isLoading)
						Container(
							color: Colors.black.withOpacity(0.4),
							child: const Center(
								child: CircularProgressIndicator(color: Colors.white),
							),
						)
				],
			)
			
		);
	}
}