import 'package:science_club/models/member.dart';
import 'package:flutter/material.dart';
import 'package:science_club/shared/variables.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

class MemberTile extends StatelessWidget {

  final Member member;
  const MemberTile(this.member);


  @override
  Widget build(BuildContext context) {
    Widget _profilePhoto(){
      if (member.photoUrl == null){
        return Initicon(size: 25.0, text: member.name,);
      } else {
        return CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(member.photoUrl!),
        );
      }
      }
    if (member.uid != globaluid.value) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: _profilePhoto(),
            title: Text(member.name!),
            subtitle: Text(member.email!),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}