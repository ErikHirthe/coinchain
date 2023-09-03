import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/trade_history_response.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/data/models/user_trade_websocket.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/spacers.dart';
import 'dashboard_controller.dart';

class HistoryTabViews extends StatefulWidget {
  final String? fromPage;

  const HistoryTabViews({Key? key, this.fromPage}) : super(key: key);

  @override
  HistoryTabViewsState createState() => HistoryTabViewsState();
}

class HistoryTabViewsState extends State<HistoryTabViews>
    with TickerProviderStateMixin {
  final _controller = Get.find<DashboardController>();
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedSubTabIndex = 0.obs;
  TabController? orderTabController;
  late TradeHistoryResponse? finishedTrades;
  User user = gUserRx.value;
  final WebSocketChannel _socketChannel = WebSocketChannel.connect(
    Uri.parse("ws://staging.coins-chain.com:8090"),
  );

  sendSubscribe() {
    _socketChannel.sink.add(jsonEncode({
      "command": "pendingTrades",
      "user_id": user.id,
    }));
  }

  sendUnsubscribe() {
    _socketChannel.sink.add(jsonEncode({"command": "unsubscribe"}));
    _socketChannel.sink.close();
  }

  @override
  void initState() {
    orderTabController = TabController(vsync: this, length: 2);
    sendSubscribe();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    sendUnsubscribe();
    super.dispose();
  }

  void getData() {
    // finishedTrades = TradeHistoryResponse();
    // showLoadingDialog();
    // APIRepository().userTradeHistory(tradeHistoryStatus: "Finished").then(
    //     (response) {
    //   if (response.success) {
    //     hideLoadingDialog();
    //     if (finishedTrades!.data!.isNotEmpty) {
    //       finishedTrades!.data!.clear();
    //     }

    //     finishedTrades = TradeHistoryResponse.fromJson(response.data);
    //     debugPrint("API ==> $finishedTrades");
    //   }
    // }, onError: (err) {
    //   hideLoadingDialog();
    //   showToast(err.toString());
    // });

    // if (selectedTabIndex.value == 0) {
    //   _controller.getUserTradeHistory(tradeHistoryStatus: "In progress");
    // } else if (selectedTabIndex.value == 1) {
    //   _controller.getUserTradeHistory(tradeHistoryStatus: "Finished");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      width: context.width,
      decoration: boxDecorationRoundBorder(),
      child: Column(
        children: [
          // tabBarUnderline(
          //     ["Open Trades".tr, "Trade History".tr], orderTabController,
          //     onTap: (index) {
          //   selectedTabIndex.value = index;

          //   getData();
          // }),
          // dividerHorizontal(height: 0),
          // vSpacer10(),
          StreamBuilder(
              stream: _socketChannel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final response = UserTradeWebSocketResponse.fromJson(
                      jsonDecode(snapshot.data.toString()));
                  debugPrint(snapshot.data.toString());
                  return response.data!.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: response.data!.length,
                          itemBuilder: (context, index) {
                            final history = response.data![index];
                            return ListTile(
                              title: Text(
                                history.coin!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        padding: const EdgeInsets.only(
                                            top: 1,
                                            bottom: 1,
                                            left: 10,
                                            right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: history.tradeType == "Buy"
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
                                        ),
                                        child: Text(
                                          history.tradeType!,
                                          style: TextStyle(
                                              color: history.tradeType == "Buy"
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        "Execution Price: ${history.startingPrice?.toStringAsFixed(2)}",
                                      ),
                                      Text(
                                        "Current Price: ${history.currentPrice?.toStringAsFixed(2)}",
                                      ),
                                      Text(
                                          "Duration: ${history.tradeOptionDurationForshow}")
                                    ],
                                  ),
                                  Center(
                                    child: Text(history.countdown!),
                                  )
                                  // Container(
                                  //   padding: const EdgeInsets.all(0),
                                  //   width: 20,
                                  //   height: 20,
                                  //   child: CircularProgressIndicator(
                                  //     strokeWidth: 5,
                                  //     valueColor: const AlwaysStoppedAnimation(
                                  //       Colors.blue,
                                  //     ),
                                  //     backgroundColor: const Color.fromARGB(
                                  //         255, 237, 237, 237),
                                  //     value: 20 /
                                  //         int.parse(
                                  //             history.tradeOptionDuration!),
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("There is no background trading"),
                        );
                } else if (snapshot.hasError) {
                  showToast(snapshot.error.toString(), isError: true);
                }
                return const Center(child: CircularProgressIndicator());
              }),
          // Obx(
          //   () => gUserRx.value.id == 0
          //       ? Padding(
          //           padding: const EdgeInsets.all(Dimens.paddingMid),
          //           child: textSpanWithAction("Want to trade".tr, "Login".tr,
          //               () => Get.to(() => const SignInPage())),
          //         )
          //       : _listView(),
          // ),
        ],
      ),
    );
  }

  // Widget _listView() {
  //   return Obx(() {
  //     return _controller.tradeHistoryList.isEmpty
  //         ? handleEmptyViewWithLoading(_controller.isHistoryLoading.value)
  //         : Column(
  //             children: List.generate(
  //                 _controller.tradeHistoryList.length,
  //                 (index) =>
  //                     _historyItemView(_controller.tradeHistoryList[index])),
  //           );
  //   });
  // }

  Widget _listView() {
    return Obx(() {
      return _controller.tradeHistorys.value.data!.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: _controller.tradeHistorys.value.data!.map((e) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      e.coin!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              padding: const EdgeInsets.only(
                                  top: 1, bottom: 1, left: 10, right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: e.tradeType == "Buy"
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                              ),
                              child: Text(
                                e.tradeType!,
                                style: TextStyle(
                                    color: e.tradeType == "Buy"
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "Buy Price: ${e.startingPrice?.toStringAsFixed(2)}",
                            ),
                            Text(
                              "Sell Price: ${e.endPrice?.toStringAsFixed(2)}",
                            ),
                            Text("Duration: ${e.tradeOptionDuration}")
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: e.tradeAmount.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: const [
                                  TextSpan(
                                    text: ' USDT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "profit & loss",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              e.profitAmount != null
                                  ? e.profitOrLoss == 'Loss'
                                      ? '-${e.profitAmount.toString()}'
                                      : '+${e.profitAmount.toString()}'
                                  : e.profitOrLoss!,
                              style: TextStyle(
                                color: e.profitOrLoss == "Loss"
                                    ? Colors.red
                                    : e.profitOrLoss == 'Pending'
                                        ? Colors.orange
                                        : Colors.green,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          : handleEmptyViewWithLoading(_controller.isHistoryLoading.value);
    });
  }

  Widget _historyItemView(Trade trade) {
    final color = trade.type == FromKey.buy ? Colors.green : Colors.red;
    final tradeCoin =
        _controller.dashboardData.value.orderData?.tradeCoin ?? "";
    final baseCoin = _controller.dashboardData.value.orderData?.baseCoin ?? "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
      child: Column(
        children: [
          if (selectedTabIndex.value != 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: twoTextView("${"Type".tr}: ", trade.type ?? "",
                        subColor: color)),
                if (selectedTabIndex.value == 0)
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _controller.cancelOpenOrderApp(trade),
                      child: textAutoSizeKarla("Cancel".tr,
                          color: context.theme.colorScheme.secondary,
                          fontSize: Dimens.regularFontSizeMid,
                          textAlign: TextAlign.end),
                    ),
                  )
              ],
            ),
          if (selectedTabIndex.value == 2)
            twoTextView("${"Transaction Id".tr}: ", trade.transactionId ?? ""),
          vSpacer2(),
          if (selectedTabIndex.value == 1)
            twoTextView("${"Pair".tr}: ", "$tradeCoin/$baseCoin"),
          if (selectedTabIndex.value == 1) vSpacer2(),
          twoTextView("${"Amount".tr}($tradeCoin): ", coinFormat(trade.amount)),
          vSpacer2(),
          twoTextView("${"Fees".tr}($baseCoin): ", coinFormat(trade.fees)),
          vSpacer2(),
          twoTextView("${"Price".tr}($baseCoin): ", coinFormat(trade.price)),
          vSpacer2(),
          if (selectedTabIndex.value != 1)
            twoTextView(
                "${"Processed".tr}($tradeCoin): ", coinFormat(trade.processed)),
          if (selectedTabIndex.value != 1) vSpacer2(),
          if (selectedTabIndex.value != 2)
            twoTextView("${"Total".tr}($baseCoin): ", coinFormat(trade.total)),
          if (selectedTabIndex.value != 2) vSpacer2(),
          twoTextView(
              "${"Created At".tr}: ",
              formatDate(trade.createdAt,
                  format: dateTimeFormatDdMMMMYyyyHhMm)),
          dividerHorizontal()
        ],
      ),
    );
  }

  String countDown(int remainSeconds) {
    //int remainSeconds = seconds;
    String myTime = "00:00:00";
    Timer? _timer;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainSeconds < 0) {
        timer.cancel();
      }
      int minutes = remainSeconds ~/ 60;
      int seconds = remainSeconds % 60;

      remainSeconds--;

      myTime =
          "${minutes.toString().padLeft(2, "0")} : ${seconds.toString().padLeft(2, "0")}";
    });

    return myTime;
  }
}
