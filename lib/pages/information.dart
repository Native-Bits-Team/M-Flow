import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ScrollController w = ScrollController();
    String s = "M-Flow 0.1-Alpha, By Native Bits Team\n\n Developers:\n Imad Laggoune | Project Manager and Lead Developer\n Madhur pandey | Lead Developer\n\n Licenes:\nflutter_markdown: BSD-3, License Text:\n";
    s += loadLicenseBSDThree();
    s += "\n md2pdf: MIT, License Text:";
    s += loadLicenseMIT();
    TextEditingController e = TextEditingController(text: s);
    return Scaffold(body: Padding(padding: const EdgeInsets.all(30),child: Card(color: Colors.white, child:Padding(padding: const EdgeInsets.all(20),child:Column(children: [Expanded(child: TextField(scrollController: w,controller: e, onChanged: (newText){
      e.text = s;

    }, maxLines: 1000,))])))));
  }
}


loadLicenseBSDThree(){
  return "Copyright 2013 The Flutter Authors. All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification,\nare permitted provided that the following conditions are met:\n\n    * Redistributions of source code must retain the above copyright\n      notice, this list of conditions and the following disclaimer.\n    * Redistributions in binary form must reproduce the above\n      copyright notice, this list of conditions and the following\n      disclaimer in the documentation and/or other materials provided\n      with the distribution.\n    * Neither the name of Google Inc. nor the names of its\n      contributors may be used to endorse or promote products derived\n      from this software without specific prior written permission.\n\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND\nANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED\nWARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE\nDISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR\nANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES\n(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;\nLOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON\nANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT\n(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\nSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n";
  //String s = File("lib/dependencies/flutter_markdown/LICENSE").readAsStringSync().replaceAll("\n", "\\n"); // [TRANSPARENCY] I used flutter_markdown LICENSE file to get the license text
  //File("bsd-3.txt").openWrite().write(s);

}

loadLicenseMIT(){ // [TRANSPARENCY] I copy pasted the License text from https://github.com/jmaupetit/md2pdf?tab=MIT-1-ov-file#readme
  return "Copyright (C) 2013-2016 Julien Maupetit\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of\nthis software and associated documentation files (the \"Software\"), to deal in\nthe Software without restriction, including without limitation the rights to\nuse, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of\nthe Software, and to permit persons to whom the Software is furnished to do so,\nsubject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS\nFOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR\nCOPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER\nIN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN\nCONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
}