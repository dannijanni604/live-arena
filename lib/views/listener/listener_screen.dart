import 'package:flutter/material.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/models/arena_listener_model.dart';

class ArenaListenerScreen extends StatelessWidget {
  const ArenaListenerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          buildListenerProfile(),
          Divider(),
          buildOtherListener(),
        ],
      ),
    );
  }

  Widget buildOtherListener() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("Other Listener", style: txt16b)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(children: [
              ...ArenaListener.ArenaListenerList.map(
                (listener) => InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 27,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              listener.profileImg,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          listener.name,
                          style: TextStyle(
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          softWrap: true,
                        )
                      ],
                    ),
                  ),
                ),
              ).toList(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildListenerProfile() {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("images/man.jpg"),
          ),
          title: Text("Listener Name", style: txt16b),
          subtitle: Row(
            children: [
              Text("English/"),
              Icon(Icons.message_outlined, size: 12)
            ],
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined, color: Colors.black),
          ),
        ),
        ListTile(
          leading: Text(""),
          title: Text("Favourite Sports"),
          subtitle: Text("Car Racing"),
          trailing: Container(
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 20),
                SizedBox(width: 5),
                Text("Follow", style: txt16w),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
