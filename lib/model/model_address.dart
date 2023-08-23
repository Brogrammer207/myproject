class ModelAddress {
  String? address;
  String? city;
  String? phone;
  String? landmark;
  String? title;

  ModelAddress({this.address, this.city, this.phone, this.landmark, this.title});

  ModelAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    phone = json['phone'];
    landmark = json['landmark'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['city'] = city;
    data['phone'] = phone;
    data['landmark'] = landmark;
    data['title'] = title;
    return data;
  }
}

class ModelCityList {
  List<String>? cityList = [];

  ModelCityList({this.cityList});

  ModelCityList.fromJson(Map<String, dynamic> json) {
    if (json['cityList'] == null) {
      cityList = [];
      return;
    }
    cityList = json['cityList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityList'] = this.cityList;
    return data;
  }
}
