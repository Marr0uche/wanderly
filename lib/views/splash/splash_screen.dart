import 'package:flutter/material.dart';
import '../map/map_page.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
	@override
	void initState() {
		super.initState();
		
		Future.delayed(const Duration(seconds: 1), () {
			_goToNextScreen();
		});
	}

	void _goToNextScreen() {
		Navigator.pushReplacement(
			context,
			PageRouteBuilder(
			transitionDuration: Duration(milliseconds: 500),
			transitionsBuilder: (_, animation, __, child) => SlideTransition(
				position: Tween(
				begin: Offset(1.0, 0.0),
				end: Offset(0.0, 0.0),
				).animate(animation),
				child: child,
			),
			pageBuilder: (_, __, ___) => MapPage(),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Stack(
			fit: StackFit.expand,
			children: [
				// Background image
				Image.asset('assets/images/welcome_bg.jpg', fit: BoxFit.cover),

				// Centered logo
				Center(
				child: Image.asset(
					'assets/images/Logo.png',
					width: 200,
					height: 200,
				),
				),
			],
			),
		);
	}
}
