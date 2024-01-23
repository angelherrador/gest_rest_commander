import 'dart:async';
import 'dart:convert';
import 'package:gest_rest/screens/tables_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key, required this.idWaiter});

  final String idWaiter;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  List list = [];
  String vApiUrl = "https://herradormartinez.es/gestrest/api_gestrest/rooms";
  String vImageUrl="https://herradormartinez.es/gestrest/images/rooms";

  Future readData() async {
    var vFile="readData.php";
    var url = "$vApiUrl/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      if (!context.mounted) return;
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

    if (!context.mounted) return;
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
    // var imageWidth =
    //     MediaQuery.of(context).size.width *0.25; //% del ancho de pantalla
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: const Text('Selección de Sala'),
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
                      title: Text(snapshot.data![index]['name'],style: const TextStyle(fontSize: 26),),
                      //subtitle: Text(snapshot.data![index]['image']),
                      subtitle: const Text(" "),
                      leading: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) =>
                              TablePage(
                                idWaiter : widget.idWaiter,
                                idRoom: snapshot.data![index]['id']
                              )));
                        },
                        child:
                          //Image.network('$vImageUrl/${snapshot.data![index]['image']}',width: imageWidth))
                          Container(
                              width: 120,
                              height: 120,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0),
                                  image:  DecorationImage(
                                    image: NetworkImage('$vImageUrl/${snapshot.data![index]['image']}'),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey, //Color(0xffA4A4A4),
                                      offset: Offset(1.0, 5.0),
                                      blurRadius: 3.0,
                                    ),
                                  ]),
                          ),
                      ),);
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