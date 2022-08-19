import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/screens/search_car/search_car_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../../components/shows/form_error.dart';
import '../../../helper/keyboard.dart';

import '../../../components/button/default_button.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool obserText = true;

class _SignFormState extends State<SignForm> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int type = 0;

  bool? remember = false;
  final List<String?> errors = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  getType(int _type) {
    setState(() {
      type = _type;
    });
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //buildPhoneNumberFormField(),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: Colors.blueGrey,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                //onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                signIn(context, emailController, passwordController);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      //autofocus: true,
      controller: phoneNumberController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumberController.text = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        } else if (phoneNumberController.text.length!=8) {
          addError(error: kPhoneNumberLengthError);
          return "";
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        } else if (phoneNumberController.text.length==8) {
          removeError(error: kPhoneNumberLengthError);
        }
        return;
      },
      decoration: const InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.person,
            color: Colors.blueGrey,

          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      //autofocus: true,
      controller: emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => emailController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email adresse",
        hintText: "Enter your email adresse",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.person,
            color: Colors.blueGrey,

          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      obscureText: obserText,
      controller: passwordController,
      onSaved: (newValue) => passwordController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: GestureDetector(
            onTap: (){
              setState(() {
                obserText = !obserText;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                obserText==true?
                Icons.visibility
                    : Icons.visibility_off,
                color: Colors.blueGrey,
              ),
            )
        ),
      ),
    );
  }

  Future signIn(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async{

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),), barrierDismissible: true);

    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
          .then((auth) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        _formKey.currentState!.save(),
        // if all are valid then go to success screen
        KeyboardUtil.hideKeyboard(context),
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SearchCarScreen()), ModalRoute.withName('/')),


        /*FirebaseFirestore.instance.collection("user").doc(auth.user!.uid).get().then((value) {
          if(value.data()!.containsKey("type")) {
            if (value["type"] == 99) {
              print("Value : ${value["type"]}");
              setState(() {
                type = 99;
              });
              getType(type);
            }
          }
          if(type==99){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const SearchCarScreen()), ModalRoute.withName('/'));
          }else {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const HomeScreen()), ModalRoute.withName('/'));
          }
          print("type: ss $type");

        }),*/


      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } on FirebaseException catch (e){
      print(e);
    }


  }
}


