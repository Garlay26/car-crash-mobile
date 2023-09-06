
class CarAds{
  String id;
  String image;
  String link;

  CarAds({
    required this.id,
    required this.link,
    required this.image
  });

  factory CarAds.fromMap({required Map<String,dynamic> data}){
    return CarAds(
      id: data['id'].toString(),
      image: data['image'].toString(),
      link: data['link'].toString()
    );
  }

}