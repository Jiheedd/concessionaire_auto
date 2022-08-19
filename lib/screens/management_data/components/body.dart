import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concessionaire_auto/utils/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../../components/go_to_sign_in_page.dart';
import '../../../utils/size_config.dart';

import 'header.dart';
import 'appointment_info.dart';


class ManagementBody extends StatefulWidget {
  const ManagementBody({Key? key}) : super(key: key);

  @override
  State<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends State<ManagementBody> {
  final Stream<QuerySnapshot> loadMatricules = FirebaseFirestore.instance.collection('appointments').snapshots();
  final CollectionReference pathUser = FirebaseFirestore.instance.collection('user');
  late List<QueryDocumentSnapshot<Object?>> data2;
  // calling our FireStore
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  bool _isLoggedIn = false;
  bool isEnabled = true;

  TextEditingController leftSide = TextEditingController();
  TextEditingController rightSide= TextEditingController();


  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;

    List<dynamic> userMatricules = [];
    List<DocumentSnapshot> listMatricules = [];

    String userID = user?.uid??"";

    if(userID.isNotEmpty) {
      _isLoggedIn = true;
      firebaseFirestore.collection("user").doc(userID).get().then((value) {
        if (value.data()!.containsKey("matricules")) {
          userMatricules = value["matricules"];
          print("Matricules ${value["matricules"]}");
        }
      });
    }

    return (_isLoggedIn)
      ?
      Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Header(),
                      SizedBox(height: getProportionateScreenHeight(45)),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.05, 0.1, 0.35, 0.8],
                                colors: actionContainerColorBlue)),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance.collection('appointments').get(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  Widget wid = Container();

                                  if(snapshot.hasError){
                                    print("Error receiving data");
                                    // snackbar wala haja
                                  }else if(snapshot.connectionState == ConnectionState.waiting){
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }else if (snapshot.connectionState == ConnectionState.done){
                                    List<DocumentSnapshot> mats = [];

                                    mats = snapshot.data!.docs.toList();

                                    print("matricule = $listMatricules");

                                    if(userMatricules.isNotEmpty){
                                      for (int j = 0; j<=mats.length-1; j++){
                                        for(int i=0; i<userMatricules.length; i++){

                                          if (userMatricules[i]==mats[j].id){
                                            listMatricules.add(mats[j]);
                                          }

                                        }
                                      }
                                      wid = Column(
                                        children: List.generate(listMatricules.length, (index) {
                                          //late DocumentSnapshot currentMat;

                                          print("matricule $index = ${listMatricules[index].id}");

                                          if(listMatricules.isNotEmpty){
                                            //currentMat = listMatricules[index];
                                            print("We receive data ");
                                            DocumentSnapshot document = listMatricules[index];
                                            return Column(
                                              children: [
                                                const SizedBox(height: 30,),
                                                Dismissible(
                                                  key: Key(document.id.toString()),
                                                  child: AppointmentInfo(appointmentDocument: document),
                                                  onDismissed: (direction) {
                                                    setState(() {
                                                      listMatricules.removeAt(index);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(SnackBar(content: Text('${document.id} a été supprimer')));
                                                    });
                                                    // removing data values from appointments
                                                    firebaseFirestore
                                                        .collection("appointments")
                                                        .doc(document.id)
                                                        .delete();

                                                    // removing data values from user list matricules
                                                    firebaseFirestore
                                                        .collection("user")
                                                        .doc(userID)
                                                        .get()
                                                        .then((value) {
                                                      List list = value["matricules"];
                                                      list.remove(document.id);
                                                      firebaseFirestore
                                                          .collection("user")
                                                          .doc(userID)
                                                          .update({"matricules" : list});
                                                    });
                                                  },
                                                  confirmDismiss: (DismissDirection direction) async {
                                                    return await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text("Confirmer"),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20)
                                                          ),
                                                          content: const Text("Voulez-vous vraiment supprimer ce rendez-vous?"),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                                onPressed: () => Navigator.of(context).pop(true),
                                                                child: const Text("supprimer", style: TextStyle(color: Colors.red),)
                                                            ),
                                                            FlatButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: const Text("annuler"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  background: Padding(
                                                    padding: EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
                                                    child: Container(
                                                      //height: getProportionateScreenHeight(15),
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                const Divider(height: 0.5, color: Colors.grey,),

                                              ],
                                            );
                                          }else{
                                            print("There is no data received");
                                            return const SizedBox.shrink();
                                          }
                                        }),
                                      );
                                    }
                                  }
                                  return wid;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
      )
        :
      const GoToSignInPage();
  }

}
