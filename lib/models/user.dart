class UserModel {
  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? password;
  String? uid;

  //Receiving Data
  UserModel({this.firstName,this.lastName,this.gender,this.email,this.password,this.uid});

  factory UserModel.fromMap(map){
    return UserModel(
      firstName: map['firstName'],
      lastName: map['lastName'],
      gender:map['gender'],
      email: map['email'],
      password: map['password'],
      uid: map['uid']
    );
  }

  //Sending Data
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender':gender,
      'email': email,
      'password': password,
      'uid': uid
    };
  }
}