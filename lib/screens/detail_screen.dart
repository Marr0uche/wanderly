import 'package:flutter/material.dart';
import '../models/favoriteplace_item.dart';

class DetailScreen extends StatelessWidget {
  final FavoritePlaceItem item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: item.image,
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                height: 250,
                errorBuilder: (context, error, stack) {
                  return Container(
                    color: Colors.grey,
                    height: 250,
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Adresse: ${item.lieu.tags["addr:street"] ?? "N/A"}",
              ),
            ),
            if (item.lieu.tags["website"] != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Site web: ${item.lieu.tags["website"]}"),
              ),
          ],
        ),
      ),
    );
  }
}
