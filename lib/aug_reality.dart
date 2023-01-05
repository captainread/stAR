import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class AugReality extends StatefulWidget {
  const AugReality({Key? key}) : super(key: key);

  @override
  State<AugReality> createState() => _AugRealityState();
}

class _AugRealityState extends State<AugReality> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager? arAnchorManager;

  // End drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  ARNode? webObjectNode;
  ARNode? webObjectNode2;
  ARNode? webObjectNode3;
  ARNode? webObjectNode4;
  ARNode? webObjectNode5;
  ARNode? webObjectNode6;
  ARNode? webObjectNode7;
  ARNode? webObjectNode8;

  List<ARAnchor> anchors = [];
  List<ARNode> nodes = [];

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text('stAR.',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "MartianMono",
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig:
                      PlaneDetectionConfig.horizontalAndVertical,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.help),
                  label: Text(
                    'Instructions',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "MartianMono",
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                        'AR Instructions',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold),
                      ),
                      content: Wrap(children: [
                        Text(
                            'Please pan your camera around until planes (flat surfaces) have been detected around you. These are indicated by dotted fields.\n\nUse the right-hand menu to add 3D models to the scene. Some models will be placed for you. Others can be placed by tapping on the planes.\n\nTo rotate, tap the placed model - you will see a selection circle. Then press both thumbs (or two fingers) to the screen and swirl them clockwise or anti-clockwise.'),
                        Image.asset('assets/images/rotate.png'),
                      ]),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text(
                            'OK',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.menu),
                  label: Text(
                    'AR menu',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "MartianMono",
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: _openEndDrawer,
                ),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text('Add 3D models to your scene.',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "MartianMono",
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: Text(
                  'Press the + buttons to add models to the scene.\n\nPlease wait a moment for your model to load. This menu will close once it has loaded.'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addMoon(),
              ),
              title: Text('Add Moon'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addStarsChart(),
              ),
              title: Text('Add Star Chart'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addHubble(),
              ),
              title: Text('Add Hubble Telescope'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addEarth(),
              ),
              title: Text('Add Earth'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addMars(),
              ),
              title: Text('Add Mars'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addVenus(),
              ),
              title: Text('Add Venus'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addJupiter(),
              ),
              title: Text('Add Jupiter'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.layers_clear_outlined),
                onPressed: () => onRemoveEverything(),
              ),
              title: Text('Remove model(s)'),
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: false,
          handlePans: false,
          handleRotation: true,
        );
    this.arObjectManager.onInitialize();

    // this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onRotationStart = onRotationStarted;
    this.arObjectManager.onRotationChange = onRotationChanged;
    this.arObjectManager.onRotationEnd = onRotationEnded;
  }

  Future<void> addMoon() async {
    if (webObjectNode != null) {
      _closeEndDrawer();
    }
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    }
    if (webObjectNode3 != null) {
      arObjectManager.removeNode(webObjectNode3!);
      webObjectNode3 = null;
    }
    if (webObjectNode4 != null) {
      arObjectManager.removeNode(webObjectNode4!);
      webObjectNode4 = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/the_moon_sharp.glb?raw=true",
        position: Vector3(0.0, 0.0, -0.2),
        scale: Vector3(0.2, 0.2, 0.2));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addHubble() async {
    if (webObjectNode2 != null) {
      _closeEndDrawer();
    }
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }
    if (webObjectNode3 != null) {
      arObjectManager.removeNode(webObjectNode3!);
      webObjectNode3 = null;
    }
    if (webObjectNode4 != null) {
      arObjectManager.removeNode(webObjectNode4!);
      webObjectNode4 = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/Hubble.glb?raw=true",
        position: Vector3(0.0, 0.0, -0.2),
        scale: Vector3(0.2, 0.2, 0.2));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode2 = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addEarth() async {
    if (webObjectNode3 != null) {
      _closeEndDrawer();
    }
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    }
    if (webObjectNode4 != null) {
      arObjectManager.removeNode(webObjectNode4!);
      webObjectNode4 = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/Earth4k.glb?raw=true",
        position: Vector3(0.0, -0.0, -0.2),
        scale: Vector3(0.2, 0.2, 0.2));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode3 = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addStarsChart() async {
    if (webObjectNode4 != null) {
      _closeEndDrawer();
    }
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    }
    if (webObjectNode3 != null) {
      arObjectManager.removeNode(webObjectNode3!);
      webObjectNode3 = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/sondos-ahmed/glb-assets/blob/main/noDimantionStarChart.glb?raw=true",
        position: Vector3(0.0, 0.0, -0.2),
        scale: Vector3(0.15, 0.15, 0.15));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addMars() async {
    if (webObjectNode5 != null) {
      _closeEndDrawer();
    }
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    }
    if (webObjectNode3 != null) {
      arObjectManager.removeNode(webObjectNode3!);
      webObjectNode3 = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/mars.glb?raw=true",
        position: Vector3(0.0, 0.0, -0.2),
        scale: Vector3(0.2, 0.2, 0.2));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addVenus() async {
    if (webObjectNode5 != null) {
      _closeEndDrawer();
    }
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    }
    if (webObjectNode3 != null) {
      arObjectManager.removeNode(webObjectNode3!);
      webObjectNode3 = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/venus.glb?raw=true",
        position: Vector3(0.0, 0.0, -0.2),
        scale: Vector3(0.2, 0.2, 0.2));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addJupiter() async {
    if (webObjectNode5 != null) {
      _closeEndDrawer();
    }
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    }
    if (webObjectNode3 != null) {
      arObjectManager.removeNode(webObjectNode3!);
      webObjectNode3 = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/jupiter.glb?raw=true",
        position: Vector3(0.0, 0.0, -0.2),
        scale: Vector3(0.2, 0.2, 0.2));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

// handles placing earth on plane where tapped - not sure if we want this feature
  // Future<void> onPlaneOrPointTapped(
  //     List<ARHitTestResult> hitTestResults) async {
  //   var singleHitTestResult = hitTestResults.firstWhere(
  //       (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
  //   if (singleHitTestResult != null) {
  //     var newAnchor =
  //         ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
  //     bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
  //     if (didAddAnchor!) {
  //       this.anchors.add(newAnchor);
  //       var newNode = ARNode(
  //           type: NodeType.webGLB,
  //           uri:
  //               "https://github.com/captainread/test-assets/blob/main/Earth4k.glb?raw=true",
  //           scale: Vector3(0.3, 0.3, 0.3),
  //           position: Vector3(0.0, 0.0, 0.0),
  //           rotation: Vector4(1.0, 0.0, 0.0, 0.0));
  //       bool? didAddNodeToAnchor =
  //           await this.arObjectManager.addNode(newNode, planeAnchor: newAnchor);
  //       if (didAddNodeToAnchor!) {
  //         this.nodes.add(newNode);
  //       } else {
  //         this.arSessionManager.onError("Adding Node to Anchor failed");
  //       }
  //     } else {
  //       this.arSessionManager.onError("Adding Anchor failed");
  //     }
  //   }
  // }

// removes all models
  Future<void> onRemoveEverything() async {
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    }
    if (webObjectNode3 != null) {
      arObjectManager.removeNode(webObjectNode3!);
      webObjectNode3 = null;
    }
    if (webObjectNode4 != null) {
      arObjectManager.removeNode(webObjectNode4!);
      webObjectNode4 = null;
    }
    nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });
    nodes = [];
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
    _closeEndDrawer();
  }

// handles rotating models
  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
  }
}
