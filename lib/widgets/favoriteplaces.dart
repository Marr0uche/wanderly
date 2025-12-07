import 'package:flutter/material.dart';
import '../models/favoriteplace_item.dart';
import '../screens/detail_screen.dart';

class FavoritePlacesScroller extends StatefulWidget {
  final List<FavoritePlaceItem> items;

  const FavoritePlacesScroller({super.key, required this.items});

  @override
  State<FavoritePlacesScroller> createState() => _FavoritePlacesScrollerState();
}

class _FavoritePlacesScrollerState extends State<FavoritePlacesScroller> {
  int currentIndex = 0;

  void next() {
    if (currentIndex < widget.items.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void previous() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: Text("Pas de lieux favoris"));
    }

    return Column(
      children: [
        SizedBox(
          height: 230,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BOUTON GAUCHE
              IconButton(
                icon: const Icon(Icons.arrow_left, size: 40),
                onPressed: previous,
              ),

              // ÉLÉMENTS CENTRÉS
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(), // pas de scroll manuel
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];

                    bool isCenter = index == currentIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isCenter ? 180 : 140, // au centre → plus grand
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: isCenter ? 10 : 2,
                            color:
                                Colors.black.withOpacity(isCenter ? 0.3 : 0.1),
                          )
                        ],
                      ),
                      child: Opacity(
                        opacity: isCenter ? 1 : 0.4, // centre = clair | autres = sombre
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(item: item),
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.network(
                                  item.image,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight:
                                        isCenter ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isCenter)
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailScreen(item: item),
                                      ),
                                    );
                                  },
                                  child: const Text("Voir détails"),
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // BOUTON DROIT
              IconButton(
                icon: const Icon(Icons.arrow_right, size: 40),
                onPressed: next,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
