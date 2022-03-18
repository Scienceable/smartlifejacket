import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:science_club/models/projects/project_1.dart';
import 'package:science_club/shared/loading.dart';
import 'package:tflite_audio/tflite_audio.dart';

import '../../services/database.dart';
import '../../shared/variables.dart';

class Project1UI extends StatefulWidget {
  const Project1UI({Key? key}) : super(key: key);

  @override
  State<Project1UI> createState() => _Project1UIState();
}

class _Project1UIState extends State<Project1UI> {
  List<Marker> allMarkers = [];
  GoogleMapController? _controller;
  double? zoom = 12.0;
  int? _currentDepth;

  bool? _recording = false;

  Stream<Map<dynamic, dynamic>?>? result;
  String? _sound = "Press the button to start";

  ValueNotifier<bool?> activateTrigger = ValueNotifier<bool?>(false);
  bool? hasActivated = false;


  @override
  void initState() {
    super.initState();
    TfliteAudio.loadModel(
        model: 'assets/soundclassifier_with_metadata.tflite',
        label: 'assets/labels.txt',
        numThreads: 1,
        isAsset: true,
        inputType: 'rawAudio');
  }

  void _recorder() {
    String recognition = "";
    if (!_recording!) {
      setState(() => _recording = true);
      result = TfliteAudio.startAudioRecognition(
        numOfInferences: 3,
        sampleRate: 44100,
        bufferSize: 22016,

      );
      result?.listen((event) {
        recognition = event!["recognitionResult"];
      }).onDone(() {
        setState(() {
          _recording = false;
          _sound = recognition;
        });

        if ((_sound == "1 Help") || (_sound == "2 Help me") ||
            (_sound == "3 Screaming")) {
          print("EMERGENCY DETECTED");
          setState(() {
            activateTrigger.value = true;
          });
        }
      });
    }
  }

  void _stop() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }


  @override
  Widget build(BuildContext context) {
    return StreamProvider<Project1Data?>.value(
        value: DatabaseService(globaluid.value).project1Data,
        initialData: null,
        child: StreamBuilder<Project1Data?>(
        stream: DatabaseService(globaluid.value).project1Data,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    Project1Data? project1data = snapshot.data;
    String? projectName = project1data?.projectName;
    int? projectNumber = project1data?.projectNumber;
    String? photoURL = project1data?.photoURL;
    GeoPoint? deviceCoordinates = project1data?.deviceCoordinates;
    int? depthActivated = project1data?.depthActivated;
    bool? isActivated = project1data?.isActivated;
    double? lat = deviceCoordinates?.latitude;
    double? lng = deviceCoordinates?.longitude;
    LatLng target = LatLng(lat!, lng!);

    void initState() {
    allMarkers.add(Marker(
    markerId: const MarkerId('Device'),
    draggable: true,
    onTap: () {},
    position: target));
    }

    initState();

    void mapCreated(controller) {
    setState(() {
    _controller = controller;
    });
    }

    updatePosition() async {
    zoom = await _controller?.getZoomLevel();

    _controller?.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(target: target, zoom: (zoom?.toDouble())!),
    ));
    }

    updatePosition();

    activateDevice() async {
    await DatabaseService(globaluid.value)
        .updateProject1(
    projectName,
    depthActivated,
    true,
    photoURL);
    }
    return ValueListenableBuilder(
    valueListenable: activateTrigger,
    builder: (BuildContext context, bool? value, Widget? child)
    {
      if ((activateTrigger.value == true) && (hasActivated == false)) {
        activateDevice();
          hasActivated = true;
      } else if (activateTrigger.value == false) {
          hasActivated = false;
      }
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(projectName!),
          backgroundColor: Colors.orange[200],
          elevation: 0.0,
        ),
        body: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Container(
                  alignment: Alignment.center,
                  height: 500,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: target, zoom: (zoom?.toDouble())!),
                    onMapCreated: mapCreated,
                    markers: Set.from(allMarkers),
                  ),
                ),
              ),
              Flexible(
                  child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          isActivated == false
                              ? Container(
                            color: Colors.red,
                            child: const Text(
                              'Device is not activated',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                              : Container(
                            color: Colors.green,
                            child: const Text(
                              'Device is activated',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Activating depth',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Slider(
                              value: (_currentDepth ?? depthActivated!)
                                  .toDouble(),
                              activeColor: Colors
                                  .blue[_currentDepth ?? depthActivated!],
                              inactiveColor: Colors
                                  .brown[_currentDepth ??
                                  depthActivated!],
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              onChanged: (val) async {
                                setState(() =>
                                _currentDepth = val.round());
                                await DatabaseService(globaluid.value)
                                    .updateProject1(
                                    projectName,
                                    _currentDepth ?? depthActivated,
                                    isActivated!,
                                    photoURL);
                              }),
                          Text(
                            '$depthActivated meters',
                            style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          MaterialButton(
                            onPressed: _recorder,
                            color: _recording! ? Colors.grey : Colors
                                .pink,
                            textColor: Colors.white,
                            child: const Icon(Icons.mic, size: 60),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(25),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$_sound',
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline5,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          RaisedButton(
                              color: Colors.red[400],
                              child: const Text(
                                'Reset',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {

                                  await DatabaseService(globaluid.value)
                                      .updateProject1(
                                      projectName,
                                      depthActivated,
                                      false,
                                      photoURL);

                                  setState(() {
                                    activateTrigger.value = false;
                                    hasActivated = false;
                                  });

                              })
                        ],
                      )
                  )
              )
            ]


        ),
      );
    }
    );
    } else {
    return Loading();
    }

    }));
    }
  }
