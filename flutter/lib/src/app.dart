import 'package:flutter/material.dart';

import 'package:arducon/src/scan/presentation/pages/scan_page.dart';

class App extends StatelessWidget {

  const App({ super.key });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScanPage()
    );
  }
}