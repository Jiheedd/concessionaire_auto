import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/button/default_button.dart';
import '../../../components/shows/form_error.dart';
import '../../../helper/keyboard.dart';
import '../../../models/user_model.dart';
import '../../../screens/complete_profile/complete_profile_screen.dart';

import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../otp/otp_screen.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showLoading = false;
  String? password;
  String? conform_password;


  bool remember = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
          //buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          //buildPhoneNumberFormField(),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {

                try {
                  await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                      .then((value) => {
                    //postDetailsToFirestore(),
                    Fluttertoast.showToast(msg: "Account created Successful"),
                    _formKey.currentState!.save(),
                    // if all are valid then go to success screen
                    KeyboardUtil.hideKeyboard(context),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteProfileScreen(email: emailController.text, password: passwordController.text,))),
                  }).catchError((e) {
                    Fluttertoast.showToast(msg: e!.message);
                  });
                } on PlatformException catch (e) {
                  print(e.message.toString());
                }

              } else {

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      onSaved: (newValue) => emailController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
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
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      textInputAction: TextInputAction.next,
      controller: passwordController,
      onSaved: (newValue) => passwordController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      textInputAction: TextInputAction.done,
      //controller: passwordController,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && passwordController.text == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  postDetailsToFirestore() async {
    // calling our FireStore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // calling our user model
    User? user = auth.currentUser;
    UserModel userModel = UserModel();

    // writting all the values
    userModel.id = user!.uid;
    //userModel.name = nameController.text;
    //userModel.phone = phoneController.text;
    userModel.email = user.email;
    userModel.password = passwordController.text;

    // sending there values
    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());
  }
}

