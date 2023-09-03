import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/dashboard/dashboard_controller.dart';
import 'package:tradexpro_flutter/ui/features/chart/chart_screen.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'buy_sell_tab_views.dart';

class OrderBookIcon extends StatelessWidget {
  const OrderBookIcon(this.fromKey, this.selectedKey, this.onTap, {Key? key})
      : super(key: key);
  final String fromKey;
  final String selectedKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedKey == fromKey;
    double opacity = isSelected ? 0.25 : 0;

    String iconPath = fromKey == FromKey.all
        ? AssetConstants.icBoxFilterAll
        : (fromKey == FromKey.buy
            ? AssetConstants.icBoxFilterBuy
            : AssetConstants.icBoxFilterSell);

    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(3),
            color: Colors.green.withOpacity(opacity),
            child: SvgPicture.asset(iconPath, width: 20, height: 20),
          )),
    );
  }
}

class OderBookItemView extends StatelessWidget {
  const OderBookItemView(
      {Key? key, required this.exchangeOrder, required this.type})
      : super(key: key);
  final ExchangeOrder exchangeOrder;
  final String type;

  @override
  Widget build(BuildContext context) {
    final color = type == FromKey.buy ? Colors.green : Colors.red;
    final percent = getPercentageValue(1, exchangeOrder.percentage);
    return Stack(children: [
      RotatedBox(
        quarterTurns: -2,
        child: LinearProgressIndicator(
            value: percent,
            minHeight: 20,
            color: color.withOpacity(0.15),
            backgroundColor: Colors.transparent),
      ),
      Row(
        children: [
          Expanded(
              flex: 1,
              child: textAutoSizePoppins(coinFormat(exchangeOrder.price),
                  textAlign: TextAlign.start, color: color)),
          Expanded(
              flex: 1,
              child: textAutoSizePoppins(coinFormat(exchangeOrder.amount),
                  color: context.theme.primaryColor)),
          Expanded(
              flex: 1,
              child: textAutoSizePoppins(
                  coinFormat(exchangeOrder.total, fixed: 2),
                  textAlign: TextAlign.end,
                  color: context.theme.primaryColor)),
        ],
      ),
    ]);
  }
}

class DashboardBottomButtonView extends StatelessWidget {
  const DashboardBottomButtonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final dbData = controller.dashboardData.value;
    PriceData? lastPData = dbData.lastPriceData?.first;
    //if (dbData.lastPriceData.isValid)
    //lastPData = dbData.lastPriceData?.first;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.paddingMid, vertical: Dimens.paddingMin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buttonOnlyIcon(
              iconData: Icons.candlestick_chart_outlined,
              size: Dimens.btnHeightMin,
              visualDensity: minimumVisualDensity,
              iconColor: Get.theme.primaryColor,
              onPressCallback: () {
                Get.bottomSheet(const ChartScreenDBoard(),
                    isDismissible: true,
                    isScrollControlled: true,
                    clipBehavior: Clip.hardEdge);
              }),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Obx(() {
              final dbData = controller.dashboardData.value;
              PriceData? lastPData;
              if (dbData.lastPriceData.isValid) {
                lastPData = dbData.lastPriceData?.first;
              }
              return SizedBox(
                height: Dimens.btnHeightMin,
                child: buttonText(
                  "Buy".tr,
                  bgColor: Colors.green,
                  onPressCallback: () {
                    debugPrint("Last Price ==> ${lastPData?.lastPrice}");
                    if (lastPData?.lastPrice != null) {
                      Get.bottomSheet(
                        const BuySellTabViews(fromPage: FromKey.buy),
                        isDismissible: true,
                        isScrollControlled: true,
                      );
                    } else {
                      showToast("Price is updating. Please try again soon!",
                          isError: false);
                    }
                  },
                ),
              );
            }),
            hSpacer5(),
            SizedBox(
                height: Dimens.btnHeightMin,
                child: buttonText("Sell".tr, bgColor: Colors.red,
                    onPressCallback: () {
                  if (lastPData?.lastPrice != null) {
                    Get.bottomSheet(
                        const BuySellTabViews(fromPage: FromKey.sell),
                        isDismissible: true,
                        isScrollControlled: true);
                  } else {
                    showToast("Price is updating. Please try again soon!",
                        isError: false);
                  }
                })),
          ]),
        ],
      ),
    );
  }
}

class TradeItemView extends StatelessWidget {
  const TradeItemView({Key? key, required this.exchangeTrade})
      : super(key: key);
  final ExchangeTrade exchangeTrade;

  @override
  Widget build(BuildContext context) {
    final color = (exchangeTrade.price ?? 0) > (exchangeTrade.lastPrice ?? 0)
        ? Colors.green
        : ((exchangeTrade.price ?? 0) < (exchangeTrade.lastPrice ?? 0)
            ? Colors.red
            : context.theme.primaryColor);
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: textAutoSizePoppins(coinFormat(exchangeTrade.price),
                textAlign: TextAlign.start, color: color)),
        Expanded(
            flex: 1,
            child: textAutoSizePoppins(coinFormat(exchangeTrade.amount),
                color: context.theme.primaryColor)),
        Expanded(
            flex: 1,
            child: textAutoSizePoppins(exchangeTrade.time ?? "",
                textAlign: TextAlign.end, color: context.theme.primaryColor)),
      ],
    );
  }
}

