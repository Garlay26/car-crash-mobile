
enum NotiType{
  sale,
  news,
  crash
}

class NotiModel{

  String id;
  String title;
  String image;
  NotiType notiType;
  String typeId;
  DateTime dateTime;

  NotiModel({
    required this.id,
    required this.title,
    required this.image,
    required this.notiType,
    required this.typeId,
    required this.dateTime
  });

  factory NotiModel.fromMap({required Map<String,dynamic> data}){

    NotiType notiType = NotiType.news;

    if(data['type']!=null){
      switch(data['type'].toString().toUpperCase()){
        case "SALE" : notiType = NotiType.sale;break;
        case "NEW" : notiType = NotiType.news;break;
        case "CRASH" : notiType = NotiType.crash;break;
      }
    }

    return NotiModel(
      id: data['id'].toString(),
      title: data['title'].toString(),
      image: data['image'].toString(),
      notiType: notiType,
      typeId: data['type_id'].toString(),
      dateTime: DateTime.tryParse(data['created_at'].toString())??DateTime(0)
    );
  }

}