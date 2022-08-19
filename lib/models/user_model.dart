
class UserModel {
  String? id;
  String? name;
  String? phone;
  String? email, password;
  final String? image;

  UserModel({
    this.id,
    this.image,
    this.name,
    this.phone,
    this.password,
    this.email,
  });

  // Receive data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        id: map['uid'],
        name: map['name'],
        phone: map['phone'],
        email: map['email'],
        password: map['password'],
        image: map['image'],
    );
  }


  // Send data to server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'image': image,
    };
  }

}


// Our demo Products

List<UserModel> demoUsers = [
  UserModel(
    id: "1",
    image: "assets/images/ic_user.png",
    name: "Jihed Ben Kahla",
    phone: "55770201",
    email: "jihedbenkahla@gmail.com",
    password: "jihed000",

  ),
];

