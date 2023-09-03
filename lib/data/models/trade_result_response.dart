class UserTradeResultReponse {
  bool? status;
  String? message;
  UserTradeResult? data;

  UserTradeResultReponse({this.status, this.message, this.data});

  UserTradeResultReponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserTradeResult.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserTradeResult {
  num? winAmount;
  String? tradeType;
  num? startingPrice;
  String? status;

  UserTradeResult(
      {this.winAmount, this.tradeType, this.startingPrice, this.status});

  UserTradeResult.fromJson(Map<String, dynamic> json) {
    winAmount = json['win_amount'];
    tradeType = json['trade_type'];
    startingPrice = json['starting_price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['win_amount'] = winAmount;
    data['trade_type'] = tradeType;
    data['starting_price'] = startingPrice;
    data['status'] = status;
    return data;
  }
}
