import 'dart:async';
import 'dart:convert';
import '../functions/functions.dart';
import 'families_page.dart';
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
  String vApiUrl = '$vApiUrlP/tables';
  String vImageUrl='$vApiUrlI/tables';
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
          foregroundColor: Colors.white,
          title: const Text('Selección de mesa'),
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
                            //occupied table
                            if (snapshot.data![index]['free'] == '1') {
                              await  changeFreeTable(
                                  snapshot.data![index]['number'], snapshot.data![index]['id'], '0', widget.idWaiter);
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

