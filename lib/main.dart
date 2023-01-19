import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
  });

  @override
  MyHomePageState createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();
  late Socket socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    try {
      socket =
          io('http://52.76.62.147:9000/api/companies/socket', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'withCredentials': true,
        'auth': {"room_id": "63a5a3b6a296ec777c2c40b1"}
      });
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('roomstatus', handleLocationListen);
      // socket.on('typing', handleTyping);
      // socket.on('message', handleMessage);
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Socket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: new TextFormField(
                decoration: new InputDecoration(labelText: "Send any message"),
                controller: editingController,
              ),
            ),
            // StreamBuilder(
            //   stream: socket.stream,
            //   builder: (context, snapshot) {
            //     return Padding(
            //       padding: const EdgeInsets.all(20.0),
            //       child: Text(snapshot.hasData
            //           ? '${snapshot.data}'
            //           : ' there is noo data'),
            //     );
            //   },
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: _sendMessage,
      ),
    );
  }

  void _sendMessage() {
    socket.emit(
      "chat message",
      {
        "id": socket.id,
        "message": editingController.text, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  handleLocationListen(dynamic data) async {
    print(data);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
