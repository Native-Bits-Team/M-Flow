// markdown_to_pdf MIT licensed | Copyright (c) 2022 Datagrove | Github link: https://github.com/datagrove/markdown_to_pdf/tree/main?tab=readme-ov-file

// This file was modified by Native Bits Team. ////////

//import 'dart:developer';
//import 'dart:convert';
//import 'dart:collection';
import 'dart:async';
//import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
//import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' as w;
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:m_flow/dependencies/flutter_markdown/code/code_src/style_sheet.dart';
//import 'package:pdf/widgets.dart' as pw;
import 'package:markdown/markdown.dart' as md;
//import 'package:m_flow/dependencies/markdown/code/markdown.dart' as md;

//import 'package:pdf/pdf.dart' as p;
//import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:m_flow/functions/json_db.dart';
import 'package:printing/printing.dart';
//import 'package:pdf/widgets.dart';

import 'package:m_flow/dependencies/dart_pdf/pdf/code/pdf.dart';
import 'package:m_flow/dependencies/dart_pdf/pdf/code/pdf.dart' as p;
import 'package:m_flow/dependencies/dart_pdf/pdf/code/widgets.dart' as pw;


// computed style is a stack, each time we encounter an element like <p>... we push its style onto the stack, then pop it off at </p>
// the top of the stack merges all of the styles of the parents.
class ComputedStyle {
  List<Style> stack = [Style()];
  push(Style s, e) {
    var base = stack.last;
    s = s;
    s.e = e;
    stack.add(s.merge(base));
  }

  pop() {
    stack.removeLast();
  }

  pw.TextStyle style() {
    return stack.last.style();
  }

  Style parent() {
    return stack[stack.length - 1];
  }

  // Style parent2() {
  //   return stack[stack.length - 2];
  // }
}

Future<Uint8List> getImage(imageUrl) async {
  final formatUrl = Uri.parse(imageUrl);
  var url = Uri.https(formatUrl.host, formatUrl.path);
  var response = await http.get(url);
  final bytes = response.bodyBytes;
  return bytes;
}


Future<Uint8List> getImageNBT(imageUrlNBT) async {
imageUrlNBT = imageUrlNBT.toString().replaceFirst("file:///", "");
  if (imageUrlNBT.toString().startsWith("http")){
    return getImage(imageUrlNBT); 
  } else {
return File(imageUrlNBT).readAsBytes(); // [TRANSPARENCY] I got this from developer Madhur, who said to have got it from a snippit of code he wrote
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            decorationColor: PdfColors.blue,
            color: PdfColors.blue,
          )),
    );
  }
}

// you will need to add more attributes here, just follow the pattern.
class Style {
  pw.Font? font;
  pw.FontWeight? weight;
  double? height;
  pw.FontStyle? fontStyle;
  pw.UrlLink? urlLink;
  p.PdfColor? color;
  int listNumber = 0;
  pw.Container? container;
  int? listIndent;
  pw.Widget? bullet;
  pw.TextDecoration? textDecoration;
  pw.BoxDecoration? boxDecoration;
  Node? e;
  Style(
      {this.font,
      this.weight,
      this.height,
      this.fontStyle,
      this.color,
      this.bullet,
      this.container,
      this.listIndent = 0,
      this.listNumber = 0,
      this.e,
      this.textDecoration,
      this.boxDecoration});

  Style merge(Style s) {
    font ??= s.font;
    weight ??= s.weight;
    height ??= s.height;
    fontStyle ??= s.fontStyle;
    color ??= s.color;
    container ??= s.container;
    bullet ??= s.bullet;
    textDecoration ??= s.textDecoration;
    boxDecoration ??= s.boxDecoration;
    return this;
  }

  pw.TextStyle style() {
    return pw.TextStyle(
        font: font,
        fontWeight: weight,
        fontSize: height,
        color: color,
        fontStyle: fontStyle,
        decoration: textDecoration,
        background: boxDecoration);
  }
}

class BorderStyle {
  const BorderStyle({
    this.paint = true,
    this.pattern,
    this.phase = 0,
  });

  static const none = BorderStyle(paint: false);
  static const solid = BorderStyle();
  static const dashed = BorderStyle(pattern: <int>[3, 3]);
  static const dotted = BorderStyle(pattern: <int>[1, 1]);

  /// Paint this line
  final bool paint;

