import 'package:flutter/material.dart';

class AvatarMenu extends StatefulWidget {
  const AvatarMenu({Key? key, this.image}) : super(key: key);
  final String? image;

  @override
  _AvatarMenuState createState() => _AvatarMenuState();
}

class _AvatarMenuState extends State<AvatarMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(
              widget.image == null
                  ? 'https://randomuser.me/api/portraits/men/46.jpg'
                  : widget.image!,
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: Offset(0, 60),
      onSelected: (value) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('Julia Kate'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('Ec Department'),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
