import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eventflow/Screens/home.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


GlobalKey<FormState> _formkey = GlobalKey<FormState>();

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController  = TextEditingController();


// _login(data) async{

//   print(data.toString());

//   _emailController.text = "";
//   _passwordController.text = "";
  
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Center(
                    child: Text("Login here"),
                  )
                ],
              ),
              Form(
                key: _formkey,
                child: Column(children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    label: Text("Email here"),
                    // icon: Icon(Icons.email),
                    hintText: "tape your email here"
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "tape your password here",
                    label: Text("Password here"),
                    // icon: Icon(Icons.password,
                    // )
                  ),

                ),
               
              ],
              )),


               
               ElevatedButton(
                  onPressed: ()async{
                    if (_formkey.currentState!.validate()){
                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value){
                        _emailController.text="";
                        _passwordController.text = "";
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                      }).onError((error, stackTrace){
                        _emailController.text="";
                        _passwordController.text = "";
                        print("Error ${error.toString()}");
                      });
                    }
                  }, 
                  child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                  )
            
            ],
            
          ),
        ),
      ),
    );
    
  }
}