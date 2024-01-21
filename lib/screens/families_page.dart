import 'package:flutter/material.dart';
import 'dishes_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../functions/functions.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key, required this.idWaiter, required this.idTable});

  final String idWaiter;
  final String idTable;
  //final String numCommander;

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {


  List listFavorites = [];
  List listFamilies = [];
  String vApiUrlFavorites = "https://herradormartinez.es/gestrest/api_gestrest/dishes";
  String vImageUrl="https://herradormartinez.es/gestrest/images/dishes";
  String vApiUrlFamilies = "https://herradormartinez.es/gestrest/api_gestrest/families";

  Future readDataFavorites() async {
    var vFile="readDataFavorites.php";
    var url = "$vApiUrlFavorites/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        listFavorites.addAll(redX);
        _streamController.add(redX);
      });
      //print(listFavorites);
    }
  }
  Future readDataFamilies() async {
    var vFile="readData.php";
    var url = "$vApiUrlFamilies/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        listFamilies.addAll(redX);
        _streamControllerFamilies.add(redX);
      });
      //print(listFamilies);
    }
  }

  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;

  late StreamController<List<dynamic>> _streamControllerFamilies;
  late Stream<List<dynamic>> _streamFamilies;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _streamController = StreamController();
      _stream = _streamController.stream;

      _streamControllerFamilies = StreamController();
      _streamFamilies = _streamControllerFamilies.stream;
    });

    getDataFavorites();
    getDataFamilies();
  }


  getDataFavorites() async {
    await readDataFavorites();
  }

  getDataFamilies() async {
    await readDataFamilies();
  }

  @override
  Widget build(BuildContext context) {

    Widget listFavorites = SizedBox(
      height: 80,
      child: StreamBuilder<List<dynamic>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
              //children: <Widget>[
                return
                  _buildFavorites(snapshot.data![index]['name'],
                      '$vImageUrl/${snapshot.data![index]['directory']}/${snapshot.data![index]['image']}',
                      widget.idTable,
                      snapshot.data![index]['id']);
              },
            );
          }else if(snapshot.hasError){
            return const Center(child: Text('Se ha producido un error. No hay datos disponibles !!!'));
          }
          return const Center(child: Text('Sin Favoritos!!'));
        } //builder
      ),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text('Mesa ${widget.idTable}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Vaciar mesa',
            onPressed: () {
              emptyTable(context,widget.idTable);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          listFavorites,
          const SizedBox(height: 5,),
          Expanded(
            //flex: 2,
            child: StreamBuilder<List<dynamic>>(
              stream: _streamFamilies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                    return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0, // spacing between columns
                    ),
                    padding: const EdgeInsets.all(8.0), // padding around the grid
                    itemCount: snapshot.data!.length, //families.length, // total number of items
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: 120,
                            height: 100,
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
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DishesPage(
                                                idWaiter : widget.idWaiter,
                                                idTable: widget.idTable,
                                                idFamily: snapshot.data![index]['id'],
                                                nameFamily: snapshot.data![index]['name'],
                                            )));
                              },
                            ),
                          ),
                          Text(snapshot.data![index]['name'], style: const TextStyle(color: Colors.white,
                            fontSize: 14, fontWeight: FontWeight.bold,)),
                        ],
                      );
                    },
                  );
                }else if(snapshot.hasError){
                  return const Center(child: Text('Se ha producido un error. No hay datos disponibles !!!'));
                }
                return const Center(child: Text("Sin datos!!!"));
                //return const Center(child: CircularProgressIndicator());
              }
            ),
          ),
        ],
      ),
      bottomNavigationBar:
        // Container(
        //     height: 233,
        //     decoration: const BoxDecoration(color: Colors.indigo),
        //     child: Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Column(
        //         children: [
        //           Row(
        //             children: [
        //               Text(
        //                 'ültimo plato: ',
        //                 style: GoogleFonts.actor(
        //                     fontSize: 20,
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.w700),
        //               ),
        //               Text('$cant')
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        // ),
      CommonBottomNavigationBar(
        currentIndex: 0, // Índice seleccionado para esta página
        onTap: (index) {
          if(index==0){
            //Navigator.popUntil(context, ModalRoute.withName('/room_page.dart'));
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          }
        },
      ),
    );
  }
}

Future<void> emptyTable(BuildContext context, idTable) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Vaciar mesa'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content:  const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Confirma que deseas vaciar la mesa'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Sí'),
            onPressed: () async {
              changeFreeTable(idTable,'0','1','0');
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


Builder _buildFavorites(String label, String favoriteImage, idTable, idDish) {
  //int cant = 1;
  return Builder(builder: (context) {
    return Container(
      margin: const EdgeInsets.only(right: 5.0),
      width: 100,
      height: 80,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(favoriteImage),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, //Color(0xffA4A4A4),
              offset: Offset(1.0, 5.0),
              blurRadius: 3.0,
            ),
          ]),
      child: InkWell(
        onTap: ()  async {
          await addCommandDetail(idTable, idDish);
          final snackBar = SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Añadido: $label'),
                IconButton(
                  onPressed: (){
                  },
                  icon: const Icon(
                    Icons.add_circle_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
            showCloseIcon: true,
            width: 400,
            // action: SnackBarAction(
            //   label: '+',
            //   onPressed: () {
            //     // Some code to undo the change.
            //   },),
          );
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  });
}

Future changeFreeTable(tableNumber,idTable,freeValue,idWaiter) async{
  String vApiUrl = "https://herradormartinez.es/gestrest/api_gestrest/tables";
  var vFile="changeFree.php";
  var url = "$vApiUrl/$vFile";
  await http.post(Uri.parse(url), body: {
    'tableNumber': tableNumber,
    'idTable': idTable, //take 0 always cos not important
    'freeValue': freeValue,
    'idWaiter': idWaiter, //take 0 always cos not important
  });
}