  /// Lengths of alternating dashes and gaps. The numbers shall be nonnegative
  /// and not all zero.
  final List<num>? pattern;

  /// Specify the distance into the dash pattern at which to start the dash.
  final int phase;
}

// each node is formatted as a chunk. A chunk can be a list of widgets ready to format, or a series of text spans that will be incorporated into a parent widget.
class Chunk {
  List<pw.Widget>? widget;
  pw.TextSpan? text;
  Chunk({this.widget, this.text});
}

// post order traversal of the html tree, recursively format each node.
class Styler {
  var style = ComputedStyle();

  get text => null;

  Future<Chunk> formatStyle(Node e, Style s) async {
    style.push(s, e);
    var o = await format(e);
    style.pop();
    return o;
  }

  Future<List<pw.Widget>> widgetChildren(Node e, Style s) async {
    style.push(s, e);
    List<pw.Widget> r = [];
    List<pw.TextSpan> spans = [];
    clear() {
      if (spans.isNotEmpty) {
        // turn text into widget
        r.add(pw.RichText(text: pw.TextSpan(children: spans)));
        spans = [];
      }
    }

    for (var o in e.nodes) {
      var ch = await format(o);
      if (ch.widget != null) {
        clear();
        r = [...r, ...ch.widget!];
      } else if (ch.text != null) {
        if (s.bullet != null){ // NBT
          if (ch.text!.text == "\n"){ // NBT
            continue; // NBT
          } // 
          spans.add(pw.TextSpan(text: ch.text!.text!.replaceAll("\n", ""))); // This was added to fix a "bug" that causes a newline to be added causing text not to be next to the "bullet"
          spans.add(const pw.TextSpan(text: "\n\n")); // 
          continue; // 
        } //
        //ch.text = pw.TextSpan(text: ch.text!.text, style: ch.text!.style!.copyWith(height: )); // NBT
        spans.add(ch.text!);
      }
    }
    clear();
    style.pop();
    return r;
  }

  Future<pw.TextSpan> inlineChildren(Node e, Style s) async {
    style.push(s, e);
    List<pw.InlineSpan> r = [];
    for (var o in e.nodes) {
      var ch = await format(o);
      if (ch.text != null) {
        r.add(ch.text!);
      }
    }
    style.pop();
    return pw.TextSpan(children: r);
  }

  pw.TextStyle? s;
  pw.Divider? f;

  // I only implmenented necessary ones, but follow the pattern

  int i = 0;

