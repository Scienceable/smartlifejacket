import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_club/models/project.dart';
import 'package:science_club/screens/home/project_tile.dart';

import '../../services/database.dart';
import '../../shared/loading.dart';
import '../../shared/variables.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Project>?>.value(
        value: DatabaseService(globaluid.value).project,
        initialData: null,
        child: StreamBuilder<List<Project>?>(
            stream: DatabaseService(globaluid.value).project,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final projects = Provider.of<List<Project>?>(context);
                return Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Text(
                          'Select a project to proceed',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'There are ${(projects?.length)} ongoing projects in total',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: projects?.length,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ProjectTile(projects![index]);
                              })),
                    ]);
              } else {
                return Loading();
              }
            }));
  }
}
