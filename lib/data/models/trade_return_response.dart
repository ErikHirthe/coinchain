class UserTradeReturnReponse {
  bool? status;
  String? messages;
  String? uuid;

  UserTradeReturnReponse({this.status, this.messages, this.uuid});

  UserTradeReturnReponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['uuid'] = this.uuid;
    return data;
  }
}
