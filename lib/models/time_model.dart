class Time {
  int? heure;
  int? minute;

  Time({this.heure, this.minute,});


  // Receive data from server
  factory Time.fromMap(Map<String, dynamic> map) {
    return Time(
      heure: map['heure'],
      minute: map['minute'],
    );
  }

  // Send data to server
  Map<String, dynamic> toMap() {
    return {
      'heure': heure,
      'minute': minute,
    };
  }
}