import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final String text;
  final String sectionName;
  void Function()? onPressed; // The function to call when the edit button is pressed


  InfoBlock({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Styling the container
      decoration: BoxDecoration(
        color: Colors.blueGrey[100], // Background color of the container
        borderRadius: BorderRadius.circular(12) 
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
          children: [
            // name
            Row(
              children: [
                Text(sectionName,
                style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        
                // edit button
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.settings, color: Colors.black45),
                ),
              ],
            ),
        
            // text
            Text(text),
          ],
        ),
      ),
    );
  }
}