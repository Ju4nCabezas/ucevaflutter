import 'package:flutter/material.dart';
import 'package:ucevaflutter/views/params/ParamSendTab.dart';
import 'package:ucevaflutter/widgets/grid_view.dart';

class CustomMenuBar extends StatefulWidget {
  const CustomMenuBar({super.key});

  @override
  State<CustomMenuBar> createState() => _CustomMenuBarState();
}

class _CustomMenuBarState extends State<CustomMenuBar> {
  String? sentParam;

  void onSend(String param) {
    setState(() {
      sentParam = param;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.cloud_outlined)),
            Tab(icon: Icon(Icons.beach_access_sharp)),
            Tab(icon: Icon(Icons.brightness_5_sharp)),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              const MyGridView(),
              ParamSenderTab(onSend: onSend),
              Center(
                child: Text(
                  sentParam != null
                      ? "Parametro recibido: $sentParam"
                      : "It's sunny here",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
