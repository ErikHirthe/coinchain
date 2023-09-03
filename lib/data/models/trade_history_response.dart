class TradeHistoryResponse {
  bool? status;
  String? message;
  List<TradeHistory>? data;

  TradeHistoryResponse({this.status, this.message, this.data});

  TradeHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TradeHistory>[];
      json['data'].forEach((v) {
        data!.add(TradeHistory.fromJson(v));
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

class TradeHistory {
  int? id;
  String? uuid;
  int? userId;
  String? tradeType;
  int? tradeOptionId;
  String? tradeOptionDuration;
  String? tradeOptionDurationForshow;
  String? startTime;
  String? endTime;
  String? coin;
  num? startingPrice;
  num? endPrice;
  String? profitOrLoss;
  int? tradeAmount;
  num? profitAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? countdown;

  TradeHistory(
      {this.id,
      this.uuid,
      this.userId,
      this.tradeType,
      this.tradeOptionId,
      this.tradeOptionDuration,
      this.tradeOptionDurationForshow,
      this.startTime,
      this.endTime,
      this.coin,
      this.startingPrice,
      this.endPrice,
      this.profitOrLoss,
      this.tradeAmount,
      this.profitAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.countdown});

  TradeHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    tradeType = json['trade_type'];
    tradeOptionId = json['trade_option_id'];
    tradeOptionDuration = json['trade_option_duration'];
    tradeOptionDurationForshow = json['trade_option_duration_forshow'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    coin = json['coin'];
    startingPrice = json['starting_price'];
    endPrice = json['end_price'];
    profitOrLoss = json['profit_or_loss'];
    tradeAmount = json['trade_amount'];
    profitAmount = json['profit_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    countdown = json['countdown'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['user_id'] = userId;
    data['trade_type'] = tradeType;
    data['trade_option_id'] = tradeOptionId;
    data['trade_option_duration'] = tradeOptionDuration;
    data['trade_option_duration_forshow'] = tradeOptionDurationForshow;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['coin'] = coin;
    data['starting_price'] = startingPrice;
    data['end_price'] = endPrice;
    data['profit_or_loss'] = profitOrLoss;
    data['trade_amount'] = tradeAmount;
    data['profit_amount'] = profitAmount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['countdown'] = countdown;
    return data;
  }
}
