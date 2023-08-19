import 'package:flutter/material.dart';
import 'package:live_arena/components/favourites_icon.dart';
import 'package:live_arena/components/rounded_btn.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/models/recomended_arena.dart';

class ExploreRecomendedArena extends StatefulWidget {
  const ExploreRecomendedArena({
    Key? key,
    required this.arena,
  }) : super(key: key);
  final RecomendedArena arena;

  @override
  _ExploreRecomendedArenaState createState() => _ExploreRecomendedArenaState();
}

class _ExploreRecomendedArenaState extends State<ExploreRecomendedArena> {
  bool volume = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.arena.imag),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                // decoration: BoxDecoration(color: Colors.black38),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios,
                                size: 20, color: Colors.white),
                          ),
                          FavouritesIcon(),
                        ],
                      ),
                    ),
                    Spacer(),
                    volumeButton()
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.arena.streamTitle,
                    style: txt20b,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "# " + widget.arena.sportName,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.arena.streamCategory,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "# " + widget.arena.language,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                      "Like e-mail and voicemail and unlike calls (in which the caller hopes to speak texting does this permits communication directly with the recipient), texting does this permits communication even between busy"),
                  SizedBox(height: 15),
                  Text("Repoters", style: txt16b),
                  Divider(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(
                        10,
                        (index) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage("images/man.jpg"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: RoundedButton(
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("\$ 150", style: txt16w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text("Buy Ticket", style: txt16b),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding volumeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                setState(
                  () {
                    if (volume == true) {
                      volume = false;
                    } else {
                      volume = true;
                    }
                  },
                );
              },
              icon: volume
                  ? Icon(Icons.volume_up, color: Colors.black)
                  : Icon(Icons.volume_off, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
