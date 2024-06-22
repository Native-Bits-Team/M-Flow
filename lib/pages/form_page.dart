import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Controllers to access the user's input
  TextEditingController leftController = TextEditingController(); 
  TextEditingController rightController = TextEditingController();

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
    rightController.dispose();
    super.dispose();
  }

  // Method to update the right text field in real-time
  void _updateRightField() {
    setState(() {
      rightController.text = leftController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Row(
            children: [
              // left form
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: TextField(
                    controller: leftController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'Left',
                      hintText: 'What\'s on your mind?',
                    ),
                    maxLines: null, // null allows the form to grow dynamically as user types
                    minLines: 50,  // Minimum number of lines to display
                    // expands: true,
                  ),


                  // I WANT TO ADD A BUTTON('+SAVE BTN') HERE WHILE AVOIDING THE OVERFLOW ISSUE, [WE CAN MAKE THE LEFT FORM HEIGHT LITTLE SMALLER]
                  // <------------------------------CODE-HERE----------------------------------------------->
                  // HINT: wrap the left-container in Column widget

                ),
              ),

              // spacer
              SizedBox(width: 50),

              // right form
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: TextField(
                    controller: rightController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: 'Right',
                    ),
                    maxLines: null, // null allows the form to grow dynamically as user types
                    minLines: 50,  // Minimum number of lines to display
                    // expands: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}