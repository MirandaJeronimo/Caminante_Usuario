import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:caminante_appvsc/registro1.dart';
import 'package:caminante_appvsc/sites.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:caminante_appvsc/sites.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA7HQVKRiY1gt-3h0YSVf3oeOlgAn9uJOk", //  ==   current_key in google-services.json file
      appId: "1:1088120227990:android:484db0d5f19170b1ad1ab7", // ==  mobilesdk_app_id  in google-services.json file
      messagingSenderId: "1088120227990", // ==   project_number in google-services.json file
      projectId: "caminante2-aa447", // ==   project_id   in google-services.json file
    ),
  );
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('#FF0080'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            minimumSize: Size(0.85 * MediaQuery.of(context).size.width,
                0.046 * MediaQuery.of(context).size.height),
          ),
        ),
      ),
      routes: {
        '/': (context) => const ImageSliderPage(),
        '/login': (context) => const LoginPage(),
        '/intro': (context) => const IntroPage(),
        '/registro1': (context) => const RegisterScreen(),
        '/sites': (context) => const SitesScreen(),
      },
      initialRoute: '/',
    );
  }
}

class ImageSliderPage extends StatefulWidget {
  const ImageSliderPage({super.key});

  @override
  _ImageSliderPageState createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage> {
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> _imagePaths = [
    'assets/onboarding1.png',
    'assets/onboarding2.png',
    'assets/onboarding3.png',
    'assets/onboarding4.png',
    'assets/onboarding5.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page! >= _imagePaths.length - 1) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const IntroPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _imagePaths.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  _imagePaths[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 0.05 * MediaQuery.of(context).size.height),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _imagePaths.length,
                effect: ScrollingDotsEffect(
                  activeDotColor: HexColor('#8B04F6'),
                  dotColor: Colors.grey,
                  dotHeight: 0.012 * MediaQuery.of(context).size.height,
                  dotWidth: 0.012 * MediaQuery.of(context).size.height,
                  spacing: 0.03 * MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cover.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 0.4 * MediaQuery.of(context).size.width,
                      height: 0.4 * MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                        height: 0.041 * MediaQuery.of(context).size.height),
                    Text(
                      'CAMINANTE',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: HexColor('#FFFFFF'),
                          fontSize: 0.028 * MediaQuery.of(context).size.height,
                          letterSpacing: 4.2,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                        height: 0.592 * MediaQuery.of(context).size.height),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/registro1');
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all<Color>(
                            HexColor('#FF0080')),
                      ),
                      child: Text('Soy Nuevo',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize:
                                  0.015 * MediaQuery.of(context).size.height,
                              fontFamily: 'Montserrat-Regular',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
                    SizedBox(
                        height: 0.0016 * MediaQuery.of(context).size.height),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all(HexColor('#FFFFFF')),

                      ),
                      child: Text('Ingresar',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize:
                                  0.015 * MediaQuery.of(context).size.height,
                              color: HexColor('#FF0080'),
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
                    SizedBox(height: 0.45 * MediaQuery.of(context).size.height),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/cover.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10), // Espacio entre el logo y el texto
              Text('CAMINANTE',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: HexColor('#FFFFFF'),
                      fontSize: 21,
                      height: 2.5,
                      letterSpacing: 4.2,
                    ),
                  )),
              const SizedBox(
                  height:
                      95), // Espacio adicional entre el texto y los demás objetos
              Container(
                width: 350,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: const TextStyle(color: Colors.grey),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 350,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: const TextStyle(color: Colors.grey),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  print('Iniciar Sesión');
                  Navigator.pushReplacementNamed(context, '/sites');
                },
                child: Text(
                  'Iniciar sesión',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('Recuperar Usuario');
                    },
                    child: Text(
                      'Recuperar Usuario',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.white,

                          fontSize: 12, // Tamaño de fuente de 12pt
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      print('Recuperar Contraseña');
                    },
                    child: Text(
                      'Recuperar Contraseña',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.white,

                          fontSize: 12, // Tamaño de fuente de 12pt
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
