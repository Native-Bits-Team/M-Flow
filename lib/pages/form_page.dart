import 'package:flutter/material.dart';

_PreviewPanelState panel  = _PreviewPanelState(); // Temporary Global Vairable for development purpose


class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Controllers to access the user's input
  TextEditingController leftController = TextEditingController(); 
  PreviewPanel rightController = const PreviewPanel();

  @override
  void initState() {
    super.initState();
    // Add a listener to the leftController
    leftController.addListener(_updateRightField);
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed, So that state object is removed permanently from the tree
    leftController.dispose(); // Important to dispose of the controllers to free up resources and avoid memory leaks.
    //rightController.dispose();
    super.dispose();
  }

  // Method to update the right text field in real-time
  void _updateRightField() {
    setState(() {
      panel.update(leftController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.lightBlueAccent, toolbarHeight: 32.0, title: Text("First Document !"), centerTitle: true, titleTextStyle: TextStyle(color: Colors.white),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu_open),)],),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Row(
            children: [
              // left form
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: Column(
                    children: [Expanded(child: TextField(
                    controller: leftController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'Left',
                      hintText: 'What\'s on your mind?',
                    ),
                    maxLines: null, // null allows the form to grow dynamically as user types
                    minLines: 50,  // Minimum number of lines to display
                    // expands: true,
                  )),SizedBox(height: 30), // spacer
                  Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [IconButton(onPressed: () {}, icon: Icon(Icons.arrow_left)),IconButton(onPressed: () {}, icon: Icon(Icons.add)),IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right))])])

                ),
              ),

              // spacer
              SizedBox(width: 50),

              // right form
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: Column(
                    children: [Expanded(child: rightController),
                    SizedBox(height: 30),
                    Row( mainAxisAlignment: MainAxisAlignment.end,
                    children: [TextButton.icon(onPressed: () {}, label: Text("Export"), icon: Icon(Icons.save), style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent), foregroundColor: WidgetStatePropertyAll(Colors.white)),)])])

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class PreviewPanel extends StatefulWidget {
  const PreviewPanel({super.key});
  @override
  State<PreviewPanel> createState() => _PreviewPanelState();
  
}

class _PreviewPanelState extends State<PreviewPanel> {
  TextEditingController tcontroller = TextEditingController();
  FocusNode tfocusnode = FocusNode();
  Widget preview = markdownFromTextGenerator("");
  @override
  Widget build(BuildContext context) {
    panel = this;
    return Card.outlined(shadowColor: Colors.grey, elevation: 1.0, 
    child: Padding(padding: const EdgeInsets.all(10.0), child: preview),
);}
  void update(String text){
    setState(() {
      preview = markdownFromTextGenerator(text);
    });
  }
}


Widget markdownFromTextGenerator(String text){

  List<Widget> items = [];

  List<String> lines = text.split('\n');

  for (int i =0; i < lines.length ; ++i){

    lines[i] = lines[i].trimLeft();

    if (lines[i].startsWith("##")){
      
      items.add(Text(lines[i].substring(2).trimLeft(), style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),));
    } else if (lines[i].startsWith("#")) {
      items.add(Text(lines[i].substring(1).trimLeft(), style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),));
    } else {
      items.add(Text(lines[i], style: TextStyle(fontSize: 20.0),));

    }
  }
  Widget conWidget = Scaffold(
    body: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: items
    ),
  );


  return conWidget;
}
