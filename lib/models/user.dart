import 'package:uuid/uuid.dart';

class User {
  String uuid;
  String email;
  String displayName;

  User({this.uuid, this.email, this.displayName});

  User.createNewUser({this.email, this.displayName}){
    uuid = Uuid().v4();
  }
}