class CoinPairItemView extends StatelessWidget {
  const CoinPairItemView(
      {Key? key, required this.coinPair, required this.onTap})
      : super(key: key);
  final CoinPair coinPair;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: textAutoSizePoppins(coinPair.coinPairName ?? "",
                    textAlign: TextAlign.start,
                    color: context.theme.primaryColor)),
            Expanded(
                flex: 1,
                child: textAutoSizePoppins(coinPair.lastPrice ?? "",
                    color: context.theme.primaryColor)),
            Expanded(
                flex: 1,
                child: textAutoSizePoppins("${coinPair.priceChange ?? ""}%",
                    textAlign: TextAlign.end,
                    color: getNumberColor(coinPair.priceChange))),
          ],
        ),
      ),
    );
  }
}

class SelectedCoinDetailsView extends StatelessWidget {
  const SelectedCoinDetailsView({Key? key, required this.total})
      : super(key: key);
  final Total? total;

  @override
  Widget build(BuildContext context) {
    final baseVolume = (total?.tradeWallet?.volume ?? 0) *
        (total?.tradeWallet?.lastPrice ?? 0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            coinDetailsItemView("24h change".tr,
                "${currencyFormat(total?.tradeWallet?.priceChange)}%",
                subColor: getNumberColor(total?.tradeWallet?.priceChange)),
            coinDetailsItemView(
                "24h high".tr, currencyFormat(total?.tradeWallet?.high)),
            coinDetailsItemView(
                "24h low".tr, currencyFormat(total?.tradeWallet?.low)),
          ],
        ),
        vSpacer5(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            textAutoSizeKarla("${"24h volume".tr} : ",
                color: Get.theme.primaryColorLight,
                fontSize: Dimens.regularFontSizeSmall),
            textAutoSizeKarla(
                "${currencyFormat(total?.tradeWallet?.volume)} ${total?.tradeWallet?.coinType ?? ""}",
                color: Get.theme.primaryColor,
                fontSize: Dimens.regularFontSizeSmall),
            textAutoSizeKarla(
                "${currencyFormat(baseVolume)} ${total?.baseWallet?.coinType ?? ""}",
                color: Get.theme.primaryColor,
                fontSize: Dimens.regularFontSizeSmall),
          ],
        )
      ],
    );
  }
}

class OrdersBookAll extends StatelessWidget {
  const OrdersBookAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final total = controller.dashboardData.value.orderData?.total;
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
              child: Column(
                children: [
                  appBarBackWithActions(
                      title:
                          "${"Order Book".tr} - ${controller.selectedCoinPair.value.coinPair ?? ""}",
                      fontSize: Dimens.regularFontSizeMid),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.paddingMid),
                      children: [
                        listHeaderView(
                            "${"Price".tr}(${total?.baseWallet?.coinType ?? ""})",
                            "${"Amount".tr}(${total?.tradeWallet?.coinType ?? ""})",
                            "Total".tr),
                        dividerHorizontal(height: Dimens.paddingMid),
                        Obx(() {
                          return controller.sellExchangeOrder.isEmpty
                              ? showEmptyView()
                              : Column(
                                  children: List.generate(
                                      controller.sellExchangeOrder.length,
                                      (index) => OderBookItemView(
                                          exchangeOrder: controller
                                              .sellExchangeOrder[index],
                                          type: FromKey.sell)),
                                );
                        }),
                        dividerHorizontal(height: Dimens.paddingMid),
                        Obx(() {
                          PriceData? lastPData;
                          if (controller
                              .dashboardData.value.lastPriceData.isValid)
                            lastPData = controller
                                .dashboardData.value.lastPriceData?.first;
                          final isUp = (lastPData?.price ?? 0) >=
                              (lastPData?.lastPrice ?? 0);
                          final color = isUp ? Colors.green : Colors.red;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textAutoSizeKarla(coinFormat(lastPData?.price),
                                  fontSize: Dimens.regularFontSizeMid,
                                  color: color),
                              Icon(
                                  isUp
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: color,
                                  size: Dimens.iconSizeMinExtra),
                              hSpacer5(),
                              textAutoSizeKarla(
                                  "${coinFormat(lastPData?.lastPrice)}(${controller.dashboardData.value.orderData?.total?.baseWallet?.coinType ?? ""})",
                                  fontSize: Dimens.regularFontSizeSmall),
                            ],
                          );
                        }),
                        dividerHorizontal(height: Dimens.paddingMid),
                        Obx(() {
                          return controller.buyExchangeOrder.isEmpty
                              ? showEmptyView()
                              : Column(
                                  children: List.generate(
                                      controller.buyExchangeOrder.length,
                                      (index) => OderBookItemView(
                                          exchangeOrder: controller
                                              .buyExchangeOrder[index],
                                          type: FromKey.buy)),
                                );
                        }),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
