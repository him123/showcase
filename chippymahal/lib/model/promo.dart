class Promo {
  String id;
  String promo_code;
  String discount;
  String discount_type;
  String no_of_issue;
  String available;
  String reward_points_reached;
  String expiration_date;

  Promo(
      {this.id,
      this.promo_code,
      this.discount,
      this.discount_type,
      this.available,
      this.expiration_date,
      this.no_of_issue,
      this.reward_points_reached});


  factory Promo.fromJson(Map<String, dynamic> json) {
    return new Promo(
      id: json['id'],
      promo_code: json['promo_code'],
      discount: json['discount'],
      discount_type: json['discount_type'],
      available: json['available'],
      expiration_date: json['expiration_date'],
      no_of_issue: json['no_of_issue'],
      reward_points_reached: json['reward_points_reached'],
    );
  }
}
