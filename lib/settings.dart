import 'package:flutter/material.dart';
import 'package:fosm/styles.dart';

import 'globals.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({
    super.key,
  });

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

//TODO bool setting alte objekte vor abfrage löschen
class _SettingsRouteState extends State<SettingsRoute> {
  double searchRadiusValue = Globals().preferences.searchRadius; //in m
  bool deleteOldQueryData = Globals().preferences.deleteOldQueryData;

  @override
  void initState() {
    super.initState();

    //prevents layout error when slider range was changed
    if(searchRadiusValue<100){
      searchRadiusValue=100;
    }else if(searchRadiusValue>10000){
      searchRadiusValue=10000;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.85),
        ),
        extendBodyBehindAppBar: false,
        body: Container(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildOption(
                  title: "Suchradius",
                  subTitle: "Radius einer Umkreissuche",
                  child: Slider(
                    value: searchRadiusValue,
                    min: 100,
                    max: 10000,
                    divisions: 99,
                    label: "${searchRadiusValue.round()} m",
                    onChanged: (value) {
                      setState(() {
                        searchRadiusValue = value;
                      });
                    },
                    onChangeEnd: (value) {
                      Globals().preferences.searchRadius = value;
                    },
                  )),
              _buildOption(
                  title: "Alte Abfrage löschen",
                  subTitle: "Entfernt alte Daten bevor eine neue Abfrage ausgeführt wird",
                  child: Checkbox(
                    value: deleteOldQueryData,
                    side: const BorderSide(color: Colors.white, width: 2),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          deleteOldQueryData = value;
                          Globals().preferences.deleteOldQueryData = value;
                        });
                      }
                    },
                  )),
              const Spacer(),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Diese App wurde im Rahmen des Moduls 'Entwurfsmethoden und -muster in der GeoIT' an der Berliner Hochschule für Technik entwickelt.",
                  style: Styles.small.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      showLicensePage(context: context,
                        applicationName: "Flutter OpenStreetMap Viewer",
                        applicationVersion: "1.1",
                      );
                    },
                    child: const Text("Lizenzen")),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "@Moritz Gerlowski\nDo not distribute",
                      style: Styles.normal.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _buildOption({required String title, required String subTitle, required Widget child}) {
    return Center(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Styles.big.copyWith(color: Colors.white),
                  ),
                  Text(
                    subTitle,
                    style: Styles.small.copyWith(color: Colors.white),
                  ),
                ],
              ),
              const Spacer(),
              child
            ],
          ),
        ),
      ),
    );
  }
}
