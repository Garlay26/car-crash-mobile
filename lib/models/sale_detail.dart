//
// class SaleDetail{
//
//   String id;
//   String title;
//   String carNumber;
//   String owner;
//   int price;
//   String description;
//   DateTime createdAt;
//   List<String> images;
//
//   SaleDetail({
//     required this.id,
//     required this.title,
//     required this.carNumber,
//     required this.owner,
//     required this.description,
//     required this.createdAt,
//     required this.images,
//     required this.price
//   });
//
//   factory SaleDetail.fromMap({required Map<String,dynamic> data}){
//
//     Iterable rawImages = data['sale_detail']??[];
//
//     return SaleDetail(
//       id: data['id'].toString(),
//       title: data['title'].toString(),
//       description: data['description'].toString(),
//       carNumber: data['car_number'].toString(),
//       price: int.tryParse(data['price'].toString())??0,
//       createdAt: DateTime.tryParse(data['created_at'].toString())??DateTime(0),
//       owner: data['owner_name'].toString(),
//       images: rawImages.map((e) => e['image'].toString()).toList()
//     );
//
//   }
//
// }