  Future<Chunk> format(Node e) async {
    switch (e.nodeType) {
      case Node.TEXT_NODE:
        return Chunk(
            text:
                pw.TextSpan(baseline: 0, style: style.style(), text: (e.text)));
      case Node.ELEMENT_NODE:
        e as Element;
        // for (var o in e.attributes.entries) { o.key; o.value;}
        switch (e.localName) {
          // SPANS
          // spans can contain text or other spans
          case "span":
          // case "code":
          //   return Chunk(text: inlineChildren(e, Style()));
          case "code":
            return Chunk(
                text: await inlineChildren(
                    e,
                    Style(
                        boxDecoration: const pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius:
                              pw.BorderRadius.all(pw.Radius.circular(3)),
                        ),
                        font: pw.Font.courier())));
          case "strong":
            return Chunk(
                text: 
                await inlineChildren(e, Style(weight: pw.FontWeight.bold)));
          case "em":
            return Chunk(
                text: await inlineChildren(
                  e, Style(fontStyle: pw.FontStyle.italic)));
          case "a":
            return Chunk(
                widget: [_UrlText((e.innerHtml), (e.attributes["href"]!))]);
          case "del":
            return Chunk(
                text: await inlineChildren(
                    e,
                    Style(
                        color: PdfColors.black,
                        textDecoration: pw.TextDecoration.lineThrough)));

          // blocks can contain blocks or spans
          case "ul":
          case "ol":
            int ln;
            final cl = e.attributes["start"];
            if (cl != null) {
              ln = int.parse(cl) - 1;
            } else {
              ln = 0;
            }
            return Chunk(
                widget: await widgetChildren(
                    e,
                    Style(
                      bullet: e.localName == "ul" ? pw.Bullet() : null,
                      listIndent: style.stack.last.listIndent ?? -4 + 4,
                      listNumber: ln,
                    )));
          // listNumber: e.attributes["start"] == null
          //     ? 0
          //     : int.parse(e.attributes["start"]!))));
          case "hr":
            return Chunk(widget: [pw.Divider()]);
          case "li":
            // we don't need to given an indent because we'll indent the child tree
            final st = style.stack.last;
            final bullet =
                st.bullet ?? pw.Text("${++style.parent().listNumber}");
            final wl = await widgetChildren(e, Style());
            final w = pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.SizedBox(width: 20, height: 20, child: bullet),
                  pw.Expanded(
                      child: pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 10),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: wl)))
                ]);
            return Chunk(widget: [w]);
          case "blockquote":
            return Chunk(widget: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Container(
                      decoration: const pw.BoxDecoration(
                          border: pw.Border(
                              left: pw.BorderSide(
                                  color: p.PdfColors.grey400, width: 2)),
                          color: p.PdfColors.grey200),
                      padding:
                          const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      margin: const pw.EdgeInsets.only(left: 5),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: await widgetChildren(e, Style()),
                      ),
                    ),
                  ])
            ]);
          case "h1":
            return Chunk(
                widget: await widgetChildren(
                    e, Style(weight: pw.FontWeight.bold, height: 24)));
          case "h2":
            return Chunk(
                widget: await widgetChildren(
                    e, Style(weight: pw.FontWeight.bold, height: 22)));
          case "h3":
            return Chunk(
                widget: await widgetChildren(
                    e, Style(weight: pw.FontWeight.bold, height: 20)));
          case "h4":
            return Chunk(
                widget: await widgetChildren(
                    e, Style(weight: pw.FontWeight.bold, height: 18)));
          case "h5":
            return Chunk(
                widget: await widgetChildren(
                    e, Style(weight: pw.FontWeight.bold, height: 16)));
          case "h6":
            return Chunk(
                widget: await widgetChildren(
                    e, Style(weight: pw.FontWeight.bold, height: 14)));
          case "pre":
            return Chunk(widget: [
              pw.Container(
                  child: pw.Row(
                      children: await widgetChildren(
                        e, Style(font: pw.Font.courier()))),
                  padding: const pw.EdgeInsets.all(5),
                  decoration: const pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(3)),
                      color: PdfColors.grey200))
            ]);
          case "body":
            return Chunk(widget: await widgetChildren(e, Style()));
          //Create a table with the rows stored in rowChildren
          case "table":
            var ch = <pw.TableRow>[];
            var cellfill = PdfColors.white;
            var border = pw.Border.all(width: 1, color: PdfColors.white);
            Future<void> addRows(Node e, Style s) async {
              for (var r in e.nodes) {
                var cl = <pw.Widget>[];
                for (var c in r.nodes) {
                  if (c.nodeType == Node.TEXT_NODE){continue;} // NBT
                  var ws = await widgetChildren(c, Style());
                  //var align = pw.CrossAxisAlignment.start;
                  var align = pw.CrossAxisAlignment.center; // NBT
                  if (c.attributes["style"] != null) {
                    if (c.attributes["style"] == "text-align: right;") {
                      align = pw.CrossAxisAlignment.end;
                    } else if (c.attributes["style"] == "text-align: center;") {
                      align = pw.CrossAxisAlignment.center;
                    } else if (c.attributes["style"] == "text-align: left;") {
                      align = pw.CrossAxisAlignment.start;
                    }
                  }
                  c as Element;
                  if (c.localName == "th") {
                    //cellfill = PdfColors.grey300; // NBT
                    cellfill = PdfColor(1.0, 0.0, 0.0,0.0); // NBT
                    border = const pw.Border(
                        bottom: pw.BorderSide(width: 2),
                        top: pw.BorderSide(color: PdfColors.white));
                    ws = await widgetChildren(
                        c,
                        Style(
                          weight: pw.FontWeight.bold,
                        ));
                  } else {
                    //cellfill = PdfColors.white; // NBT
                    cellfill = PdfColor(1.0,0.0,0.0,0.0); // NBT
                    border = pw.Border.all(width: 0, color: PdfColors.white);
                  }
                  //cl.add(pw.Column(children: ws, crossAxisAlignment: align)); // NBT
                  cl.add(pw.Expanded(child: pw.Padding(padding: pw.EdgeInsets.all(15.0),child:pw.Expanded(child: pw.Column(children: ws, crossAxisAlignment: align, mainAxisAlignment: pw.MainAxisAlignment.center))))); // NBT
                }
                ch.add(pw.TableRow(
                    children: cl,
                   // decoration: pw.BoxDecoration(border: pw.Border.all(width: 3.0, color: p.PdfColors.blue)) // NBT
                    decoration:
                        //pw.BoxDecoration(color: cellfill, border: border) // NBT
                        pw.BoxDecoration(border: pw.Border.all(width: 1.0, color: p.PdfColors.white), borderRadius: pw.BorderRadius.all(pw.Radius.circular(1.0))) // NBT
                        ));
              }
            }
            List<Node> toBeRemoved = []; // NBT
            e.nodes.forEach((element){ // 
              if (element.toString().length < 4){ //
                toBeRemoved.add(element); //
              } // 
            }); //
            toBeRemoved.forEach((element){ //
              e.nodes.remove(element); //
            }); // NOTE: there is a bug that causes an empty "new line" Node to be in the list, causing an error, this workaround is to detect and remove these empty nodes
            await addRows(e.nodes[0], Style(weight: pw.FontWeight.bold)); // NBT
            await addRows(e.nodes[1], Style(weight: pw.FontWeight.bold, color: PdfColors.white, boxDecoration: pw.BoxDecoration(border: pw.Border.all(width: 3.0), color: p.PdfColors.blue))); // NBT
            return Chunk(widget: [pw.Table(children: ch)]);
          case "img":
            //var imageBody = await getImage(e.attributes["src"]);
            var imageBody = await getImageNBT(e.attributes["src"]);

            var imageRender = pw.MemoryImage(imageBody);
            return Chunk(widget: [pw.Image(imageRender)]);
          case "p":
            return Chunk(widget: await widgetChildren(e, Style()));
          default:
           // print("${e.localName} is unknown");
            return Chunk(widget: await widgetChildren(e, Style()));
        }
      case Node.ENTITY_NODE:
      case Node.ENTITY_REFERENCE_NODE:
      case Node.NOTATION_NODE:
      case Node.PROCESSING_INSTRUCTION_NODE:
      case Node.ATTRIBUTE_NODE:
      case Node.CDATA_SECTION_NODE:
      case Node.COMMENT_NODE:
      case Node.DOCUMENT_FRAGMENT_NODE:
      case Node.DOCUMENT_NODE:
      case Node.DOCUMENT_TYPE_NODE:
        //print("${e.nodeType} is unknown node type");
    }
    return Chunk();
  }
}

