class Membership {
  final int id;
  final String name;
  final int price;
  final String image;

  Membership({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['product_id'],
      name: json['product_name'],
      price: json['price'],
      image: json['image_url'],
    );
  }
}
