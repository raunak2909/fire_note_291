class UserModel {
  String name;
  String email;
  String mobNo;
  String gender;
  int age;

  UserModel(
      {required this.name,
      required this.mobNo,
      required this.email,
      required this.gender,
      required this.age});

  factory UserModel.FromDoc(Map<String, dynamic> doc) => UserModel(
      name: doc['name'],
      mobNo: doc['mobNo'],
      email: doc['email'],
      gender: doc['gender'],
      age: doc['age']);

  Map<String, dynamic> toDoc() => {
        'name': name,
        'mobNo': mobNo,
        'email': email,
        'gender': gender,
        'age': age,
      };
}
