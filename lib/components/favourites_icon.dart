import 'package:flutter/material.dart';

class FavouritesIcon extends StatefulWidget {
  const FavouritesIcon({Key? key}) : super(key: key);

  @override
  _FavouritesIconState createState() => _FavouritesIconState();
}

class _FavouritesIconState extends State<FavouritesIcon> {
  bool iconCon = false;
  double _size = 25;
  // Color iconColor = Colors.black;
  IconData _iconData = Icons.favorite_border_outlined;

  void onPress() {
    setState(() {
      if (_iconData == Icons.favorite_border_outlined) {
        _iconData = Icons.favorite;
        _size = 30;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.pink.withOpacity(0.4),
            duration: const Duration(seconds: 1),
            content: const Text("Add To Favorites")));
      } else {
        _iconData = Icons.favorite_border_outlined;
        _size = 25;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black.withOpacity(0.5),
            duration: const Duration(seconds: 1),
            content: const Text("Remove from Favorites")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(5),
      child: IconButton(
        onPressed: () {
          setState(() {
            onPress();
          });
        },
        icon: Icon(
          _iconData,
          color: Colors.pink,
          size: _size,
        ),
      ),
    );
  }
}
