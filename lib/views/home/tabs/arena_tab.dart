import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_arena/config/apptheme.dart';
import 'package:live_arena/views/home/arena/create_arena.dart';
import 'package:live_arena/views/home/arena/find_screen.dart';

class ArenaTab extends StatelessWidget {
  const ArenaTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildEmptyArean(),
    );
  }

  Widget buildEmptyArean() => Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ArenaOptionTile(
                image: 'assets/images/sports.png',
                text: 'NEW AREAN',
                onTap: () => Get.to(() => const CreateArenaScreen()),
              ),
              const SizedBox(height: 10),
              ArenaOptionTile(
                image: 'assets/images/search.png',
                text: 'FIND AREAN',
                onTap: () {
                  Get.to(() => FindScreen());
                },
              ),
            ],
          ),
        ),
      );
}

class ArenaOptionTile extends StatelessWidget {
  const ArenaOptionTile({
    Key? key,
    required this.image,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width,
        height: context.height / 3,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              height: context.height / 9,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
