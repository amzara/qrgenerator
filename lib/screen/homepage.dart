import 'package:flutter/material.dart';
import 'function1.dart'; // Import the function1 page
import 'function2.dart'; // Import the function2 page
import 'function3.dart'; // Import the function3 page
import 'function4.dart'; // Import the function4 page
import 'function5.dart'; // Import the function5 page.
import 'csvPractice.dart'; //Import csvpractice page

class homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1508385082359-f38ae991e8f2?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGNvcnBvcmF0ZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello! This is Page 1',
                style: TextStyle(
                  fontSize: 59.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                  height: 20), // Add some space between the text and button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => function1()),
                  );
                },
                child: Text('Go to Function 1'),
              ),
              SizedBox(height: 20), // Add space between the buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => function2()),
                  );
                },
                child: Text('Go to Function 2'),
              ),
              SizedBox(height: 20), // Add space between the buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => function3()),
                  );
                },
                child: Text('Go to Function 3'),
              ),
              SizedBox(height: 20), // Add space between the buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => function4()),
                  );
                },
                child: Text('Go to Function 4'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => function5()),
                  );
                },
                child: Text('Go to Function 5'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => csvPractice()),
                  );
                },
                child: Text('Go to CSV practice page.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
