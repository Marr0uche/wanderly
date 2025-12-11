import 'package:flutter/material.dart';
import 'map_page.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/map_provider.dart';
import '../screens/favorites_page.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeProvider>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2C3E50),
              ),
              child: const Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Villes favorites"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                );
              },
            ),

            const Divider(),

            
            ListTile(
              leading: Icon(
                themeVM.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              title: const Text("Changer le thème"),
              onTap: () {
                themeVM.toggleTheme();
              },
            ),
          ],
        ),
      ),

     
      appBar: AppBar(
        automaticallyImplyLeading: true, // affiche l'icône du menu
        title: const Text("Wanderly"),
      ),

      // ------------------------------------------------------------------
      // CORPS DE LA PAGE
      // ------------------------------------------------------------------
      body: Stack(
        children: [
          // Le contenu scrollable (carte + autres sections plus tard)
          SingleChildScrollView(
            child: Column(
              children: const [
                MapPage(),
                Divider(),
              ],
            ),
          ),

         
          if (Provider.of<MapProvider>(context).isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
