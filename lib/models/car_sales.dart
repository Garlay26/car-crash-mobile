
class CarSales{

  String id;
  String title;
  String description;
  String ownerName;
  String carNumber;
  int price;
  DateTime dateTime;
  List<String> images;

  CarSales({
    required this.id,
    required this.dateTime,
    required this.images,
    required this.title,
    required this.description,
    required this.carNumber,
    required this.price,
    required this.ownerName
  });

  factory CarSales.fromMap({required Map<String,dynamic> data}){
    return CarSales(
      id: data['id'].toString(),
      title: data['title'].toString(),
      description: data['description'].toString(),
      carNumber: data['car_number'].toString(),
      ownerName: data['owner_name'].toString(),
      price: int.tryParse(data['price'].toString())??0,
      dateTime: DateTime.tryParse(data['created_at'].toString())??DateTime(2000),
      images: ((data['sale_detail']??[]) as Iterable).map((e) => e['image'].toString()).toList()
    );
  }

}