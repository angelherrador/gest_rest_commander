import 'package:flutter/material.dart';
import '../functions/functions.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommandPage extends StatefulWidget {
  const CommandPage({super.key, required this.idWaiter, required this.idTable});

  final String idWaiter;
  final String idTable;

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {

  int vQuantity = 0;
  List list = [];
  String vApiUrl = '$vApiUrlP/commander';
  String vImageUrl='$vApiUrlI/dishes';

  Future readData(idTable) async {
    var vFile="readData.php?idTable=$idTable";
    var url = "$vApiUrl/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        list.addAll(redX);
        _streamController.add(redX);
      });
    }
  }

  Future updateQuantity(tableNumber,idDish,quantity) async{
    var vFile="updateQuantity.php";
    var url = "$vApiUrl/$vFile";
    var res = await http.post(Uri.parse(url), body: {
      'tableNumber': tableNumber,
      'idDish': idDish,
      'quantity': quantity,
    });

    if (res.statusCode == 200){
      getData();
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
    await readData(widget.idTable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: Text('Mesa ${widget.idTable}'),
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
                      subtitle: Text(snapshot.data![index]['modifiers']),
                      leading: InkWell(
                        onTap: (){
                        },
                        child:
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                              image:  DecorationImage(
                                image: NetworkImage('$vImageUrl/${snapshot.data![index]['directory']}/${snapshot.data![index]['image']}'),
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
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              vQuantity++;
                              await updateQuantity(widget.idTable, snapshot.data![index]['idDish'], '1');
                              await getData();
                            },
                            icon: const Icon(
                              Icons.add_circle_outlined,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                          ),
                          // Text(snapshot.data![index]['quantity'],style: const TextStyle(fontSize: 16),),
                          Text(snapshot.data![index]['quantity'],style: const TextStyle(fontSize: 16),),
                          IconButton(
                            onPressed: () async {
                              vQuantity--;
                              await updateQuantity(widget.idTable, snapshot.data![index]['idDish'], '-1');
                              await getData();
                            },
                            icon: const Icon(
                              Icons.remove_circle_outlined,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }else if(snapshot.hasError){
              return const Center(child: Text('Se ha producido un error. No hay datos disponibles !!!'));
            }
            return const Center(child: Text("Sin comanda añadida!!!"));
          }, // builder:
        )
    );
  }
}
