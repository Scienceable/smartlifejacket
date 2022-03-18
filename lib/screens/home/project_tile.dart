import 'package:flutter/material.dart';
import 'package:science_club/models/project.dart';
import 'package:science_club/screens/project/project_1.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

class ProjectTile extends StatelessWidget {

  final Project project;
  const ProjectTile(this.project);


  @override
  Widget build(BuildContext context) {
    Widget _profilePhoto(){
      print (project.photoURL);
      if (project.photoURL == null){
        return Initicon(size: 40.0, text: project.projectName);
      } else {
        return CircleAvatar(
          radius: 20.0,
          backgroundImage: NetworkImage(project.photoURL!),
        );
      }
    }
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: _profilePhoto(),
              onTap: () {
                if (project.projectNumber == 1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Project1UI(),
                  )
                  );
                };
              },
            title: Text(project.projectName!)
          ),
        ),
      );

  }
}