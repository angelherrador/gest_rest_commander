import 'dart:async';
import 'dart:convert';
import 'package:gest_rest/screens/room_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WaiterPage extends StatefulWidget {
  const WaiterPage({super.key});

  @override
  State<WaiterPage> createState() => _WaiterPageState();
}

class _WaiterPageState extends State<WaiterPage> {

  List list = [];
  String vApiUrl = "https://herradormartinez.es/gestrest/api_gestrest/waiters";
  String vImageUrl="https://herradormartinez.es/gestrest/images/waiters";

  Future readData() async {
    var vFile="readData.php";
    var url = "$vApiUrl/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        list.addAll(redX);
        _streamController.add(redX);
      });
      //print(list);
    }
  }

  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _streamController = StreamController();
      _stream = _streamController.stream;
    });

    getData();
  }

  getData() async {
    await readData();
  }


  @override
  Widget build(BuildContext context) {
    var imageWidth =
        MediaQuery.of(context).size.width *0.25; //% del ancho de pantalla
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Selección de camarero'),
          centerTitle: true,
        ),
        body:
        StreamBuilder<List<dynamic>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(

                      title: Text(snapshot.data![index]['name'],style: const TextStyle(fontSize: 16),),
                      //subtitle: Text(snapshot.data![index]['image']),
                      subtitle: const Text(" "),
                      leading: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RoomPage()));
                          },
                          child:
                          //Image.network('${vImageUrl}/${snapshot.data![index]['image']}',width: imageWidth)
                        CircleAvatar(
                          radius: 40,
                          foregroundImage: snapshot.data![index]['image'] == "" ? null : NetworkImage('${vImageUrl}/${snapshot.data![index]['image']}'),
                          // child: Text(snapshot.data![index]['name']
                          //     .toString()
                          //     .substring(0, 2)
                          //     .toUpperCase()),
                        ),
                      ),
                    );
                  });
            }else if(snapshot.hasError){
              return const Center(child: Text('Se ha producido un error. No hay datos disponibles !!!'));
            }
            //return const Center(child: Text("Server Error!!!"));
            return const Center(child: CircularProgressIndicator());
          }, // builder:
        )
    );
  }
}
