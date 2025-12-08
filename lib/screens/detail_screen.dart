import 'package:flutter/material.dart';
import '../models/Lieu.dart';

class DetailScreen extends StatelessWidget {
  final Lieu item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: item.tags["image"] ?? "",
              child: Image.network(
                item.tags["image"] ?? "",
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
                "Adresse: ${item.tags["addr:street"] ?? "N/A"}",
              ),
            ),
            if (item.tags["website"] != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Site web: ${item.tags["website"]}"),
              ),
          ],
        ),
      ),
    );
  }
}
