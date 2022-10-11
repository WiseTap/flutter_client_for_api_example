

class CreateProductReqBody {
  final String name;
  final double price;
  final int stockQuantity;
  final String internalCode;

  CreateProductReqBody({required this.name, required this.price, required this.stockQuantity, required this.internalCode});

  toMap() => {
    'name': name,
    'price': price,
    'stockQuantity': stockQuantity,
    'internalCode': internalCode,
  };
}