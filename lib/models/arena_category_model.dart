import 'dart:ui';
import 'package:flutter/material.dart';

class ArenaCategory {
  final String arenaTitle;
  final Color color;

  const ArenaCategory({required this.arenaTitle, required this.color});

  static const List<ArenaCategory> arenaCategoryList = [
    ArenaCategory(arenaTitle: "# Action", color: Colors.orange),
    ArenaCategory(arenaTitle: "# Racing", color: Colors.pinkAccent),
    ArenaCategory(arenaTitle: "# Athlatic", color: Colors.purple),
    ArenaCategory(arenaTitle: "# Indoor", color: Colors.blue),
    ArenaCategory(arenaTitle: "# Outdoor", color: Colors.teal),
  ];
}
