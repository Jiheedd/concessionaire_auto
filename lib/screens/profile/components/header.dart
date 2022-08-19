import 'dart:io';

import 'package:concessionaire_auto/models/user_model.dart';
import 'package:concessionaire_auto/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/size_config.dart';


class Header extends StatefulWidget {
  Header({
    this.userModel,
    this.borderContainer,
    Key? key
  }) : super(key: key);

  UserModel? userModel = UserModel();
  Color? borderContainer;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String profilePicLink = "";
  late bool _isPickChanged;
  late Reference ref ;
  final user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    _isPickChanged = false;
    ref = FirebaseStorage.instance.ref("UserImage/${user!.uid.toString()}.jpg");

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
      });
    });


    super.initState();
  }

  void pickUploadProfilePic(User userController) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    Reference ref = FirebaseStorage.instance
        .ref("UserImage/").child(userController.uid.toString()+".jpg");
    //    .ref("UserImage/");

    await ref.putFile(File(image!.path));

    print (image);
    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
        print(value);
        _isPickChanged = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30), horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Stack(
            children: [
              Container(
                width: 150,
                height: 150,
                child:Builder(
                    builder: (context) {
                      if (profilePicLink.isEmpty) {
                        profilePicLink = "https://firebasestorage.googleapis.com/v0/b/concessionaire-f5b10.appspot.com/o/UserImage%2Favatar.png?alt=media&token=7ef1e5f5-26f3-4ddd-bd65-6544939453b7";
                      }
                      return ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/avatar.png",
                          height: getProportionateScreenHeight(150),
                          width: getProportionateScreenWidth(150),
                          fit: BoxFit.cover,
                          image: profilePicLink,
                        ),
                      );
                    }
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: const Color.fromRGBO(255, 255, 255, 1.0),
                  ),
                    borderRadius: BorderRadius.circular(75),
                    color: yellowColor),
              ),
              Positioned(
                bottom: 0, right: 0, top: 80, left: 70,
                child: InkWell(
                  onTap: (){
                    pickUploadProfilePic(user!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.01), shape: BoxShape.circle,
                      //border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: getProportionateScreenWidth(25),),
          Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(height: getProportionateScreenHeight(50),),
                Text(
                  widget.userModel?.name??"",
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: widget.borderContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                Text(
                  widget.userModel?.phone??"",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                      color: widget.borderContainer, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
