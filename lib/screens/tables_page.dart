import 'dart:async';
import 'dart:convert';
import 'package:gest_rest/screens/families_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key, required this.idWaiter, required this.idRoom});

  final String idWaiter;
  final String idRoom;


  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {

  List list = [];
  String vApiUrl = "https://herradormartinez.es/gestrest/api_gestrest/tables";
  String vImageUrl="https://herradormartinez.es/gestrest/images/tables";

  Future readData(vRoom) async {
    //vRoom=3;
    var vFile="readData.php?idRoom=$vRoom";
    var url = "$vApiUrl/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        list.addAll(redX);
        _streamController.add(redX);
      });
      print(list);
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

    getData(widget.idRoom);
  }


  getData(vRoom) async {
    await readData(vRoom);
  }

  @override
  Widget build(BuildContext context) {
    var imageWidth =
        MediaQuery.of(context).size.width *0.25; //% del ancho de pantalla
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Selección de mesa: ${widget.idWaiter} - ${widget.idRoom}'),
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
                      title: Text(snapshot.data![index]['number'],style: const TextStyle(fontSize: 16),),
                      //subtitle: Text(snapshot.data![index]['image']),
                      subtitle: const Text(" "),
                      leading: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FamilyPage(
                                          idWaiter : widget.idWaiter,
                                          idTable : snapshot.data![index]['number'],
                                        )
                                )
                            );
                          },
                          child:
                          Image.network('$vImageUrl/${snapshot.data![index]['image']}',width: imageWidth)
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
