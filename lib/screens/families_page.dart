import 'package:flutter/material.dart';
import 'command_page.dart';
import 'dishes_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../functions/functions.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key, required this.idWaiter, required this.idTable});

  final String idWaiter;
  final String idTable;

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {

  List listFavorites = [];
  List listFamilies = [];
  String vApiUrlFavorites = '$vApiUrlP/dishes';
  String vImageUrl='$vApiUrlI/dishes';
  String vApiUrlFamilies = '$vApiUrlP/families';

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
          return const Center(child: CircularProgressIndicator());
        } //builder
      ),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text('Mesa ${widget.idTable}'),
        centerTitle: true,
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
                      crossAxisCount: 3, // cols
                      mainAxisSpacing: 8.0, // space between rows
                      crossAxisSpacing: 8.0, // space between columns
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
                                    color: Colors.grey,
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
                return const Center(child: CircularProgressIndicator());
              }
            ),
          ),
        ],
      ),
      bottomNavigationBar:
        CommonBottomNavigationBar(
          currentIndex: 0,
          onTap: (index) async {
            if(index==0){
              Navigator.of(context).pop(false);
              Navigator.of(context).pop();
            }else if(index==1){
              Navigator.of(context).pop(true);
            }else if(index==2){
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CommandPage(
                          idWaiter : widget.idWaiter,
                          idTable : widget.idTable,
                        ),
                  )
              );
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
              await changeFreeTable(idTable,'0','1','0');
              if (!context.mounted) return;
              Navigator.of(context).pop(false);
              Navigator.of(context).pop(true);
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
              color: Colors.grey,
              offset: Offset(1.0, 5.0),
              blurRadius: 3.0,
            ),
          ]),
      child: InkWell(
        onTap: ()  async {
          await addCommandDetail(idTable, idDish);

          if (!context.mounted) return;
          PrettySnackBar.show(context, 'Añadido: $label');
        },
      ),
    );
  });
}

Future changeFreeTable(tableNumber,idTable,freeValue,idWaiter) async{
  String vApiUrl = '$vApiUrlP/tables';
  var vFile="changeFree.php";
  var url = "$vApiUrl/$vFile";
  await http.post(Uri.parse(url), body: {
    'tableNumber': tableNumber,
    'idTable': idTable, //take 0 always cos not important
    'freeValue': freeValue,
    'idWaiter': idWaiter, //take 0 always cos not important
  });
}

