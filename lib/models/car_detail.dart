
class CarDetail{
  String id;
  String carNumber;
  String state;
  String description;
  List<String> images;

  CarDetail({
    required this.id,
    required this.carNumber,
    required this.description,
    required this.images,
    required this.state,
  });

  factory CarDetail.fromMap({required Map<String,dynamic> data}){

    Iterable imageList = data['car_crash_detail']??[];

    return CarDetail(
      id: data['id'].toString(),
      carNumber: data['car_number'].toString(),
      description: data['description'].toString(),
      state: data['state'].toString(),
      images: imageList.map((e) => e['image'].toString()).toList()
    );
  }

}