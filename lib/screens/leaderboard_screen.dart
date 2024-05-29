import 'package:flutter/material.dart';

import '../main.dart';
import '../api/apis.dart';
import '../models/main_user.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<MainUser> _list = [];

  @override
  void initState() {
    super.initState();
    APIs.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Leaderboard',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true),
      body: StreamBuilder(
          stream: APIs.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // if data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              // if data is loaded then show it
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                _list =
                    data?.map((e) => MainUser.fromJson(e.data())).toList() ??
                        [];
                _list.sort((a, b) => b.uploads.compareTo(a.uploads));
                int count = 0;
                for (var i in _list) {
                  if (i.uploads > 0) {
                    count++;
                  }
                }

                if (count != 0) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: mq.width * .02, right: mq.width * .005),
                        child: ListTile(
                          leading: const Text(
                            'Rank',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mq.width * .07),
                            child: const Text(
                              'User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          trailing: const Text(
                            'Uploads',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: mq.width * .05),
                              child: ListTile(
                                leading: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                title: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mq.width * .05),
                                  child: Row(
                                    children: [
                                      Text(
                                        _list[index].name.split(' ').first,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      if (index < 3)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: mq.width * .05),
                                          child: Image.asset(
                                            'assets/images/$index-medal.png',
                                            width: mq.width * .065,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                trailing: Text(
                                  _list[index].uploads.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: mq.height * .1),
                      child: Column(
                        children: [
                          const Text(
                            'No one has uploaded yet!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: mq.height * .03),
                          Image.asset(
                            'assets/images/leaderboard.png',
                            height: mq.height * .4,
                          ),
                        ],
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}
