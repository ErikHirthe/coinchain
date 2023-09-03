class UserTradeWebSocketResponse {
  bool? status;
  String? message;
  List<UserTradeWebSocket>? data;

  UserTradeWebSocketResponse({this.status, this.message, this.data});

  UserTradeWebSocketResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserTradeWebSocket>[];
      json['data'].forEach((v) {
        data!.add(UserTradeWebSocket.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserTradeWebSocket {
  String? uuid;
  String? coin;
  String? tradeType;
  String? tradeOptionDuration;
  String? tradeOptionDurationForshow;
  String? startTime;
  num? startingPrice;
  int? currentPrice;
  int? tradeAmount;
  String? countdown;

  UserTradeWebSocket(
      {this.uuid,
      this.coin,
      this.tradeType,
      this.tradeOptionDuration,
      this.tradeOptionDurationForshow,
      this.startTime,
      this.startingPrice,
      this.currentPrice,
      this.tradeAmount,
      this.countdown});

  UserTradeWebSocket.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    coin = json['coin'];
    tradeType = json['trade_type'];
    tradeOptionDuration = json['trade_option_duration'];
    tradeOptionDurationForshow = json['trade_option_duration_forshow'];
    startTime = json['start_time'];
    startingPrice = json['starting_price'];
    currentPrice = json['current_price'];
    tradeAmount = json['trade_amount'];
    countdown = json['countdown'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['coin'] = coin;
    data['trade_type'] = tradeType;
    data['trade_option_duration'] = tradeOptionDuration;
    data['trade_option_duration_forshow'] = tradeOptionDurationForshow;
    data['start_time'] = startTime;
    data['starting_price'] = startingPrice;
    data['current_price'] = currentPrice;
    data['trade_amount'] = tradeAmount;
    data['countdown'] = countdown;
    return data;
  }
}
