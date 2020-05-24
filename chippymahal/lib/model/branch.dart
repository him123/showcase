class Branch {
  final String id;
  final String branch_name;
  final String branch_address;
  final String branch_zip;
  final String branch_phone;

  Branch(
      {this.id,
      this.branch_name,
      this.branch_address,
      this.branch_zip,
      this.branch_phone});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return new Branch(
      id: json['id'],
      branch_name: json['branch_name'],
      branch_address: json['branch_address'],
      branch_zip: json['branch_zip'],
      branch_phone: json['branch_phone'],
    );
  }
}