//mdtopdf(String path, String out) async {
mdtopdf(String md2, String exportPath, bool htmlOrPdf, MarkdownStyleSheet style) async {
  var htmlx = md.markdownToHtml(md2,
      inlineSyntaxes: [md.InlineHtmlSyntax()],
      blockSyntaxes: [
        const md.TableSyntax(),
        const md.FencedCodeBlockSyntax(),
        const md.HeaderWithIdSyntax(),
        const md.SetextHeaderWithIdSyntax(),
      ],
      extensionSet: md.ExtensionSet.gitHubWeb);
      if (htmlOrPdf){
  File("$exportPath.html").writeAsString(htmlx);
  return;
      }
  var document = parse(htmlx);
  if (document.body == null) {
    return;
  }
  Chunk ch = await Styler().format(document.body!);  
  var doc = pw.Document(
    compress: true,
    version: p.PdfVersion.pdf_1_5,
    title: "TESTING TITLE",
    author: "Me",
    creator: ""
  );
  Color pageBackgroundColor = Color(HexColor(getTheme()["backgroundColor"]).value);
  doc.addPage(pw.MultiPage(
    pageTheme: pw.PageTheme(
    theme: mStyleToThemeData(style),
    buildBackground: (context){
      return pw.Expanded(child: pw.Rectangle(fillColor: p.PdfColor(pageBackgroundColor.red/255.0,pageBackgroundColor.green/255.0,pageBackgroundColor.blue/255.0)));
    }),

    //buildBackground: (context){
      //context.canvas.setFillColor(const p.PdfColor(0.0, 0.0, 1.0));
      //return pw.Rectangle(fillColor: const p.PdfColor(0.0, 1.0, 1.0), strokeColor: const p.PdfColor(0.0, 0.0, 1.0), strokeWidth: 50);
    //}),
   // pageFormat: p.PdfPageFormat.a4,
    build: (context) => ch.widget ?? []));
  if (!htmlOrPdf){
  File(exportPath).writeAsBytes(await doc.save());
  }
}

