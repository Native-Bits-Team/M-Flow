

String addSidesToWord(String text, int start, String symbol){
  if (text.isEmpty){
    return "";
  }
  int index = start + 1;
  bool findStart = false;
  bool findEnd = false;
  String split = "";
  for (int i=0; i < index; ++i){
    //findStart = text.startsWith(RegExp("(,| )"), start-i); // Got the idea from the description of startsWith function and RegExp description // TODO: Should we use space for this?
    findStart = startsWithOneOf([',',' ','|','\n'], text, start-i);
    if (findStart){
      start = start-i+1; // +1 to remove the space itself
      break;
      }
    if (i == index-1){
      start = 0;
    }
  }
  split = text.substring(start);
  int end = split.length;

  for (int i=1; i < split.length; ++i){
    print(split.substring(0,1));
    findEnd = endsWithOneOf([',',' ','|','\n',''], split.substring(0, i));
    if (findEnd){
      end = i-1; // -1 to remove the space itself
      //split = split.substring(0, end-symbol.length);
      break;
    }
  }
  if (text.substring(start, start+end).startsWith(symbol) && text.substring(start, start+end).endsWith(symbol)){
    text = text.replaceRange(start, start+end, split.replaceFirst(symbol, '').substring(0, end-symbol.length*2));
    return text;
  }
  String newText = symbol;
  newText += text.substring(start, start+end);
  newText += symbol;
  if (start == 0 && (start+end) == text.length){
    return newText;
  } else {
  text = text.replaceRange(start, start+end, newText); // Bug: this doesn't replace everything if start == 0 and start+end == length
  return text;
  }
}


bool endsWithOneOf(List<String> l, String text){
  bool endValue = false;
  for (var value in l) {
    if (text.endsWith(value)){
      endValue = true;
      break;
    }
  }
  return endValue;
}

bool startsWithOneOf(List<String> l, String text, int index){ // Copy Pasted From endsWithOneOf with modifications
  bool startValue = false;
  for (var value in l) {
    if (text.startsWith(value, index)){
      startValue = true;
      break;
    }
  }
  return startValue;
}

String? addToLineStart(String text, int selectionBase, String prefix, {List<String> replacePrefix = const ["w\$", "r\$"]}){
  var sList = text.split("\n");
  var counter = 0;
  for (int i = 0; i < sList.length; i++) {
    if (sList[i].length + counter >= selectionBase && selectionBase >= counter){
      for (var rPrefix in replacePrefix) {
        if (sList[i].startsWith(rPrefix)){
          if (rPrefix == prefix){
            return null;
          }
          sList[i] = sList[i].replaceFirst(rPrefix, '');
        }
      }
      sList[i] = prefix + sList[i];
      break;
    }
    counter += sList[i].length + 1;
  }

  String result = "";
  for (var line in sList) {
    result += line;
    result += "\n";
  }
  return result;
  }