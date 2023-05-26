import 'package:flutter/material.dart';
import 'package:flutter_airpods/flutter_airpods.dart';
import 'package:flutter_airpods/models/device_motion_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class AirpodsPage extends StatefulWidget {
  const AirpodsPage({super.key, required this.title});

  final String title;

  @override
  State<AirpodsPage> createState() => _AirpodsPageState();
}

class _AirpodsPageState extends State<AirpodsPage> {
  IO.Socket? socket;
  bool connected = false;

  @override
  void initState() {
    print("START");
    socket = IO.io('http://lucass-macbook-air.local:4200/',
        OptionBuilder().setTransports(['websocket']).build());
    socket?.onConnect((_) {
      print('CONNECTED TO SERVER');
      setState(() => connected = true);

      connected = true;
    });
    super.initState();
  }

  void sendDataToServer(DeviceMotionData? data) {
    if (connected) {
      socket?.emit("events", data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Flutter Airpods Transmitter'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: StreamBuilder<DeviceMotionData>(
                stream: FlutterAirpods.getAirPodsDeviceMotionUpdates,
                builder: (BuildContext context,
                    AsyncSnapshot<DeviceMotionData> snapshot) {
                  if (snapshot.hasData) {
                    sendDataToServer(snapshot.data);
                    return Text("${snapshot.data?.toJson()}");
                  } else {
                    return const Text("Waiting for incoming data...");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
