import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // A HTML betöltéséhez
import 'package:webview_flutter/webview_flutter.dart';

class GraphWidget extends StatefulWidget {
  final List<Map<String, dynamic>> nodes;
  final List<List<String>> edges;

  const GraphWidget({
    super.key,
    required this.nodes,
    required this.edges,
  });

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  late final WebViewController _controller;
  late String _htmlContent;

  @override
  void initState() {
    super.initState();
    _loadHtmlFromAssets();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
    // Beállítjuk a betöltési eseményt
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          // Miután a HTML betöltődött, frissítjük a gráfot
          _updateGraph();
        },
      ));
  }

  Future<void> _loadHtmlFromAssets() async {
    // A HTML fájl betöltése az assets-ből
    _htmlContent = await rootBundle.loadString('assets/html/sample.html');

    // Ellenőrizzük, hogy az assets helyesen van betöltve
    print("HTML content loaded: $_htmlContent");

    // Készítünk egy HTTP kérést az URL betöltéséhez
    final Uri uri = Uri.dataFromString(
      _htmlContent,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );

    // Betöltjük a HTML-t a WebView-ba
    _controller.loadRequest(uri);
  }

  void _updateGraph() {
    final nodeDataJson = jsonEncode(widget.nodes);
    final edgeDataJson = jsonEncode(widget.edges);

    // Meghívjuk a JavaScript függvényt a WebView-ban
    _controller.runJavaScript('updateGraphData($nodeDataJson, $edgeDataJson)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Átlátszó háttér a Scaffold-nál
      body: WebViewWidget(controller: _controller), // Csak a WebView jelenjen meg
    );
  }
}
