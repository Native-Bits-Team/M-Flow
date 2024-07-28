import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
  //FontStyle? fontStyle;
  //TextBaseline? textBaseline;
  //String? fontFamily;
  //List<String>? fontFamilyFallback;
  double? fontSize;
  //double? letterSpacing;
  //double? wordSpacing;
  //double? height;
  //TextLeadingDistribution? leadingDistribution;
  //Locale? locale;
  Paint background = Paint();
  Paint? foreground;
  //List<Shadow>? shadows;
  //List<FontFeature> fontFeatures;
  //List<FontVariation> fontVariations;
/////
///

background.color = Colors.transparent;

  value.forEach((key, value){
    
    switch (key) {
      case "fontWeight":
        fontWeight = makeFontWeightFromString(value);
        break;
      case "fontSize":
        fontSize = double.parse(value);
        break;
      case "color":
        color = Color(HexColor(value).value);
        break;
      case "decoration":
        decoration = TextDecoration.underline; // needs improvements
        break;
      case "decorationColor":
        decorationColor = Color(HexColor(value).value);
        break;
      case "decorationThickness":
        decorationThickness = double.parse(value);
        break;
      case "backgroundColor":
        background.color = Color(HexColor(value).value);
        break;
      case "foregroundColor":
        foreground = Paint();
        foreground!.color = Color(HexColor(value).value);
        break;
      default: // is it needed?
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

  double borderRadiusValue = 0;

  Color? color;
  //DecorationImage? image;
  BoxBorder? border;
  //List<BoxShadow>? boxShadow;
  //Gradient? gradient;
  //BlendMode? backgroundBlendMode;

  //BoxShape shape = BoxShape.rectangle;

  value.forEach((key, value){
    if (key == "color"){
      color = Color(HexColor(value).value);
    }
    if (key == "borderRadius"){
      borderRadiusValue = double.parse(value); // Idea: adding a check for validity of the value
    }
    if (key == "border"){
      value.forEach((keyC, valueC){
        if (keyC == "all"){
          Color bColor = Colors.transparent;
          double bWidth = 1.0;
          double bSide = BorderSide.strokeAlignInside;
          valueC.forEach((keyCC, valueCC){
            if (keyCC == "color"){
              bColor = valueCC;
            }
            if (keyCC == "width"){
              bWidth = valueCC;
            }
            if (keyCC == "strokeAlign"){
              if (valueCC == "strokeAlignCenter"){
                bSide = BorderSide.strokeAlignCenter;
              } else if (valueCC == "strokeAlignOutside"){
                bSide = BorderSide.strokeAlignOutside;
              } else {
                bSide = BorderSide.strokeAlignInside;
              }
            }
          });
          border = Border.all(color: bColor, width: bWidth, strokeAlign: bSide);
        }
      });
    }


  });

  BorderRadiusGeometry? borderRadius = BorderRadius.circular(borderRadiusValue);
  return BoxDecoration(color: color, borderRadius: borderRadius, border: border);
}