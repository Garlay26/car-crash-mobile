
class CarNews{

  String id;
  String title;
  String content;
  String image;
  DateTime dateTime;

  CarNews({
    required this.id,
    required this.dateTime,
    required this.image,
    required this.title,
    required this.content,
  });

  factory CarNews.fromMap({required Map<String,dynamic> data}){
    return CarNews(
      id: data['id'].toString(),
      title: data['title'].toString(),
      content: data['content'].toString(),
      image: data['image'].toString(),
      dateTime: DateTime.tryParse(data['created_at'].toString())??DateTime(2000)
    );
  }

}