Future<List<dynamic>> generatePdfImageFromMD(String md2,MarkdownStyleSheet style ,{p.PdfPageFormat format = p.PdfPageFormat.a4, pageIndex=0, String? tempTheme}) async {
  if (md2 == ""){
    return [null,0]; // TODO: Should be removed
  }
  var htmlx = md.markdownToHtml(md2, inlineSyntaxes: [md.InlineHtmlSyntax()],
  blockSyntaxes: [const md.TableSyntax(),
  const md.FencedCodeBlockSyntax(),
  const md.HeaderWithIdSyntax(),
  const md.SetextHeaderWithIdSyntax()],
  extensionSet: md.ExtensionSet.gitHubWeb);

  var document = parse(htmlx);
  Chunk ch = await Styler().format(document.body!);
  var doc = pw.Document(
    compress: true,
    version: p.PdfVersion.pdf_1_5,);
    Color pageBackgroundColor;
    if (tempTheme == null){
    pageBackgroundColor = Color(HexColor(getTheme()["backgroundColor"]).value);
    } else {
    pageBackgroundColor = Color(HexColor(loadThemeFileReturn(tempTheme)["backgroundColor"]).value);
    }
  doc.addPage(pw.MultiPage(
  maxPages: 200,
  pageTheme: pw.PageTheme(
    buildBackground: (context){
      return pw.Expanded(child: pw.Rectangle(fillColor: p.PdfColor(pageBackgroundColor.red/255.0,pageBackgroundColor.green/255.0,pageBackgroundColor.blue/255.0)));
    },
//    buildBackground: (context){
  //    return pw.OverflowBox(minWidth: 500,child: pw.Rectangle(fillColor: p.PdfColor.fromHex("#000000FF"))); // [TRANSPARENCY] [IMAD LAGGOUNE]: I learned how to use fromHex from its description
   // },
    theme: mStyleToThemeData(style)),
   build: (context) => ch.widget ?? []));
  Uint8List t = await doc.save();
  Stream<PdfRaster> r = Printing.raster(t, dpi: PdfPageFormat.inch ); // [TRANSPARENCY] [IMAD LAGGOUNE]: I learned this from the source code of dart_pdf dependency
                                                                      // PdfPageFormat.inch is 72.0, I learned it from page_format.dart form pdf dependency
  PdfRaster j = await r.elementAt(pageIndex);
  Uint8List k = await j.toPng();
  List<dynamic> imageAndSize = [w.Image.memory(k, width: j.width.toDouble(), height: j.height.toDouble(), fit: BoxFit.fitWidth),doc.document.pdfPageList.pages.length];
  return imageAndSize;
}

pw.ThemeData? mStyleToThemeData(MarkdownStyleSheet style){
  return pw.ThemeData(
    header0: textStylePDFtoPaint(style.h1),
    header1: textStylePDFtoPaint(style.h2),
    header2: textStylePDFtoPaint(style.h3),
    header3: textStylePDFtoPaint(style.h4),
    header4: textStylePDFtoPaint(style.h5),
    header5: textStylePDFtoPaint(style.h6),
    defaultTextStyle: textStylePDFtoPaint(style.p),
    paragraphStyle: textStylePDFtoPaint(style.p),
    bulletStyle: textStylePDFtoPaint(style.p),
    //iconTheme: IconThemeData(color: PdfColor(1.0, 1.0, 1.0))
  );
}

pw.TextStyle textStylePDFtoPaint(TextStyle? tStyle){
  if (tStyle == null){
    return const pw.TextStyle();
  }
  pw.FontWeight fontWeight = pw.FontWeight.normal;
  if (tStyle.fontWeight == FontWeight.bold){
    fontWeight = pw.FontWeight.bold;
  }
  pw.TextStyle l = pw.TextStyle(
    fontWeight: fontWeight,
    fontSize: tStyle.fontSize,
    color: p.PdfColor(tStyle.color!.red.toDouble()/255.0,tStyle.color!.green.toDouble()/255.0, tStyle.color!.blue.toDouble()/255.0,tStyle.color!.alpha.toDouble()/255.0),

    );
  return l;
}