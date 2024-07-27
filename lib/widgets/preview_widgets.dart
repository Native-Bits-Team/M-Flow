
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:m_flow/dependencies/dart_pdf/pdf/code/src/pdf/page_format.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/code_src/style_sheet.dart';
import 'package:m_flow/dependencies/md2pdf/md2pdf.dart';

class DocumentPreview extends StatefulWidget {
  final String content;
  final MarkdownStyleSheet markdownStyle;
  DocumentPreview(this.content, {super.key, required this.markdownStyle});

  @override
  _DocumentPreviewState createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview> {
  Image? previewImage;
  int pageCount = 1;
  int currentPageIndex = 1;
  int lastPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    double size = 300;
    double ratio = PdfPageFormat.a4.height / PdfPageFormat.a4.width;
    ratio *= 300;
    /*
    if (widget.content.isEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullPreviewScreen(widget.content),
            ),
          );
        },
        child: Column(children: [
          Container(
          width: size,
          height: ratio,
          child: const Card(
            child: Center(
              child: Text(
                "Nothing to display", 
                style: TextStyle(
                  color: Colors.red
                  ),
                ),
            ),
          ),
        )
        Text("Path 1/1")]),
      );
    }
*/ // NOT REALLY NEEDED

    if (previewImage == null || lastPageIndex != currentPageIndex) {
      previewImage = null;
      lastPageIndex = currentPageIndex;
      generatePdfImageFromMD(widget.content, widget.markdownStyle, pageIndex: currentPageIndex-1)
          .then((imageAndSize) {
        setState(() {
          previewImage = imageAndSize[0];
          pageCount = imageAndSize[1];
        });
      });
    }
    Widget wError;
    if (widget.content.isEmpty) {
      wError = const Center(
        child: Tooltip(message: "Nothing to Display", child: Icon(Icons.info, color: Colors.red))
        //Text(
          //"Nothing to Display",
          //style: TextStyle(color: Colors.red),
      //  ),
      );
    } else {
      wError = const Center(child: CircularProgressIndicator());
    }

    String pageText = "Page $currentPageIndex/$pageCount";
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPreviewScreen(widget.content, pageIndex: currentPageIndex-1, markdownStyle: widget.markdownStyle,),
          ),
        );
      },
      child: Column(children: [
        Row(children: [
          IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = max(1, currentPageIndex - 1);
                });
              },
              icon: const Icon(Icons.chevron_left)),
          SizedBox(
              width: size,
              height: ratio,
              child: Card(
              clipBehavior: 
              Clip.antiAliasWithSaveLayer,
              //elevation: 0.0,
              borderOnForeground: false,
              shadowColor: Colors.black, // will this effect the preview accuracy
              margin: const EdgeInsets.all(0.0),
                  child: previewImage ?? wError
                      //const Center(child: CircularProgressIndicator()),
                  )),
          IconButton(
              onPressed: () {
                setState(() {
                  currentPageIndex = min(pageCount, currentPageIndex + 1);
                });
              },
              icon: const Icon(Icons.chevron_right))
        ]),
        const SizedBox(height: 20),
        Text(pageText)
      ]),
    );
  }
}



class FullPreviewScreen extends StatefulWidget {
  final String content;
  final int pageIndex;
  final MarkdownStyleSheet markdownStyle;

  const FullPreviewScreen(this.content, {required this.pageIndex, required this.markdownStyle, super.key});

  @override
  _FullPreviewScreenState createState() => _FullPreviewScreenState();
}

class _FullPreviewScreenState extends State<FullPreviewScreen> {
  Image? previewImage;

  @override
  void initState() {
    super.initState();

    if (widget.content.isNotEmpty) {
      generatePdfImageFromMD(widget.content, widget.markdownStyle, pageIndex: widget.pageIndex)
          .then((imageAndSize) {
        setState(() {
          previewImage = imageAndSize[0];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = 600;
    double ratio = PdfPageFormat.a4.height / PdfPageFormat.a4.width;
    ratio *= size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 22, 32),
      appBar: AppBar(
        toolbarHeight: 28,
        backgroundColor: const Color.fromARGB(255, 2, 22, 32),
      ),
      body: Center(
        child: widget.content.isEmpty
            ? const Text("Nothing to display",
                style: TextStyle(color: Colors.red))
            : SingleChildScrollView(
                child: Container(
                  width: size,
                  height: ratio,
                  decoration: const BoxDecoration(),
                  child: Card(
                    child: previewImage ??
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
      ),
    );
  }
}
