
class ProfileModel{
  
  String id;
  String phone;
  String token;

  ProfileModel({
    required this.id,
    required this.phone,
    required this.token
  });
  
  factory ProfileModel.fromMap({required Map<String,dynamic> data}){
    return ProfileModel(id: data['id'].toString(), phone: data['phoneNumber'].toString(), token: data['token'].toString());
  }
  
}