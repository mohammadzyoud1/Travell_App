import 'package:flutter/material.dart';
import 'HomeScreen.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(backgroundColor: Colors.purple, body: SignScreen()),
    ),
  );
}

class SignScreen extends StatefulWidget {
  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  late int password_length = 0; //password length track
  late int email_length = 0; // email length track
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  String error_text_password = '';
  String error_text_email = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/signin_wallpaper.jpg'),
                fit: BoxFit.fill),
          ),
        ),
        Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: Text(
                'Welcome to travel with us,Please sign in ',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            // Email input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                onChanged: (text) {
                  if (!text.contains('@')) {
                    error_text_email = 'please enter a crroect email';
                  } else {
                    error_text_email = '';
                  }
                  setState(() {
                    email_length = text.length;
                  });
                },
                decoration: InputDecoration(
                    errorText:
                        error_text_email.isEmpty ? null : error_text_email,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    hintText: 'Enter Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    hintStyle: TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            // Password input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                obscureText: true,
                onChanged: (text) {
                  if (text.length < 8) {
                    error_text_password =
                        'Password cant be shorter than 8 letters';
                  } else {
                    error_text_password = '';
                  }
                  setState(() {
                    password_length = text.length;
                  });
                },
                controller: myController,
                decoration: InputDecoration(
                    errorText: error_text_password.isEmpty
                        ? null
                        : error_text_password,
                    hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintStyle: TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  pressed(password_length, context, email_length);
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size(120, 50)),
                    shadowColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    surfaceTintColor: MaterialStateProperty.all(Colors.blue),
                    overlayColor: MaterialStateProperty.all(Colors.amber))),
          ]),
        ),
      ],
    );
  }

  // Button function
  pressed(int password_length, BuildContext context, int email_lenth) {
    if ((password_length) < 8 ||
        (email_lenth <= 0) ||
        (error_text_email.length > 0) ||
        (error_text_password.length > 0)) {
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home_Screen(),
        ),
      );
    }
  }
}
