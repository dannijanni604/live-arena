import 'package:flutter/material.dart';
import 'package:live_arena/components/text_styles.dart';
import 'package:live_arena/models/arena_listener_model.dart';

class RepoterScreen extends StatefulWidget {
  const RepoterScreen({Key? key}) : super(key: key);

  @override
  _RepoterScreenState createState() => _RepoterScreenState();
}

class _RepoterScreenState extends State<RepoterScreen> {
  TextEditingController _comment = TextEditingController();
  double opacity = 0;
  bool bottomSheet = false;

  void onPress() {
    setState(() {
      if (opacity == 1) {
        opacity = 0;
      } else {
        opacity = 1;
      }
      if (bottomSheet = true) {
        bottomSheet = false;
      } else {
        bottomSheet = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeybord = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Repoter"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isKeybord == false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRepoterListTile(),
                Divider(),
                // listner title
                buildListnerSlider(),
                Divider(),
                // joined repoter
                buildJoinedRepoter(),

                buildCommetButton(),
              ],
            ),
          Opacity(
            opacity: opacity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("Comments show  here"),
            ),
          ),
          Spacer(),
          buildCommetfield(),
        ],
      ),
    );
  }

  Padding buildCommetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: TextButton(
          onPressed: () {
            setState(() {
              onPress();
            });
          },
          child: Text("leave a commet..")),
    );
  }

  ListTile buildJoinedRepoter() {
    return ListTile(
      leading: Text("Joined Repoter", style: txt16b),
      title: Row(
        children: [
          Text("4/", style: txt16b),
          Text("5"),
        ],
      ),
      trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(10)),
          child: Text("Promote", style: TextStyle(color: Colors.white))),
    );
  }

  Widget buildRepoterListTile() {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage("images/man.jpg"),
      ),
      title: Text("Repoter name", style: txt16b),
      subtitle: Row(
        children: [Text("English/"), Icon(Icons.message_outlined, size: 12)],
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.edit_outlined, color: Colors.black),
      ),
    );
  }

  Widget buildListnerSlider() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Listeners", style: txt16b),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Text("Follow", style: TextStyle(color: Colors.white)),
                      Icon(Icons.add, color: Colors.white, size: 18),
                    ],
                  )),
            ],
          ),
        ),
        // listner list
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(children: [
            ...ArenaListener.ArenaListenerList.map(
              (listner) => Container(
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
                          "images/man.jpg",
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Azeem",
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
            ).toList(),
          ]),
        ),
      ],
    );
  }

  Widget buildCommetfield() {
    return Opacity(
      opacity: opacity,
      child: BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          child: TextFormField(
            controller: _comment,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              hintText: "type here",
              fillColor: Colors.white,
              suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
