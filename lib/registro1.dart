import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';


class UserInfo {
  String pais = '';
  String telefono = '';
  String codigoConfirmacion = '';
  String nombre = '';
  String apellidos = '';
  String fechaNacimiento = '';
  String lugar = '';
  String tipoDocumento = '';
  String numeroDocumento = '';
  List<String> hobbies = [];
}

class ProgressBarPainter extends CustomPainter {
  final double percent;
  final Color colorProgress;
  final double borderWidth;

  ProgressBarPainter({
    required this.percent,
    required this.colorProgress,
    required this.borderWidth,
    required HexColor colorBackgroundIcon,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dibuja el fondo de la barra con bordes redondeados
    final backgroundPaint = Paint()
      ..color = Colors.white // Color del fondo
      ..style = PaintingStyle.fill;
    final backgroundRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Calcula el ancho de la barra de progreso
    final progressWidth = size.width * percent;
    final progressRect = RRect.fromRectAndRadius(
      Offset.zero & Size(progressWidth, size.height),
      Radius.circular(size.height / 2),
    );

    // Dibuja la barra de progreso
    final progressPaint = Paint()
      ..color = colorProgress
      ..style = PaintingStyle.fill;
    canvas.drawRRect(progressRect, progressPaint);

    // Dibuja el borde de la barra con bordes redondeados
    final borderPaint = Paint()
      ..color = Colors.white // Color del borde
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    final borderRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(borderRect, borderPaint);

    // Dibuja el porcentaje en el centro de la barra
    final textSpan = TextSpan(
      text: '${(percent * 100).toStringAsFixed(0)}%',
      style: GoogleFonts.montserrat(
        fontSize: 17,
        color: Colors.black,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width);

    final textLeft = (size.width - textPainter.width) / 2;
    final textTop = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textLeft, textTop));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('#FF0080'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            minimumSize: const Size(340, 50),
          ),
        ),
      ),
      home: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserInfo _userInfo = UserInfo();
  int _currentStep = 7;
  final int _totalSteps = 7;

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _continuePressed() {
    if (_currentStep == _totalSteps - 1) {
      // Aquí, realiza la navegación final después de completar todos los pasos
      Navigator.of(context).pushReplacementNamed('/intro');
    } else {
      // Realiza otras acciones necesarias para avanzar al siguiente paso
      setState(() {
        _currentStep += 1;
      });
    }
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return CountryPhoneNumberForm(
          userInfo: _userInfo,
          onNext: _continuePressed,
        );
      case 1:
        return ConfirmationCodeForm(
          userInfo: _userInfo,
          onNext: _continuePressed,
        );
      case 2:
        return NameBirthdayForm(
          userInfo: _userInfo,
          onNext: _continuePressed,
        );
      case 3:
        return LocationForm(
          userInfo: _userInfo,
          onNext: _continuePressed,
        );
      case 4:
        return DocumentForm(
          userInfo: _userInfo,
          onNext: _continuePressed,
        );
      case 5:
        return HobbiesForm(
          userInfo: _userInfo,
          onNext: _continuePressed,
        );
      default:
        return const EndRegistro();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = ((_currentStep + 1) / _totalSteps) * 100;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoregistro.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: HexColor('#FFFFFF'),
                  onPressed: () {
                    //Navigator.pop(context);
                    _prevStep(); // Navegar de regreso a IntroPage
                  },
                ),
                Text('Registro',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: HexColor('#FFFFFF'),
                        fontSize: 17,
                        height: 1,
                      ),
                    )),
                const SizedBox(height: 20), // Espacio entre el botón y el texto
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350, // Ajusta el ancho de la barra
              height: 37, // Ajusta la altura de la barra
              child: CustomPaint(
                size: const Size(350, 37), // Ajusta el tamaño de la barra
                painter: ProgressBarPainter(
                  percent: progressPercentage /
                      100, // Asegúrate de que el valor esté en el rango 0-1
                  colorProgress: HexColor('#FF0080'), // Color de progreso
                  colorBackgroundIcon: HexColor('#FFFFFF'), // Color de fondo
                  borderWidth: 5, // Ancho del borde
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildStepContent(_currentStep),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _currentStep == _totalSteps - 1
          ? null
          : BottomAppBar(
              color: HexColor('#ae1b72'),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: _continuePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#FFFFFF'),
                  ),
                  child: Text(
                    'Continuar',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: HexColor('#FF0080')),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class CountryPhoneNumberForm extends StatelessWidget {
  final UserInfo userInfo;
  final Function onNext;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  CountryPhoneNumberForm({super.key, required this.userInfo, required this.onNext});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Text('Bienvenido al Caminante',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w800,
                color: HexColor('#FFFFFF'),
              ),
            )),
        SizedBox(height: screenHeight * 0.025),
        Text('Vincula tu número celular con tu \n cuenta Caminante',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w400,
                color: HexColor('#FFFFFF'),
              ),
            )),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
          width: screenWidth * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // TextField para agregar el país
              SizedBox(
                height: screenHeight * 0.05,
                child: TextField(
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  controller: countryController,
                  decoration: InputDecoration(
                    labelText: '    Colombia',
                    labelStyle: TextStyle(
                      color: HexColor('#929292'),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    // Puedes manejar la entrada del país aquí
                  },
                ),
              ),
              const SizedBox(height: 10), // Espacio entre los TextFields
              // Row para agregar el número de teléfono junto con el código del país
              Row(
                children: [
                  // TextField para agregar el código del país
                  SizedBox(
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.05,
                    child: TextField(
                      controller: countryCodeController,
                      decoration: InputDecoration(
                        labelText: ' +57',
                        labelStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: HexColor('#929292'),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Puedes manejar la entrada del código del país aquí
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // Espacio entre los TextFields
                  // TextField para agregar el número de teléfono
                  Expanded(
                    child: SizedBox(
                      height: screenHeight * 0.05,
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          labelText: '   Phone Number',
                          labelStyle: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: HexColor('#929292'),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          // Puedes manejar la entrada del número de teléfono aquí
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.0125),
      ],
    );
  }
}

class ConfirmationCodeForm extends StatelessWidget {
  final UserInfo userInfo;
  final Function onNext;

  const ConfirmationCodeForm({super.key, required this.userInfo, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.start, // Centra el contenido verticalmente
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Text(
            'Escribe el código de confirmación',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: HexColor('#FFFFFF'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30), // Ajusta el espacio vertical
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: PinInputTextField(
            pinLength: 4,
            decoration: BoxLooseDecoration(
              strokeColorBuilder: PinListenColorBuilder(
                  HexColor('#FFFFFF'), HexColor('#FFFFFF')),
              bgColorBuilder: PinListenColorBuilder(
                  HexColor('#FFFFFF'), HexColor('#FFFFFF')),
              strokeWidth: 2,
              gapSpace: 10, // Ajusta el espacio entre los cuadros
              radius: const Radius.circular(30), // Ajusta el radio de los bordes
              textStyle: TextStyle(
                color: HexColor('#FF0080'),
                fontSize: 16, // Ajusta el tamaño de la fuente
                fontWeight: FontWeight.bold,
                // Agrega esta línea para cambiar la fuente
              ),
            ),
            onChanged: (value) {
              userInfo.codigoConfirmacion = value;
              if (value.length == 4) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        ),
        const SizedBox(height: 20), // Ajusta el espacio vertical
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Text(
            'Enviaremos un mensaje a este número con un código de confirmación.',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HexColor('#FFFFFF'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NameBirthdayForm extends StatelessWidget {
  final UserInfo userInfo;
  final Function onNext;

  const NameBirthdayForm({super.key, required this.userInfo, required this.onNext});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Padding(
          padding: EdgeInsets.only(left: screenHeight * 0.05),
          child: Text(
            'Cuéntanos un poco de ti',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: screenHeight * 0.027,
                color: HexColor('#FFFFFF'),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: EdgeInsets.only(left: screenHeight * 0.05),
          child: Text(
            '¿Cómo te llamamos?',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenHeight * 0.014,
                color: HexColor('#FFFFFF'),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        Container(
          width: screenHeight * 0.42,
          height: screenHeight * 0.05,
          padding: EdgeInsets.only(left: screenHeight * 0.05),
          child: TextField(
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w400,
              ),
            ),
            onChanged: (value) {
              userInfo.nombre = value;
            },
            decoration: InputDecoration(
              labelText: 'Nombres',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenHeight * 0.04),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.012),
        Container(
          width: screenHeight * 0.42,
          height: screenHeight * 0.05,
          padding: EdgeInsets.only(left: screenHeight * 0.05),
          child: TextField(
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w400,
              ),
            ),
            onChanged: (value) {
              userInfo.apellidos = value;
            },
            decoration: InputDecoration(
              labelText: 'Apellidos',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenHeight * 0.04),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        Padding(
          padding: EdgeInsets.only(left: screenHeight * 0.05),
          child: Text(
            '¿Cuándo es tu cumpleaños?',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenHeight * 0.014,
                color: HexColor('#FFFFFF'),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        Padding(
          padding: EdgeInsets.only(left: screenHeight * 0.05),
          child: Center(
            child: DateOfBirthInput(
              onDateSubmitted: (date) {
                userInfo.fechaNacimiento = date;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class EndRegistro extends StatelessWidget {
  const EndRegistro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoregistro.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 1),
              Text(
                '¡Excelente!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: HexColor('#FFFFFF'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Ya has completado toda tu información de registro',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#FFFFFF'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/sites');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#FFFFFF'), // Cambiar el color del botón a blanco
                ),
                child: Text('Continuar',
                    style: TextStyle(color: HexColor('#FF0080'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateOfBirthInput extends StatefulWidget {
  final Function(String) onDateSubmitted;

  const DateOfBirthInput({super.key, required this.onDateSubmitted});

  @override
  _DateOfBirthInputState createState() => _DateOfBirthInputState();
}

class _DateOfBirthInputState extends State<DateOfBirthInput> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 40, // Ancho para el día
          child: TextField(
            controller: _dayController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Día',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10), // Espacio entre los campos
        SizedBox(
          width: 100,
          height: 40, // Ancho para el mes
          child: TextField(
            controller: _monthController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Mes',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10), // Espacio entre los campos
        SizedBox(
          width: 100,
          height: 40, // Ancho para el año
          child: TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Año',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _validateDate() {
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day == null || month == null || year == null) {
      // Al menos un campo es inválidodart --ddd
      return;
    }

    if (day <= 0 || day > 31 || month <= 0 || month > 12) {
      // Día o mes fuera de rango
      return;
    }

    final currentDate = DateTime.now();
    final age = currentDate.year - year;

    if (age < 18) {
      // El usuario debe ser mayor de 18 años
      return;
    }

    widget.onDateSubmitted(
        '${_dayController.text}/${_monthController.text}/${_yearController.text}');
  }
}

class LocationForm extends StatelessWidget {
  final UserInfo userInfo;
  final Function onNext;

  const LocationForm({super.key, required this.userInfo, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinea el contenido a la izquierda
      children: [
        const SizedBox(
            height: 29), // Espacio de 29 unidades desde la barra de progreso

        Text(
          '¿De dónde eres?',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color:
                  HexColor('#FFFFFF'), // Establece el color de texto en blanco
            ),
          ),
        ),

        const SizedBox(height: 32), // Espacio de 32 unidades desde el texto

        SizedBox(
          width: 350,
          child: TextField(
            onChanged: (value) {
              userInfo.lugar = value;
            },
            decoration: InputDecoration(
              labelText: 'Lugar de Procedencia',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(
                  left: 20), // Agrega espacio desde el borde izquierdo
            ),
          ),
        ),
      ],
    );
  }
}

class DocumentForm extends StatelessWidget {
  final UserInfo userInfo;
  final Function onNext;

  const DocumentForm({super.key, required this.userInfo, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinea el contenido a la izquierda
      children: [
        const SizedBox(
            height: 29), // Espacio de 29 unidades desde la barra de progreso

        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 38), // Agrega espacio de 38 unidades en ambos lados
          child: Text(
            'Número de Identificación',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color:
                  HexColor('#FFFFFF'), // Establece el color de texto en blanco
            ),
          ),
        ),

        const SizedBox(height: 32), // Espacio de 32 unidades desde el texto

        Container(
          width: double
              .infinity, // Ancho completo para la separación de 38 unidades en ambos lados
          padding: const EdgeInsets.symmetric(
              horizontal: 38), // Agrega espacio de 38 unidades en ambos lados
          child: TextField(
            onChanged: (value) {
              userInfo.tipoDocumento = value;
            },
            decoration: InputDecoration(
              labelText: 'Tipo de Documento',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(
                  left: 20), // Agrega espacio desde el borde izquierdo
            ),
          ),
        ),

        const SizedBox(
            height:
                15), // Espacio de 15 unidades entre el campo de "Tipo de Documento" y el siguiente texto

        Container(
          width: double
              .infinity, // Ancho completo para la separación de 38 unidades en ambos lados
          padding: const EdgeInsets.symmetric(
              horizontal: 38), // Agrega espacio de 38 unidades en ambos lados
          child: TextField(
            onChanged: (value) {
              userInfo.numeroDocumento = value;
            },
            decoration: InputDecoration(
              labelText: 'Número de Documento',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(
                  left: 20), // Agrega espacio desde el borde izquierdo
            ),
          ),
        ),

        const SizedBox(
            height:
                32), // Espacio de 32 unidades desde el campo "Número de Documento" hasta el siguiente texto

        Container(
          width: double
              .infinity, // Ancho completo para la separación de 38 unidades en ambos lados
          padding: const EdgeInsets.symmetric(
              horizontal: 38), // Agrega espacio de 38 unidades en ambos lados
          child: Text(
            'Tu número de identificación nos ayuda a mantenerte seguro y te da a ti grandes beneficios en la app, Leer más.',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: HexColor(
                    '#FFFFFF'), // Establece el color de texto en blanco
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HobbiesForm extends StatefulWidget {
  final UserInfo userInfo;
  final Function onNext;

  const HobbiesForm({super.key, required this.userInfo, required this.onNext});

  @override
  _HobbiesFormState createState() => _HobbiesFormState();
}

class _HobbiesFormState extends State<HobbiesForm> {
  bool comidaSelected = false;
  bool fiestaSelected = false;
  bool deporteSelected = false;
  TextEditingController otherHobbiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 37),
        Text(
          'Cuéntanos acerca de tus intereses',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          textAlign: TextAlign.center, // Alinea el texto al centro
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Text(
            'Escribe hasta 5 intereses diferentes para mantenerte informado de eventos o nuevos lugares',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: HexColor('#FFFFFF'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 320,
          height: 50,
          child: TextField(
            controller: otherHobbiesController,
            onChanged: (value) {
              // Puedes manejar la entrada de otros hobbies aquí
            },
            decoration: InputDecoration(
              labelText: 'Agregar otros hobbies',
              labelStyle: TextStyle(
                color: HexColor('#929292'),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHobbyButton('Comida', comidaSelected),
            const SizedBox(width: 10), // Agregado espacio entre botones
            _buildHobbyButton('Fiesta', fiestaSelected),
            const SizedBox(width: 10), // Agregado espacio entre botones
            _buildHobbyButton('Deporte', deporteSelected),
          ],
        ),
      ],
    );
  }

  Widget _buildHobbyButton(String text, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          switch (text) {
            case 'Comida':
              comidaSelected = !comidaSelected;
              break;
            case 'Fiesta':
              fiestaSelected = !fiestaSelected;
              break;
            case 'Deporte':
              deporteSelected = !deporteSelected;
              break;
          }
        });
      },
      child: Container(
        width: 100,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.purple : Colors.white,
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: selected ? Colors.purple : Colors.white,
            width: 2, // Ajusta el ancho del borde seleccionado
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
//
