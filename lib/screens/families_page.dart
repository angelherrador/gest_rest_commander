import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dishes_page.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> families = [
      {
        'id': 1,
        'name': 'Bebidas',
        'image': 'assets/dishes/bebidas/vino_tinto.jpg'
      },
      {
        'id': 2,
        'name': 'Entrantes',
        'image': 'assets/dishes/ensaladas/ensalada_arroz.jpg'
      },
      {'id': 3, 'name': 'Carnes', 'image': 'assets/dishes/carne/escalope.jpg'},
      {
        'id': 4,
        'name': 'Pescado',
        'image': 'assets/dishes/pescado/trucha_patata.jpg'
      },
      {'id': 5, 'name': 'Marisco', 'image': 'assets/dishes/marisco/gambas.jpg'},
      {
        'id': 6,
        'name': 'Postre',
        'image': 'assets/dishes/postres/tarta_queso.jpg'
      },
      {'id': 7, 'name': 'Cafés', 'image': 'assets/dishes/cafe/cafe_negro.jpg'},
      {
        'id': 8,
        'name': 'Bebidas',
        'image': 'assets/dishes/bebidas/vino_tinto.jpg'
      },
      {
        'id': 9,
        'name': 'Entrantes',
        'image': 'assets/dishes/ensaladas/ensalada_arroz.jpg'
      },
      {'id': 10, 'name': 'Carnes', 'image': 'assets/dishes/carne/escalope.jpg'},
      {
        'id': 11,
        'name': 'Pescado',
        'image': 'assets/dishes/pescado/trucha_patata.jpg'
      },
      {
        'id': 12,
        'name': 'Marisco',
        'image': 'assets/dishes/marisco/gambas.jpg'
      },
      {
        'id': 13,
        'name': 'Postre',
        'image': 'assets/dishes/postres/tarta_queso.jpg'
      },
      {'id': 14, 'name': 'Cafés', 'image': 'assets/dishes/cafe/cafe_negro.jpg'},
    ];

    Widget listFavorites = SizedBox(
      height: 60,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildFavorites('Paella', 'assets/dishes/marisco/paella.jpg'),
          _buildFavorites('Mariscos', 'assets/dishes/marisco/gambas.jpg'),
          _buildFavorites(
              'Mejillones', 'assets/dishes/marisco/mejillones_vapor.jpg'),
          _buildFavorites('Paella', 'assets/dishes/marisco/paella.jpg'),
          _buildFavorites('Mariscos', 'assets/dishes/marisco/gambas.jpg'),
          _buildFavorites(
              'Mejillones', 'assets/dishes/marisco/mejillones_vapor.jpg'),
          _buildFavorites('Paella', 'assets/dishes/marisco/paella.jpg'),
          _buildFavorites('Mariscos', 'assets/dishes/marisco/gambas.jpg'),
          _buildFavorites(
              'Mejillones', 'assets/dishes/marisco/mejillones_vapor.jpg'),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text('Favoritos / Familias'),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('showHome', false);
              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const OnBoardingPage()),
              );
            },
            icon: const Icon(Icons.logout),)
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          listFavorites,
          const SizedBox(height: 20,),
          Expanded(
            flex: 4,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // number of items in each row
                mainAxisSpacing: 8.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              padding: const EdgeInsets.all(8.0), // padding around the grid
              itemCount: families.length, // total number of items
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
                          image: DecorationImage(
                            image: AssetImage(families[index]['image']),
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
                                      DishesPage(families[index]['name'])));
                        },
                      ),
                    ),
                    Text(families[index]['name']),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

Builder _buildFavorites(String label, String favoriteImage) {
  return Builder(builder: (context) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      width: 100,
      height: 20,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(favoriteImage),
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
        onTap: ()  {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DishesPage(label)));
        },
      ),
    );
  });
}
