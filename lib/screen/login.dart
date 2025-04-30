import 'package:flutter/material.dart';
import 'package:project_uts_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {

  String _user_id = "";

  void doLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", _user_id);
    active_user = _user_id;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF88CEEF),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/iMatching.png', width: 250, height: 250,),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter Username',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _user_id = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: doLogin,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
