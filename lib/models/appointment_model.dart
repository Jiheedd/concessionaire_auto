class AppointmentModel {

  Map<String,dynamic>? matricule;
  String? gouvernorat, delegation, jour, heure, chaine;
  String? marque, model, typeEnergy;
  List<dynamic>? operations;
  double? totalPrice;
  int? averageDuration;
  static Map<String,dynamic> detailService = {};
  static Map<String, dynamic> voiture = {};

  AppointmentModel({
    this.matricule,
    this.gouvernorat,
    this.jour,
    this.heure,
    this.chaine,
    this.delegation,
    this.marque,
    this.model,
    this.typeEnergy,
    this.operations,
    this.totalPrice,
    voiture,
    detailService,
  });


  // Receive data from server
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      matricule: map['matricule'],
      gouvernorat: map['gouvernorat'],
      jour: map['jour'],
      heure: map['heure'],
      chaine: map['chaine'],
      delegation: map['delegation'],
      voiture: map['voiture'],
      detailService: map["services"],
    );
  }

  // Send data to server
  Map<String, dynamic> toMap() {
    voiture["marque"] = marque;
    voiture["model"] = model;
    voiture["typeEnergy"] = typeEnergy;

    detailService["operations"] = operations;
    detailService["prix_total"] = "$totalPrice DT";
    detailService["duree_moyenne"] = "$averageDuration min";



    return {
      'matricule': matricule,
      'gouvernorat': gouvernorat,
      'delegation': delegation,
      'jour': jour,
      'heure': heure,
      'chaine': chaine,
      'voiture' : voiture,
      'services': detailService,
    };
  }
}