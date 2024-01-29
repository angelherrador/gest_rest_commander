import 'package:flutter/material.dart';
import 'waiters_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../functions/functions.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {

  final controller = PageController();

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  bool isLastPage = false;
  //int pageNumber = 1;
  String vImageUrl='$vApiUrlI/logos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom:80),
          child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 6);
              },
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Bienvenido!',style: TextStyle(fontSize: 30, color: Colors.white))),
                    ),
                    const SizedBox(height: 10,),
                    Image.network('$vImageUrl/logo1.jpg'),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('Dinner Resto es una APP para poder gestionar '
                            'las comandas de su restaurante sin usar papel y bolígrafo. Se acabaron los errores de '
                            'interpretación, de lectura y similares. Clique en Siguiente y vaya avanzando por las pantallas de este'
                            ' tutorial y verá que sencillo y que rápido se podrá familiarizar en el uso de nueva APP.',style: TextStyle(fontSize: 16, color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Camarero y menú',style: TextStyle(fontSize: 30, color: Colors.white))),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho de la pantalla
                        child: const Image(image: AssetImage('assets/tutorial/camareros.jpg'))
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('Esta pantalla permite la selección de camarero una vez introducida'
                            ' la correspondiente contraseña y, a la vez, contiene un menú que permite'
                            ' visionar este tutorial todas las veces que desees. Otra opción importante del menú es '
                            'la gestión de platos, donde podemos definir favoritos, crear nuevos, editar, tomar nuevas imágenes.',style: TextStyle(fontSize: 14, color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Salas y mesas',style: TextStyle(fontSize: 30, color: Colors.white))),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75, // 50% del ancho de la pantalla
                        child: const Image(image: AssetImage('assets/tutorial/sala_mesa.jpg'))
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('Selecciona la Sala  y a continuación la mesa. Las mesas cambian de color para indicar el '
                            'estado, libres /ocupadas.',style: TextStyle(fontSize: 18, color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Familias y Favoritos',style: TextStyle(fontSize: 30, color: Colors.white))),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho de la pantalla
                        child: const Image(image: AssetImage('assets/tutorial/familias.jpg'))
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('La primera fila contiene los platos '
                            'favoritos indicados en Gestión de platos. En la parte central tenemos '
                            'las familias, que mostrarán los platos, y a continuación 3 accesos a '
                            'los destinos indicados: Salas, Mesas, Comanda. ',style: TextStyle(fontSize: 18, color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Platos',style: TextStyle(fontSize: 30, color: Colors.white))),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho de la pantalla
                        child: const Image(image: AssetImage('assets/tutorial/platos.jpg'))
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('Se muestran los platos correspondientes a la familia seleccionada '
                            'en la pantalla anterior. Simplemente selecciona el plato clicando las veces '
                            'necesarias. ',style: TextStyle(fontSize: 18, color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Comanda',style: TextStyle(fontSize: 30, color: Colors.white))),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65, // 50% del ancho de la pantalla
                        child: const Image(image: AssetImage('assets/tutorial/comanda.jpg'))
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('Revisa la comanda realizada. Incluso '
                            'puedes aumentar o disminuir las cantidades aplicadas. Si dejas una cantidad a 0 el '
                            'plato se ELIMINARÁ.  ',style: TextStyle(fontSize: 18, color: Colors.black))),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Gestión Platos',style: TextStyle(fontSize: 30, color: Colors.white))),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho de la pantalla
                        child: const Image(image: AssetImage('assets/tutorial/gestion_platos.jpg'))
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('Cambia el estado de Favorito de los platos, para que se muestre o no '
                            'en Familias. Añade nuevos platos a la familia FOGONES. Clicando en la '
                            'foto cámbiala por otra de la galería de tu dispositivo.  ',style: TextStyle(fontSize: 18, color: Colors.black))),
                      ),
                    ),
                  ],
                ),
              ]
          ),
        ),
      ),
      bottomSheet: isLastPage ? TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2)),
            backgroundColor: Colors.blue,
            minimumSize: const Size.fromHeight(80),
          ),
          onPressed: () async{
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('showHome', true);
            if (!context.mounted) return;
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WaiterPage()));
          },
          child: const Text('Comenzar...', style: TextStyle(fontSize: 24),)
      ) :
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () => controller.jumpToPage(6),
                child: const Text('Saltar',style: TextStyle(fontSize: 18),)),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 7,
                effect: const WormEffect(
                  spacing: 10,
                  dotColor: Colors.black87,
                  activeDotColor: Colors.indigo,
                ),
                onDotClicked: (index) {
                  controller.animateToPage(
                      index,
                      duration: const Duration
                        (milliseconds: 500) ,
                      curve: Curves.easeInOut);},
              ),
            ),
            TextButton(
                onPressed: () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 500) ,
                      curve: Curves.easeInOut);},
                child: const Text('Siguiente',style: TextStyle(fontSize: 18),)),
          ],
        ),
      ),
    );
  }
}
