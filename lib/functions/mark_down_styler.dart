import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
/*
Color makeColorJson(Map<String, dynamic> colorJson){
  return Color.fromARGB(255, colorJson["R"], colorJson["G"], colorJson["B"]);
}

FontWeight makeFontWeightJson(String fontWeightJson){
  if (fontWeightJson == 600.toString()){
    return FontWeight.w600;
  }
  return FontWeight.normal;
}

*/

FontWeight makeFontWeightFromString(String weight){

  switch (int.parse(weight)) {
    case 100:
      return FontWeight.w100;
    case 200:
      return FontWeight.w200;
    case 300:
      return FontWeight.w300;
    case 400:
      return FontWeight.w400;
    case 500:
      return FontWeight.w500;
    case 600:
      return FontWeight.w600;
    case 700:
      return FontWeight.w700;
    case 800:
      return FontWeight.w800;
    case 900:
      return FontWeight.w900;
    default:
        return FontWeight.normal;
  }
}


TextStyle makeTextStyleJson(Map<String, dynamic> value){

// all of this was manually written, no copy past
  Color? color;
  TextDecoration? decoration;
  Color? decorationColor;
  double? decorationThickness;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  TextBaseline? textBaseline;
  String? fontFamily;
  List<String>? fontFamilyFallback;
  double? fontSize;
  double? letterSpacing;
  double? wordSpacing;
  double? height;
  TextLeadingDistribution? leadingDistribution;
  Locale? locale;
  Paint background = Paint();
  Paint? foreground;
  List<Shadow>? shadows;
  List<FontFeature> fontFeatures;
  List<FontVariation> fontVariations;
/////
///

background.color = Colors.transparent;

  value.forEach((key, value){
    if (key == "fontWeight"){
      fontWeight = makeFontWeightFromString(value);
    }

    if (key == "fontSize"){
      fontSize = double.parse(value);
    }

    if (key == "color"){
      color = Color(HexColor(value).value);
     // background.colorFilter = ColorFilter.mode(Color(HexColor(value).value), BlendMode.srcOver);

    }
    if (key == "decoration"){
        decoration = TextDecoration.underline;
    }
    if (key == "decorationColor"){
      decorationColor = Color(HexColor(value).value);
    }
    if (key == "decorationThickness"){
      decorationThickness = double.parse(value);
    }
    if (key == "backgroundColor"){
     // background.blendMode = BlendMode.dstOver;
      background.color = Color(HexColor(value).value);
    }

    if (key == "foregroundColor"){
      foreground = Paint();
      foreground!.color = Color(HexColor(value).value);
    }

  });


  return TextStyle(fontWeight: fontWeight, 
  fontSize: fontSize,
  color: color, 
  decoration: decoration,
  decorationColor: decorationColor,
  decorationThickness: decorationThickness,
  background: background,
  foreground: foreground);
}

Decoration makeBoxDecorationJson(Map<String, dynamic> value){
  Color? color;
  DecorationImage? image;
  BoxBorder? border;
  BorderRadiusGeometry? borderRadius;
  List<BoxShadow>? boxShadow;
  Gradient? gradient;
  BlendMode? backgroundBlendMode;

  //BoxShape shape = BoxShape.rectangle;

  value.forEach((key, value){
    if (key == "color"){
      color = Color(HexColor(value).value);
    }
  });
  //return ColoredBox();
  return BoxDecoration(color: color);
}