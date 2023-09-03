import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import '../../../../data/models/user.dart';
import '../../../../utils/appbar_util.dart';
import '../../auth/sign_in/sign_in_screen.dart';
import 'dashboard_controller.dart';
import 'dart:math';

class BuySellTabViews extends StatefulWidget {
  final String? fromPage;
  const BuySellTabViews({Key? key, this.fromPage}) : super(key: key);

  @override
  BuySellTabViewsState createState() => BuySellTabViewsState();
}

class BuySellTabViewsState extends State<BuySellTabViews>
    with SingleTickerProviderStateMixin {
  final _controller = Get.find<DashboardController>();
  final _tradeCountdownController = Get.put(TradeCountdownController());
  final priceEditController = TextEditingController();
  final amountEditController = TextEditingController();
  final totalEditController = TextEditingController();
  final limitEditController = TextEditingController();
  String currentPrice = "";
  double percentage = 1.0;
  Color expectedColor = Colors.green;
  String expectedPrice = '';

  TabController? buySellTabController;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedBuySubTabIndex = 0.obs;
  RxInt selectedSellSubTabIndex = 0.obs;

  int selectedIndex = 0;
  int minValue = 0;
  int maxValue = 0;
  int durationLeft = 0;
  int selectedDuration = 0;
  int tradePercentage = 0;
  String selectedDurationForShow = '';

  final TextEditingController betAmountController = TextEditingController();

  @override
  void initState() {
    selectedTabIndex.value = (widget.fromPage == FromKey.buy ? 0 : 1);
    buySellTabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: selectedTabIndex.value,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
        decoration: boxDecorationRoundBorder(),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 35,
              child: tabBarUnderline(
                  ["Buy".tr, "Sell".tr], buySellTabController, onTap: (index) {
                selectedTabIndex.value = index;
                _clearInputViews();
              }),
            ),
            dividerHorizontal(height: 0),
            vSpacer10(),
            Obx(() => _buySellTabView(selectedTabIndex.value))
          ],
        ),
      ),
    );
  }

  Widget _buySellTabView(int tabIndex) {
    final total = _controller.dashboardData.value.orderData?.total;
    final tradeOptions = _controller.tradeOptions.value;

    final dbData = _controller.dashboardData.value;
    PriceData? lastPData;
    if (dbData.lastPriceData.isValid) lastPData = dbData.lastPriceData?.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
      child: Obx(() {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name".tr,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      Text(
                        "${total?.tradeWallet?.coinType ?? ""}/${total?.baseWallet?.coinType ?? ""}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Direction".tr,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      Text(
                        selectedTabIndex.value == 0 ? "Buy".tr : "Sell".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedTabIndex.value == 0
                                ? Colors.green
                                : Colors.red),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current".tr,
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      Text(
                        "${lastPData?.lastPrice}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 237, 237, 237), //new Color.fromRGBO(255, 0, 0, 0.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose the expire time".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: tradeOptions.tradeOptions!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: InkWell(
                                onTap: () {
                                  selectedIndex = e.id!;
                                  minValue = e.minimumAmount!;
                                  maxValue = e.maximumAmount!;
                                  durationLeft = int.parse(e.durationTime!);
                                  selectedDuration = int.parse(e.durationTime!);
                                  selectedDurationForShow =
                                      e.durationTimeForshow!;
                                  tradePercentage = e.percent!;
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: selectedIndex == e.id
                                            ? Colors.amber
                                            : const Color.fromARGB(
                                                255, 194, 194, 194),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Text(
                                        e.durationTimeForshow!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: selectedIndex == e.id
                                            ? const Color.fromARGB(
                                                255, 255, 225, 133)
                                            : const Color.fromARGB(
                                                255, 225, 225, 225),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Text(
                                        "${e.percent}%",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 237, 237, 237), //new Color.fromRGBO(255, 0, 0, 0.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Buy Quantity".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: betAmountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Min $minValue and Max $maxValue",
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Available balance: ${double.parse(tradeOptions.availableBalance!.balance!).toStringAsFixed(2)}"),
                Text("Handling ${tradeOptions.tradeHandlingFee!.handlingFee!}%")
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedTabIndex.value == 0 ? Colors.green : Colors.red,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {
                  final tradeAmount = betAmountController.text;

                  if (selectedIndex == 0) {
                    showToast("Choose trade option first!");
                    return;
                  }

                  if (tradeAmount.isEmpty || int.parse(tradeAmount) <= 0) {
                    showToast("Minimum amount is $minValue");
                    return;
                  }
                  if (int.parse(tradeAmount) < minValue) {
                    showToast("Minimum amount is $minValue");
                    return;
                  }
                  if (int.parse(tradeAmount) > maxValue) {
                    showToast("Maximum amount is $maxValue");
                    return;
                  }

                  if (double.parse(tradeAmount) >
                      double.parse(tradeOptions.availableBalance!.balance!)) {
                    showToast("You have not enough balance");
                    return;
                  }

                  if (lastPData?.lastPrice == null) {
                    showToast("Price is updating. Please try again soon!");
                    return;
                  }
                  final tradeType =
                      selectedTabIndex.value == 0 ? "Buy" : "Sell";

                  _controller.postUserTrade(
                    tradeType: tradeType,
                    tradeOptionID: selectedIndex,
                    tradeOptionDuration: selectedDuration.toString(),
                    tradeOptionDurationForshow: selectedDurationForShow,
                    tradeAmount: double.parse(tradeAmount),
                    coin:
                        "${total?.tradeWallet?.coinType ?? ""}/${total?.baseWallet?.coinType ?? ""}",
                    startingPrice: lastPData?.lastPrice,
                    handlingFee: tradeOptions.tradeHandlingFee!.handlingFee!,
                  );

                  _tradeCountdownController.startTimer(durationLeft);
                  _tradeCountdownController.tradeType = selectedTabIndex.value;
                  _tradeCountdownController.lastPrice =
                      lastPData!.lastPrice ?? 100;
                  _tradeCountdownController.tradePercentage = tradePercentage;
                  _tradeCountdownController.tradeAmount = tradeAmount;

                  var tradeResult =
                      _controller.userTradeResultResponse.value.data;

                  Get.defaultDialog(
                      title:
                          "${total?.tradeWallet?.coinType ?? ""}/${total?.baseWallet?.coinType ?? ""}",
                      titleStyle: const TextStyle(color: Colors.black),
                      contentPadding: const EdgeInsets.all(16),
                      content: GetX<TradeCountdownController>(
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Dialog Header
                            _tradeCountdownController.finishedTrading.value ==
                                    false
                                ? Container(
                                    padding: const EdgeInsets.all(0),
                                    width: 300,
                                    height: 260,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 8,
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                            Colors.blue,
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                              255, 237, 237, 237),
                                          value: _tradeCountdownController
                                                  .remainSeconds /
                                              selectedDuration,
                                        ),
                                        Center(
                                          child: Text(
                                            _tradeCountdownController
                                                .time.value,
                                            style: const TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        _controller.userTradeResultResponse
                                                .value.data?.winAmount
                                                .toString() ??
                                            'N/A',
                                        style: TextStyle(
                                          color: _controller
                                                      .userTradeResultResponse
                                                      .value
                                                      .data
                                                      ?.status ==
                                                  'Profit'
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 36,
                                        ),
                                      ),
                                      Text(
                                        "Expiry settlement completed".tr,
                                      ),
                                    ],
                                  ),

                            // Dialog Body
                            vSpacer20(),
                            _tradeCountdownController.finishedTrading.value ==
                                    false
                                ? Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 237, 237, 237),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Current".tr,
                                              style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 14),
                                            ),
                                            Obx(() => Text(
                                                  _tradeCountdownController
                                                      .currentPrice.value,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Direction".tr,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              selectedTabIndex.value == 0
                                                  ? "Buy".tr
                                                  : "Sell".tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color:
                                                      selectedTabIndex.value ==
                                                              0
                                                          ? Colors.green
                                                          : Colors.red),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Trade Amount".tr,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              "$tradeAmount USDT",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Execution Price".tr,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              "${lastPData?.lastPrice}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(
                                              () => Text(
                                                "Expected".tr,
                                                style: TextStyle(
                                                  color:
                                                      _tradeCountdownController
                                                          .expectedColor.value,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Obx(() => Text(
                                                  _tradeCountdownController
                                                      .expectedPrice.value,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color:
                                                        _tradeCountdownController
                                                            .expectedColor
                                                            .value,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 237, 237, 237),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Direction".tr,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              _controller
                                                      .userTradeResultResponse
                                                      .value
                                                      .data
                                                      ?.tradeType ??
                                                  'N/A',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: _controller
                                                              .userTradeResultResponse
                                                              .value
                                                              .data
                                                              ?.tradeType ==
                                                          "Buy"
                                                      ? Colors.green
                                                      : Colors.red),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Trade Amount".tr,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              "$tradeAmount USDT",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Execution Price".tr,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Obx(
                                              () => Text(
                                                _controller
                                                        .userTradeResultResponse
                                                        .value
                                                        .data
                                                        ?.startingPrice
                                                        .toString() ??
                                                    'N/A',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Status".tr,
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Obx(
                                              () => Text(
                                                _controller
                                                        .userTradeResultResponse
                                                        .value
                                                        .data
                                                        ?.status ??
                                                    'N/A',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: _controller
                                                              .userTradeResultResponse
                                                              .value
                                                              .data
                                                              ?.status ==
                                                          'Profit'
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () {
                              setState(() async {
                                Get.back(closeOverlays: true);
                              });
                            },
                            child: const Text("Continue to place order"),
                          ),
                        )
                      ]);

                  // if (!_tradeCountdownController.finishedTrading.value) {
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       var tradeResult =
                  //           _controller.userTradeResultResponse.value.data;
                  //       var profitAmount =
                  //           tradeResult?.profitAmount?.toInt() ?? 0;
                  //       var tradeAmount =
                  //           tradeResult?.tradeAmount?.toInt() ?? 0;
                  //       final winAmount = profitAmount + tradeAmount;
                  //       return AlertDialog(
                  //         title: Text(
                  //           "${total?.tradeWallet?.coinType ?? ""}/${total?.baseWallet?.coinType ?? ""}",
                  //           style: const TextStyle(color: Colors.black),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //         content: GetX<TradeCountdownController>(
                  //           builder: (context) => Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Obx(
                  //                 () => _tradeCountdownController
                  //                             .finishedTrading.value ==
                  //                         false
                  //                     ? Container(
                  //                         padding: const EdgeInsets.all(0),
                  //                         width: 300,
                  //                         height: 260,
                  //                         child: Stack(
                  //                           fit: StackFit.expand,
                  //                           children: [
                  //                             CircularProgressIndicator(
                  //                               strokeWidth: 8,
                  //                               valueColor:
                  //                                   const AlwaysStoppedAnimation(
                  //                                 Colors.blue,
                  //                               ),
                  //                               backgroundColor:
                  //                                   const Color.fromARGB(
                  //                                       255, 237, 237, 237),
                  //                               value: _tradeCountdownController
                  //                                       .remainSeconds /
                  //                                   selectedDuration,
                  //                             ),
                  //                             Center(
                  //                               child: Text(
                  //                                 _tradeCountdownController
                  //                                     .time.value,
                  //                                 style: const TextStyle(
                  //                                   fontSize: 50,
                  //                                   fontWeight: FontWeight.bold,
                  //                                   color: Colors.blue,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       )
                  //                     : Column(
                  //                         children: [
                  //                           Text(
                  //                             winAmount.toString(),
                  //                             style: const TextStyle(
                  //                               color: Colors.blue,
                  //                               fontSize: 36,
                  //                             ),
                  //                           ),
                  //                           Text("Expiry settlement completed"
                  //                               .tr),
                  //                         ],
                  //                       ),
                  //               ),
                  //               const SizedBox(height: 20),
                  //               Container(
                  //                 padding: const EdgeInsets.all(15),
                  //                 decoration: const BoxDecoration(
                  //                   color: Color.fromARGB(255, 237, 237, 237),
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(10.0)),
                  //                 ),
                  //                 child: Column(
                  //                   children: [
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text(
                  //                           "Current".tr,
                  //                           style: const TextStyle(
                  //                               color: Colors.blueGrey,
                  //                               fontSize: 14),
                  //                         ),
                  //                         Obx(() => Text(
                  //                               _tradeCountdownController
                  //                                   .currentPrice.value,
                  //                               style: const TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontSize: 14,
                  //                                 color: Colors.black,
                  //                               ),
                  //                             )),
                  //                       ],
                  //                     ),
                  //                     const SizedBox(height: 5),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text(
                  //                           "Direction".tr,
                  //                           style: const TextStyle(
                  //                             color: Colors.blueGrey,
                  //                             fontSize: 14,
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           selectedTabIndex.value == 0
                  //                               ? "Buy".tr
                  //                               : "Sell".tr,
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.bold,
                  //                               fontSize: 14,
                  //                               color:
                  //                                   selectedTabIndex.value == 0
                  //                                       ? Colors.green
                  //                                       : Colors.red),
                  //                         )
                  //                       ],
                  //                     ),
                  //                     const SizedBox(height: 5),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text(
                  //                           "Trade Amount".tr,
                  //                           style: const TextStyle(
                  //                             color: Colors.blueGrey,
                  //                             fontSize: 14,
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           "$tradeAmount USDT",
                  //                           style: const TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             fontSize: 14,
                  //                             color: Colors.black,
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                     const SizedBox(height: 5),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text(
                  //                           "Execution Price".tr,
                  //                           style: const TextStyle(
                  //                             color: Colors.blueGrey,
                  //                             fontSize: 14,
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           "${lastPData?.lastPrice}",
                  //                           style: const TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             fontSize: 14,
                  //                             color: Colors.black,
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                     const SizedBox(height: 5),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Obx(
                  //                           () => Text(
                  //                             "Expected".tr,
                  //                             style: TextStyle(
                  //                               color: _tradeCountdownController
                  //                                   .expectedColor.value,
                  //                               fontSize: 14,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Obx(() => Text(
                  //                               _tradeCountdownController
                  //                                   .expectedPrice.value,
                  //                               style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontSize: 14,
                  //                                 color:
                  //                                     _tradeCountdownController
                  //                                         .expectedColor.value,
                  //                               ),
                  //                             ))
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         actions: [
                  //           // TextButton(
                  //           //   child: const Text("OK"),
                  //           //   onPressed: () {},
                  //           // ),
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //               left: 15,
                  //               right: 15,
                  //               bottom: 15,
                  //             ),
                  //             child: ElevatedButton(
                  //               style: ElevatedButton.styleFrom(
                  //                 backgroundColor: Colors.green,
                  //                 minimumSize: const Size.fromHeight(50), // NEW
                  //               ),
                  //               onPressed: () {
                  //                 setState(() async {
                  //                   showToast("Coming Soon", isError: false);
                  //                 });
                  //               },
                  //               child: const Text("Continue to place order"),
                  //             ),
                  //           )
                  //         ],
                  //       );
                  //     },
                  //   );
                  // } else {
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       var tradeResult =
                  //           _controller.userTradeResultResponse.value.data;
                  //       var profitAmount =
                  //           tradeResult?.profitAmount?.toInt() ?? 0;
                  //       var tradeAmount =
                  //           tradeResult?.tradeAmount?.toInt() ?? 0;
                  //       final winAmount = profitAmount + tradeAmount;
                  //       return AlertDialog(
                  //         title: Text(
                  //           "${total?.tradeWallet?.coinType ?? ""}/${total?.baseWallet?.coinType ?? ""}",
                  //           style: const TextStyle(color: Colors.black),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //         content: Obx(() => Column(
                  //               children: [
                  //                 Text(winAmount.toString()),
                  //                 Text("Expiry settlement completed".tr),
                  //                 vSpacer15(),
                  //                 Container(
                  //                   padding: const EdgeInsets.all(15),
                  //                   decoration: const BoxDecoration(
                  //                     color: Color.fromARGB(255, 237, 237, 237),
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(10.0)),
                  //                   ),
                  //                   child: Column(
                  //                     children: [
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Text(
                  //                             "Direction".tr,
                  //                             style: const TextStyle(
                  //                               color: Colors.blueGrey,
                  //                               fontSize: 14,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             tradeResult?.tradeType ?? 'N/A',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontSize: 14,
                  //                                 color:
                  //                                     tradeResult?.tradeType ==
                  //                                             "Buy"
                  //                                         ? Colors.green
                  //                                         : Colors.red),
                  //                           )
                  //                         ],
                  //                       ),
                  //                       const SizedBox(height: 5),
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Text(
                  //                             "Trade Amount".tr,
                  //                             style: const TextStyle(
                  //                               color: Colors.blueGrey,
                  //                               fontSize: 14,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             "$tradeAmount USDT",
                  //                             style: const TextStyle(
                  //                               fontWeight: FontWeight.bold,
                  //                               fontSize: 14,
                  //                               color: Colors.black,
                  //                             ),
                  //                           )
                  //                         ],
                  //                       ),
                  //                       const SizedBox(height: 5),
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Text(
                  //                             "Execution Price".tr,
                  //                             style: const TextStyle(
                  //                               color: Colors.blueGrey,
                  //                               fontSize: 14,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             tradeResult?.startingPrice
                  //                                     .toString() ??
                  //                                 'N/A',
                  //                             style: const TextStyle(
                  //                               fontWeight: FontWeight.bold,
                  //                               fontSize: 14,
                  //                               color: Colors.black,
                  //                             ),
                  //                           )
                  //                         ],
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             )),
                  //       );
                  //     },
                  //   );
                  // }
                },
                child: const Text("Place Order"))
          ],
        );
      }),
    );
  }

  Widget _inputViews(int index, SelfBalance? selfBalance) {
    bool isBuy = selectedTabIndex.value == 0;
    final total = selfBalance?.total;
    final baseCType = total?.baseWallet?.coinType ?? "";
    final tradeCType = total?.tradeWallet?.coinType ?? "";
    final balance = isBuy
        ? "${coinFormat(total?.baseWallet?.balance)} $baseCType"
        : "${coinFormat(total?.tradeWallet?.balance)} $tradeCType";
    final price = (isBuy ? selfBalance?.sellPrice : selfBalance?.buyPrice) ?? 0;

    return Column(
      children: [
        twoTextSpace('Total'.tr, 'Available'.tr,
            color: context.theme.primaryColor),
        vSpacer5(),
        twoTextSpaceBackground(balance, balance,
            bgColor: gIsDarkMode ? null : context.theme.primaryColorLight,
            height: 30),
        vSpacer10(),
        textFieldWithPrefixSuffixText(
            controller: priceEditController,
            prefixText: index == 2 ? "Stop".tr : "Price".tr,
            text: index == 2 ? "" : price.toString(),
            suffixText: baseCType,
            isEnable: index != 1,
            onTextChange: _onInputAmount),
        vSpacer10(),
        if (index == 2)
          textFieldWithPrefixSuffixText(
              controller: limitEditController,
              prefixText: "Limit".tr,
              suffixText: baseCType),
        if (index == 2) vSpacer10(),
        textFieldWithPrefixSuffixText(
            controller: amountEditController,
            prefixText: "Amount".tr,
            suffixText: tradeCType,
            onTextChange: _onInputAmount),
        vSpacer10(),
        if (index != 1)
          textFieldWithPrefixSuffixText(
              controller: totalEditController,
              prefixText: "Total Amount".tr,
              suffixText: baseCType,
              isEnable: false),
        if (index != 1) vSpacer10(),
        _buttonView(gUserRx.value)
      ],
    );
  }

  Widget _buttonView(User user) {
    return user.id == 0
        ? buttonRoundedMain(
            text: "Login".tr,
            bgColor: Colors.red,
            width: context.width / 2,
            onPressCallback: () => Get.offAll(() => const SignInPage()))
        : Column(
            children: [
              Table(
                border:
                    TableBorder.all(color: context.theme.colorScheme.secondary),
                children: [
                  TableRow(
                      children: List.generate(
                          ListConstants.percents.length,
                          (index) => InkWell(
                                onTap: () => _tapOnPercentItem(
                                    ListConstants.percents[index]),
                                child: Container(
                                    height: Dimens.btnHeightMin,
                                    alignment: Alignment.center,
                                    child: textAutoSizeKarla(
                                        "${ListConstants.percents[index]}%",
                                        fontSize: Dimens.regularFontSizeMid)),
                              )))
                ],
              ),
              vSpacer10(),
              buttonRoundedMain(
                  text: "Place Order".tr,
                  bgColor:
                      selectedTabIndex.value == 0 ? Colors.green : Colors.red,
                  onPressCallback: () => _checkInputData())
            ],
          );
  }

  void _onInputAmount(String amountStr) {
    if (selectedBuySubTabIndex.value == 1 || selectedSellSubTabIndex.value == 1)
      return;
    var price = makeDouble(priceEditController.text.trim());
    if (selectedBuySubTabIndex.value == 2 ||
        selectedSellSubTabIndex.value == 2) {
      price = selectedTabIndex.value == 0
          ? _controller.dashboardData.value.orderData?.sellPrice ?? 0
          : _controller.dashboardData.value.orderData?.buyPrice ?? 0;
    }
    final amount = makeDouble(amountEditController.text.trim());
    totalEditController.text = (amount * price).toString();
  }

  void _tapOnPercentItem(String percentStr) {
    final percent = double.parse(percentStr) / 100;
    final dData = _controller.dashboardData.value;
    final isBuy = selectedTabIndex.value == 0;
    var price = makeDouble(priceEditController.text.trim());

    if (isBuy) {
      if (selectedBuySubTabIndex.value == 2) {
        price = makeDouble(limitEditController.text.trim());
      }
      if (price <= 0) {
        showToast(selectedBuySubTabIndex.value == 2
            ? "Please input your limit".tr
            : "Please input your price".tr);
        return;
      }

      //final amount = (dData.orderData?.total?.baseWallet?.balance ?? 0) / price;
      final amount =
          (_controller.selfBalance.value.total?.baseWallet?.balance ?? 0) /
              price;
      final feesPercentage = ((dData.feesSettings?.makerFees ?? 0) >
                  (dData.feesSettings?.takerFees ?? 0)
              ? dData.feesSettings?.makerFees
              : dData.feesSettings?.takerFees) ??
          0;
      final total = amount * percent * price;
      final fees = (total * feesPercentage) / 100;

      amountEditController.text = coinFormat((total - fees) / price);
      if (selectedBuySubTabIndex.value != 1) {
        totalEditController.text = coinFormat(total - fees);
      }
    } else {
      if (selectedSellSubTabIndex.value == 2) {
        price = makeDouble(limitEditController.text.trim());
      }
      if (price <= 0) {
        showToast(selectedSellSubTabIndex.value == 2
            ? "Please input your limit".tr
            : "Please input your price".tr);
        return;
      }
      // final amountPercentage = (dData.orderData?.total?.tradeWallet?.balance ?? 0) * percent;
      final amountPercentage =
          (_controller.selfBalance.value.total?.tradeWallet?.balance ?? 0) *
              percent;
      amountEditController.text = coinFormat(amountPercentage);
      if (selectedSellSubTabIndex.value != 1) {
        totalEditController.text = coinFormat(amountPercentage * price);
      }
    }
  }

  void _clearInputViews() {
    amountEditController.text = "";
    totalEditController.text = "";
    limitEditController.text = "";
    //hideKeyboard(context);
  }

  void _checkInputData() {
    final dData = _controller.dashboardData.value;
    final isBuy = selectedTabIndex.value == 0;

    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Please input your amount".tr);
      return;
    }

    if (selectedBuySubTabIndex.value == 2 ||
        selectedSellSubTabIndex.value == 2) {
      final stop = makeDouble(priceEditController.text.trim());
      if (stop <= 0) {
        showToast("Please input your stop".tr);
        return;
      }
      final limit = makeDouble(limitEditController.text.trim());
      if (limit <= 0) {
        showToast("Please input your limit".tr);
        return;
      }
      if (stop >= limit) {
        showToast("stop value must be less than limit".tr);
        return;
      }
      hideKeyboard(context);
      _controller.placeOrderStopMarket(
          isBuy,
          dData.orderData?.baseCoinId ?? 0,
          dData.orderData?.tradeCoinId ?? 0,
          amount,
          limit,
          stop,
          () => _clearInputViews());
    } else {
      final price = makeDouble(priceEditController.text.trim());
      if (price <= 0) {
        showToast("Please input your price".tr);
        return;
      }
      hideKeyboard(context);
      if (selectedBuySubTabIndex.value == 0 ||
          selectedSellSubTabIndex.value == 0) {
        _controller.placeOrderLimit(
            isBuy,
            dData.orderData?.baseCoinId ?? 0,
            dData.orderData?.tradeCoinId ?? 0,
            price,
            amount,
            () => _clearInputViews());
      } else if (selectedBuySubTabIndex.value == 1 ||
          selectedSellSubTabIndex.value == 2) {
        _controller.placeOrderMarket(
            isBuy,
            dData.orderData?.baseCoinId ?? 0,
            dData.orderData?.tradeCoinId ?? 0,
            price,
            amount,
            () => _clearInputViews());
      }
    }
  }

  String randomForCurrent({required double min, required double max}) {
    final random = Random();
    //Future.delayed(const Duration(seconds: 5));
    final result = min + random.nextDouble() * (max - min);
    debugPrint("Random ==> ${result.toStringAsFixed(1)}");
    return result.toStringAsFixed(1);
  }
}

class TradeCountdownController extends GetxController {
  Timer? _timer;
  int remainSeconds = 1;
  final time = '00.00'.obs;
  var currentPrice = "".obs;
  var expectedPrice = "".obs;
  int tradeType = 0;
  int tradePercentage = 0;
  String tradeAmount = "";
  Rx<Color> expectedColor = Colors.black.obs;
  double lastPrice = 0;
  final _controller = Get.find<DashboardController>();
  RxBool finishedTrading = false.obs;

  @override
  void onReady() {
    //startTimer(900);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainSeconds < 0) {
        timer.cancel();

        _controller.userTradeResultResponse.value.data = null;
        _controller.postUserTradeResult(
          uuid: _controller.userTradeReturnResponse.value.uuid ?? '',
          currentPrice: double.parse(currentPrice.value),
        );
        Future.delayed(const Duration(seconds: 3));
        finishedTrading.value = true;
        //Get.back();
      } else {
        finishedTrading.value = false;
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        time.value =
            "${minutes.toString().padLeft(2, "0")} : ${seconds.toString().padLeft(2, "0")}";
        remainSeconds--;

        currentPrice.value = randomForCurrent(
          min: lastPrice - 1,
          max: lastPrice + 1,
        );

        if (double.parse(currentPrice.value) > lastPrice) {
          if (tradeType == 0) {
            expectedPrice.value =
                "+${((tradePercentage / 100) * int.parse(tradeAmount)).toStringAsFixed(1)} USDT";
            expectedColor.value = const Color(0xFF02db05);
          } else if (tradeType == 1) {
            expectedPrice.value =
                "-${((tradePercentage / 100) * int.parse(tradeAmount)).toStringAsFixed(1)} USDT";
            expectedColor.value = const Color(0xFFea2727);
          }
        } else {
          if (tradeType == 0) {
            expectedPrice.value =
                "-${((tradePercentage / 100) * int.parse(tradeAmount)).toStringAsFixed(1)} USDT";
            expectedColor.value = const Color(0xFFea2727);
          } else if (tradeType == 1) {
            expectedPrice.value =
                "+${((tradePercentage / 100) * int.parse(tradeAmount)).toStringAsFixed(1)} USDT";
            expectedColor.value = const Color(0xFF02db05);
          }
        }
      }
    });
  }

  String randomForCurrent({required double min, required double max}) {
    final random = Random();
    //Future.delayed(const Duration(seconds: 5));
    final result = min + random.nextDouble() * (max - min);
    return result.toStringAsFixed(1);
  }
}
