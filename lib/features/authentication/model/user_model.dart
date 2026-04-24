// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/utils/formatter/formater.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String userName;
  final String email;
  String phoneNumber;
  String profilPicture;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.profilPicture,
  });

  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => JFormatter.formatPhoneNumber(phoneNumber);

 static List<String> nameParts(String fullName) => fullName.trim().split(" ");

static String generateUsername(String fullName) {
  List<String> parts = nameParts(fullName);
  String first = parts.isNotEmpty ? parts[0].toLowerCase() : 'user';
  String last = parts.length > 1 ? parts[1].toLowerCase() : '';
  return "cwt_${first}${last}";
}


  static UserModel empty() => UserModel(id: '', firstName: '', lastName: '', userName: '', email: '', phoneNumber: '', profilPicture: '');
  
  Map<String, dynamic>toJson(){
    return{
      'FirstName': firstName,
       'LastName': lastName,
       'UserName': userName,
       'Email':email,
       'PhoneNumber':phoneNumber,
       'ProfilePicture':profilPicture,
    };
  }

   factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!; 
 // Safe access after null check
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        userName: data['UserName'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilPicture: data['ProfilPicture'] ?? '', 
      );
    } else {
      // Handle the case where document.data() is null
      throw Exception('Missing user data in Firestore document'); // Or handle differently
    }
  }
}
