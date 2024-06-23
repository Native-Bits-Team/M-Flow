import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:m_flow/dependencies/md2pdf.dart';


class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);  // '?': Denotes that key can be of type 'null' or 'key'...
  // We can choose not to provide a Key when instantiating FormPage...

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController leftController = TextEditingController();
  String markdownText = "";  // Initialized an empty variable of type 'String' to store markdown text...

  @override
  void initState() {
    super.initState();
    leftController.addListener(_updateRightField);
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed, So that state object is removed permanently from the tree...
    leftController.dispose(); // Important to dispose of the controllers to free up resources and avoid memory leaks...
    super.dispose();
  }

  void _updateRightField() {
    setState(() {
      markdownText = leftController.text;  // Assigned user's input(left-form) to 'markdownText' variable...
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 183, 232, 255),
        toolbarHeight: 50.0,
        // title: Text("First Document!"),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.home, color: Colors.white, size: 25.0,)),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left form
            Expanded(
              child: Container(
                height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: leftController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(99, 128, 127, 127))
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'What\'s on your mind?',
                        ),
                        maxLines: null,
                        minLines: 50,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.arrow_left)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Spacer
            SizedBox(width: 50),

            // Right form (PreviewPanel)
            Expanded(
              child: Container(
                height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: PreviewPanel(markdownText: markdownText),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          label: Text("Export"),
                          icon: Icon(Icons.save),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 183, 232, 255)),
                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviewPanel extends StatelessWidget {
  final String markdownText;  // used to declare a variable that can only be assigned once...
  // A final variable must be initialized either at the time of declaration or in a constructor (if it's an instance variable)...
  
  // Required keyword ensures that this parameter must be provided when constructing an instance of PreviewPanel...
  const PreviewPanel({Key? key, required this.markdownText}) : super(key: key); 

  @override
  Widget build(BuildContext context) {

    // Card: A Material Design Card...
    return Card(
      shadowColor: Colors.grey,
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Markdown(data: markdownText),
      ),
    );
  }
}

List<String> exportFormatOptions = ["HTML", "PDF"]; // Global Variable
String exportFormat = exportFormatOptions[1];
TextEditingController pathParameter =TextEditingController(text: "document_1.pdf");
