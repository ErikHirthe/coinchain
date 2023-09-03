class WithdrawHistory {
  String? type;
  String? address;
  double? amount;
  String? status;
  String? createdAt;

  WithdrawHistory(
      {this.type, this.address, this.amount, this.status, this.createdAt});

  WithdrawHistory.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    address = json['address'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['address'] = address;
    data['amount'] = amount;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
