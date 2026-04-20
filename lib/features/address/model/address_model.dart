class AddressModel {
  final String city;
  final String area;
  final String street;
  final String building;

  AddressModel({
    required this.city,
    required this.area,
    required this.street,
    required this.building,
  });

  // لتحويل البيانات من وإلى Map للتخزين في Hive
  Map<String, dynamic> toMap() => {
    'city': city, 'area': area, 'street': street, 'building': building,
  };

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
    city: map['city'], area: map['area'], street: map['street'], building: map['building'],
  );
}