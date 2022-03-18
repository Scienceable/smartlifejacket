import 'package:science_club/models/member.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_club/screens/home/member_tile.dart';

import '../../shared/variables.dart';

class MemberList extends StatefulWidget {
  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  @override
  Widget build(BuildContext context) {
    final members = Provider.of<List<Member>?>(context);
    return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              'Welcome, $userName!',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'There are ${(members?.length)! - 1} other members',
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.left,
            ),
          ),
          Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: members?.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MemberTile(members![index]);
                  })),
        ]);
  }
}
