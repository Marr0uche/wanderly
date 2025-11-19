import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/map_viewmodel.dart';
import 'app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => MapViewModel(), child: const MyApp()),
  );
}
