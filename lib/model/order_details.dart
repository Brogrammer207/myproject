class ModelOrderDetails {
  int? orderTimeInMilliSec;
  String? shipping;
  String? totalAmount;
  String? userId;
  UserDetails? userDetails;
  int? subTotal;
  List<ProductsList>? productsList;
  String? phoneNumber;
  String? transactionId;

  ModelOrderDetails(
      {this.orderTimeInMilliSec,
        this.shipping,
        this.totalAmount,
        this.userId,
        this.userDetails,
        this.subTotal,
        this.productsList,
        this.phoneNumber,
        this.transactionId});

  ModelOrderDetails.fromJson(Map<String, dynamic> json) {
    orderTimeInMilliSec = json['orderTimeInMilliSec'];
    shipping = json['shipping'];
    totalAmount = json['total_amount'];
    userId = json['user_id'];
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    subTotal = json['sub_total'];
    if (json['products_list'] != null) {
      productsList = <ProductsList>[];
      json['products_list'].forEach((v) {
        productsList!.add(ProductsList.fromJson(v));
      });
    }
    phoneNumber = json['phone_number'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderTimeInMilliSec'] = orderTimeInMilliSec;
    data['shipping'] = shipping;
    data['total_amount'] = totalAmount;
    data['user_id'] = userId;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    data['sub_total'] = subTotal;
    if (productsList != null) {
      data['products_list'] =
          productsList!.map((v) => v.toJson()).toList();
    }
    data['phone_number'] = phoneNumber;
    data['transactionId'] = transactionId;
    return data;
  }
}

class UserDetails {
  String? address;
  String? profile;
  String? name;
  String? email;

  UserDetails({this.address, this.profile, this.name, this.email});

  UserDetails.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    profile = json['profile'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['profile'] = profile;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}

class ProductsList {
  String? productId;
  ProductDetails? productDetails;
  int? productQuantity;

  ProductsList({this.productId, this.productDetails, this.productQuantity});

  ProductsList.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
    productQuantity = json['product_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }
    data['product_quantity'] = productQuantity;
    return data;
  }
}

class ProductDetails {
  int? price;
  String? imageUrl;
  String? name;
  String? description;
  String? category;

  ProductDetails(
      {this.price, this.imageUrl, this.name, this.description, this.category});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['description'] = description;
    data['category'] = category;
    return data;
  }
}
