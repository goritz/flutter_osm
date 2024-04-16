import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fosm/styles.dart';

import 'enums.dart';

class BaseDialog extends StatefulWidget {
  const BaseDialog(
      {super.key,
      required this.title,
      this.titleStyle = Styles.big,
      this.subTitle = "",
      this.subTitleStyle = Styles.normal,
      this.content,
      this.width = 300,
      this.childAlignment = Alignment.center,
      this.actions = const [],
      this.showClose = true,
      this.icon,
      this.iconSize = 24,
      this.iconColor = Colors.black54});

  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final String title;
  final TextStyle titleStyle;
  final String subTitle;
  final TextStyle subTitleStyle;
  final Widget? content;
  final AlignmentGeometry childAlignment;

  final List<Widget> actions;

  final double width;
  final bool showClose;

  @override
  State<BaseDialog> createState() => _BaseDialogState();
}

class _BaseDialogState extends State<BaseDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: widget.width,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  // decoration: const BoxDecoration(color: Colors.black12),
                  child: Row(
                    children: [
                      widget.icon == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: Icon(
                                widget.icon,
                                size: widget.iconSize,
                                color: widget.iconColor,
                              ),
                            ),
                      Text(
                        widget.title,
                        style: widget.titleStyle,
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
                widget.subTitle.isEmpty
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: widget.width * 0.9,
                              child: Text(
                                widget.subTitle,
                                style: Styles.normal.copyWith(color: Colors.white),
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(alignment: widget.childAlignment, child: widget.content),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Wrap(
                        spacing: 8,
                        children: widget.actions,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              top: -2.0,
              right: 0.0,
              child: !widget.showClose
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Styles.buildIconButton(
                          iconSize: 20,
                          color: Colors.white,
                          iconData: Icons.close,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showSimpleDialog(BuildContext context,
    {required String title, required String message, String yes = "Ja", String no = "Nein", Widget? content, bool hideNo = false}) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) => RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (value) {
        if (value is RawKeyUpEvent && value.logicalKey == LogicalKeyboardKey.enter) {
          Navigator.pop(context, true);
        }
      },
      child: BaseDialog(
        title: title,
        subTitle: message,
        content: content,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              yes,
              style: Styles.normal.copyWith(color: Colors.white),
            ),
          ),
          hideNo
              ? const SizedBox.shrink()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(no, style: Styles.normal.copyWith(color: Colors.white)),
                ),
        ],
      ),
    ),
  );
}

class WMSDialog extends StatefulWidget {
  const WMSDialog({
    super.key,
    required this.wmsServers,
    required this.onWMSAdded,
    required this.onWMSSelected,
    this.botOffsetFactor = 0,
    this.leftOffsetFactor = 0,
  });

  final List<WMSEntry> wmsServers;

  final Function onWMSAdded;
  final Function onWMSSelected;
  final double botOffsetFactor;
  final double leftOffsetFactor;

  @override
  State<WMSDialog> createState() => _WMSDialogState();
}

class _WMSDialogState extends State<WMSDialog> {
  WMSEntry? chosen;

  late GlobalKey dropdownKey;

  @override
  void initState() {
    super.initState();
    dropdownKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // insetPadding: EdgeInsets.only(left: size.width * widget.leftOffsetFactor, bottom: size.height * widget.botOffsetFactor),
      title: const Text(
        "Layer",
        style: Styles.normal,
      ),
      actions: [],
      content: Container(
        padding: const EdgeInsets.all(4),
        // height: size.height * 0.4,
        // width: size.width * 0.2,
        child: DropdownButton(
          key: dropdownKey,
          itemHeight: 74,
          isExpanded: true,
          value: chosen,
          isDense: false,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
          hint: const Text("WMTS-Layer auswählen",style: Styles.big,),
          items: widget.wmsServers.map((WMSEntry entry) {
            return DropdownMenuItem(
              value: entry,
              onTap: () async {
                if (entry != WMSEntry.customTemplate()) {
                  debugPrint("$entry was selected");
                  widget.onWMSSelected(entry);
                  Navigator.pop(context);
                  return;
                }
              },
              child: (entry != WMSEntry.customTemplate()
                  ? Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.displayName,
                            style: Styles.normal,
                          ),
                          entry.attribution != null
                              ? Text(
                                  entry.attribution!,
                                  style: Styles.tiny,
                                )
                              : const SizedBox.shrink(),
                          Text(
                            entry.url,
                            overflow: TextOverflow.fade,
                            style: Styles.tiny,
                          )
                        ],
                      ),
                    )
                  //eigenes Layout für Hinzufügen-Option
                  : Text(
                      entry.displayName,
                      style: Styles.normal,
                    )),
            );
          }).toList(),
          onChanged: (value) {},
        ),
      ),
    );
  }
}

class AddWMTSDialog extends StatefulWidget {
  const AddWMTSDialog({super.key, required this.autoName, required this.callback});

  final String autoName;
  final Function callback;

  @override
  State<AddWMTSDialog> createState() => _AddWMTSDialogState();
}

class _AddWMTSDialogState extends State<AddWMTSDialog> {
  String nameInput = "";
  String urlInput = "";

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Neuen Web Map Tile Service (WMTS) registrieren",
        style: Styles.normal,
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.cancel),
            tooltip: "Abbrechen"),
        IconButton(
          icon: const Icon(Icons.check),
          tooltip: "Bestätigen",
          onPressed: () {
            //neuen wmts registrieren

            if (nameInput.isEmpty) {
              nameInput = widget.autoName;
            }
            if (urlInput.isEmpty) {
              setState(() {
                errorMessage = "Tile Provider URL darf nicht leer sein!";
              });
              return;
            }

            WMSEntry custom = WMSEntry.custom(url: urlInput, displayName: nameInput, editable: true);
            debugPrint("adding wms entry $custom to wmsServers");
            widget.callback(custom);

            Navigator.of(context).pop(true);
          },
        )
      ],
      content: Container(
        padding: const EdgeInsets.all(4),
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 60,
                        child: const Text(
                          "Name",
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: nameInput),
                          onChanged: (value) {
                            nameInput = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 60,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "URL",
                              style: Styles.small,
                            ),
                            Text(
                              "(Im xyz Schema)",
                              style: Styles.small,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: urlInput),
                          onChanged: (value) {
                            urlInput = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 10),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
