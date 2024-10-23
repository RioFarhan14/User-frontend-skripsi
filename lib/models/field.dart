class Field {
  final int id;
  final String name;
  final int price;
  final String image;
  final String description;

  Field({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['product_id'],
      name: json['product_name'],
      price: json['price'],
      image: json['image_url'],
      description: json['description'],
    );
  }
}
