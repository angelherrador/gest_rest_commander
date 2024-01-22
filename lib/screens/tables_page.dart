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

  Future<void> refreshPage() async{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => widget));
  }

  List listCommander = [];
  List list = [];
  String vApiUrl = "https://herradormartinez.es/gestrest/api_gestrest/tables";
  String vImageUrl="https://herradormartinez.es/gestrest/images/tables";
  late String numCommander;

  Future readData(vRoom) async {
    var vFile="readData.php?idRoom=$vRoom";
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

  Future changeFreeTable(tableNumber,idTable,freeValue,idWaiter) async{
    var vFile="changeFree.php";
    var url = "$vApiUrl/$vFile";
    var res = await http.post(Uri.parse(url), body: {
      'tableNumber': tableNumber,
      'idTable': idTable,
      'freeValue': freeValue,
      'idWaiter' : idWaiter,
    });

    if (res.statusCode == 200){
      //var redX = jsonDecode(res.body);
      //print(redX);
      getData(widget.idRoom);
    }

    // final snackBar = SnackBar(
    //   content: Text('Cambio!: $tableNumber'),
    //   behavior: SnackBarBehavior.floating,
    //   duration: const Duration(seconds: 5),
    //   showCloseIcon: true,
    //   width: 400,
    // );
    // if (!context.mounted) return;
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future addCommand(tableNumber,idTable,idWaiter) async{
    var vFile="addCommand.php";
    var url = "https://herradormartinez.es/gestrest/api_gestrest/commander/$vFile";
    await http.post(Uri.parse(url), body: {
      'tableNumber': tableNumber,
      'idTable': idTable,
      'idWaiter' : idWaiter,
    });
  }

  Future readNumCommander() async {
    var vFile="numCommander.php";
    var url = "https://herradormartinez.es/gestrest/api_gestrest/commander/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);
      setState(() {
        listCommander.addAll(redX);
        numCommander=listCommander[0];
      });
      //print(listCommander[0]);

    }

    // var snackBar = SnackBar(
    //   content: Text('Comanda: $numCommander'),
    // );
    // if (!context.mounted) return;
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // number of items in each row
                  mainAxisSpacing: 2.0, // spacing between rows
                  crossAxisSpacing: 4.0, // spacing between columns
                ),
                padding: const EdgeInsets.all(20.0), // padding around the grid
                itemCount: snapshot.data!.length, //families.length, // total number of items
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: 140,
                        height: 70,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            // color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                            image:  DecorationImage(
                              image: snapshot.data![index]['free']=='1' ?
                              NetworkImage('$vImageUrl/${snapshot.data![index]['image']}') :
                              NetworkImage('$vImageUrl/1${snapshot.data![index]['image']}') ,

                              fit: BoxFit.contain,
                            ),
                            // boxShadow: const [
                            //   BoxShadow(
                            //     color: Colors.grey, //Color(0xffA4A4A4),
                            //     offset: Offset(1.0, 5.0),
                            //     blurRadius: 3.0,
                            //   ),
                            // ]
                        ),
                        child: InkWell(
                          onTap: () async {
                            //await readNumCommander();
                            //occupied table
                            if (snapshot.data![index]['free'] == '1') {
                              await  changeFreeTable(
                                  snapshot.data![index]['number'], snapshot.data![index]['id'], '0', widget.idWaiter);
                              // await addCommand(
                              //     snapshot.data![index]['number'], snapshot.data![index]['id'],widget.idWaiter);
                            }
                            if (!context.mounted) return;
                            var refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FamilyPage(
                                          idWaiter : widget.idWaiter,
                                          idTable : snapshot.data![index]['number'],
                                          ),
                                )
                            );
                            if (refresh == true) {
                              await getData(widget.idRoom);
                            }
                            //await readData(widget.idRoom); //refreshPage();
                          },
                        ),
                      ),
                      //Text('${snapshot.data![index]['number']} / ${snapshot.data![index]['free']}',style: const TextStyle(fontSize: 25),),
                      Text('${snapshot.data![index]['number']}', style: const TextStyle(fontSize: 25),),
                    ],
                  );
                },
              );
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

