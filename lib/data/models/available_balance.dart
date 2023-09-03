class AvailableBalance {
  String? balance;

  AvailableBalance({this.balance});

  AvailableBalance.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    return data;
  }
}
