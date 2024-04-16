import 'package:flutter/material.dart';

import 'globals.dart';
import 'map.dart';
import 'styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green.shade700.withOpacity(0.85);
    Color accent = Colors.greenAccent;

    MenuStyle menuStyle = MenuStyle(backgroundColor: MaterialStatePropertyAll(color.withOpacity(0.75)));

    return MaterialApp(
      title: 'Flutter OSM',
      theme: ThemeData(
        primaryColor: color,
        colorScheme: ColorScheme.fromSwatch(accentColor: accent, backgroundColor: color, primarySwatch: Colors.green),
        inputDecorationTheme: const InputDecorationTheme(constraints: BoxConstraints(maxHeight: 50), isDense: true),
        appBarTheme: AppBarTheme(foregroundColor: Colors.white, backgroundColor: color),
        dialogTheme: DialogTheme(
            backgroundColor: color,
            contentTextStyle: Styles.normal.copyWith(color: Colors.white),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        menuTheme: MenuThemeData(style: menuStyle),
        iconTheme: const IconThemeData(color: Colors.white),
        menuButtonTheme: MenuButtonThemeData(
            style: MenuItemButton.styleFrom(
          foregroundColor: Colors.white, //text color
        )),
        dividerTheme: const DividerThemeData(space: 0),
        sliderTheme: SliderThemeData(
            thumbColor: Colors.white,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.black38,
            valueIndicatorColor: Colors.white,
            valueIndicatorTextStyle: Styles.big.copyWith(color: color, fontWeight: FontWeight.bold)),
        checkboxTheme:
            CheckboxThemeData(checkColor: MaterialStatePropertyAll(color), fillColor: const MaterialStatePropertyAll(Colors.white)),
        scrollbarTheme: ScrollbarThemeData(thumbColor: MaterialStatePropertyAll(color), trackColor: MaterialStatePropertyAll(color)),
        dropdownMenuTheme: DropdownMenuThemeData(
            menuStyle: menuStyle,
            textStyle: const TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              floatingLabelAlignment: FloatingLabelAlignment.center,
              labelStyle: Styles.normal.copyWith(color: Colors.white),
            )),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Open Street Map'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UniqueKey mapkey = UniqueKey();

  bool ready = false;

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
                color: Colors.transparent,
                child: Text(
                  "Flutter OpenStreetMap",
                  style: Styles.gigantic.copyWith(color: Colors.white),
                )),
            Material(
                color: Colors.transparent,
                child: Text(
                  "Moritz Gerlowski",
                  style: Styles.huge.copyWith(color: Colors.white),
                )),
            const SizedBox(height: 8,),
            const Center(
              child: SizedBox.square(
                  dimension: 100,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  )),
            ),
          ],
        ),
      );
    }
    return MapWidget(
      key: mapkey,
      onGPSPermissionsGranted: () {
        debugPrint("rebuilding map widget...");
        setState(() {
          mapkey = UniqueKey();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Globals();
    _delay();
  }

  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      ready = true;
    });
  }
}
