import 'package:flutter/material.dart';
import 'package:m_flow/pages/dashboard.dart';
import 'package:m_flow/pages/form_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// TODO: change resolution
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: PdfPreview(build: (f) => generatePdfFromMD("# Test",f), enableScrollToPage: true,),
      //home: SizedBox(child: PdfPreviewCustom(build: (f) => generatePdfFromMD("# Test",f), maxPageWidth: 400,)),
      home: const FormPage(initText: "",),
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      iconTheme: IconThemeData(color: Colors.white70),
      )
    );
  }
}
