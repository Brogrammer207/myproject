class ModelAddress {
  String? address;
  String? city;
  String? phone;
  String? landmark;
  String? title;

  ModelAddress(
      {this.address, this.city, this.phone, this.landmark, this.title});

  ModelAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    phone = json['phone'];
    landmark = json['landmark'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['landmark'] = this.landmark;
    data['title'] = this.title;
    return data;
  }
}
