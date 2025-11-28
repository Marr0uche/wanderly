import 'package:flutter/material.dart';
import 'home_page.dart';

class AccueilScreen extends StatelessWidget {
	const AccueilScreen({super.key});

	

	/*void _goToNextScreen() {
		Navigator.pushReplacement(
			context,
			PageRouteBuilder(
			transitionDuration: Duration(milliseconds: 500),
			transitionsBuilder: (_, animation, _, child) => SlideTransition(
				position: Tween(
				begin: Offset(1.0, 0.0),
				end: Offset(0.0, 0.0),
				).animate(animation),
				child: child,
			),
			pageBuilder: (_, _, _) => MapPage(),
			),
		);
	}*/

	 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child:  Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),

            // Bouton Commencer
            ElevatedButton(
              child: const Text("Commencer"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
            ),
          ],
        ),
      ),
    )
    );
  }
}