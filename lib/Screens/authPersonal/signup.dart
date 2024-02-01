import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventflow/Screens/home.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({ Key? key }) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {


GlobalKey<FormState> _formkey = GlobalKey<FormState>();

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController  = TextEditingController();

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
                    child: Text("Signup here"),
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
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value){
                        _emailController.text="";
                        _passwordController.text = "";
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                      }).onError((error, stackTrace){
                        print("Error ${error.toString()}");
                      });
                    }
                  }, 
                  child: Text("Signup",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                  )
            
            ],
            
          ),
        ),
      ),
    );
    
  }
}