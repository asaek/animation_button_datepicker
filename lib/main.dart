import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controllerAnimation;
  bool _estado = false;

  @override
  void initState() {
    super.initState();
    _controllerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 850));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(35));
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.black,
        body: Center(
          child: AnimatedBuilder(
            animation: _controllerAnimation,
            builder: (BuildContext context, _) {
              // Builder
              final valorAnimacion = _estado
                  ? Curves.elasticOut.transform(_controllerAnimation.value)
                  : Curves.elasticIn.transform(_controllerAnimation.value);

              final padding = EdgeInsets.lerp(
                  const EdgeInsets.all(15),
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 32),
                  valorAnimacion);

              final color =
                  Color.lerp(Colors.white, Colors.pinkAccent, valorAnimacion);
              final colorCircle =
                  Color.lerp(Colors.pinkAccent, Colors.white, valorAnimacion);

              final textColor =
                  Color.lerp(Colors.black, Colors.white, valorAnimacion);

              final elevation = lerpDouble(20, 40, valorAnimacion);
              final textSize = lerpDouble(20, 23, valorAnimacion);

              final giroAngulo = lerpDouble(0, pi, valorAnimacion) ?? 0.0;

              return Material(
                color: color,
                shape: const RoundedRectangleBorder(borderRadius: borderRadius),
                elevation: elevation!,
                child: InkWell(
                  borderRadius: borderRadius,
                  child: Padding(
                    padding: padding!,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kyary Pamyu Pamyu',
                          style: TextStyle(
                              color: textColor,
                              fontSize: textSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.1),
                        ),
                        const Text(
                          '@pamyurin',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorCircle,
                          ),
                          child: Transform.rotate(
                            angle: giroAngulo,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                'https://cdn-japantimes.com/wp-content/uploads/2015/05/z6-sp-expomilano1-a-20150501-e1430724912692.jpg',
                                fit: BoxFit.cover,
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      _estado = !_estado;
                      if (_estado) {
                        _controllerAnimation.forward(from: 0);
                      } else {
                        _controllerAnimation.reverse(from: 1);
                      }
                    });

                    await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (context) {
                        final inicialFecha = DateTime.now();
                        final size = MediaQuery.of(context).size;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width,
                                  height: 50,
                                  child: Material(
                                    color: Colors.pinkAccent,
                                    child: InkWell(
                                      child: const Center(
                                        child: Text(
                                          'Aceptar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 200,
                              color: Colors.white,
                              child: CupertinoTheme(
                                data: const CupertinoThemeData(
                                  textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                child: CupertinoDatePicker(
                                  onDateTimeChanged: (_) {},
                                  minimumDate: DateTime(2020),
                                  maximumYear: DateTime.now().year,
                                  initialDateTime: DateTime(
                                    inicialFecha.year,
                                    inicialFecha.month,
                                    inicialFecha.day,
                                    inicialFecha.hour,
                                    0,
                                  ),
                                  minuteInterval: 15,
                                  use24hFormat: false,
                                  mode: CupertinoDatePickerMode.dateAndTime,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    print(_estado);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
