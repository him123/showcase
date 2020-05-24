class Address {
  String id;
  String address;
  String name;
  String isSelected;
  String apt_suite_floor;

  Address({this.id, this.address, this.name, this.isSelected,this.apt_suite_floor});

  factory Address.fromMap(Map<String, dynamic> json) => new Address(
        id: json['id'],
        address: json['address_str'],
        name: json['type'],
        isSelected: json['is_selected'],
      );

  factory Address.fromJson(Map<String, dynamic> json) {
    return new Address(
        id: json['id'],
        address: json['street_address'],
        name: json['city_state_zip'],
        apt_suite_floor: json['apt_suite_floor'],
        isSelected: json['is_delivery_address']);
  }
}
