import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/profile/my_profile_controller.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_minig_screen.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'dashboard_controller.dart';
import 'dashboard_widgets.dart';
import 'history_tab_views.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final _controller = Get.put(DashboardController());
  final _profileController = Get.put(MyProfileController());

  final isMyOrders = true.obs;

  @override
  void initState() {
    _controller.getTradeOptions();

    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _controller.getDashBoardData());
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => _profileController.getProfileMenus());
  }

  @override
  void dispose() {
    _controller.unSubscribeChannel(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Column(
        children: [
          appBarMain(context, title: "Trade".tr),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
              shrinkWrap: true,
              children: [
                _selectedPairView(),
                vSpacer5(),
                Obx(() => SelectedCoinDetailsView(
                    total: _controller.dashboardData.value.orderData?.total)),
                vSpacer5(),
                _oderBookView(),
                vSpacer5(),
                Obx(() => Row(
                      children: [
                        Expanded(
                            child: buttonText("My Orders".tr,
                                bgColor: isMyOrders.value
                                    ? null
                                    : Colors.transparent,
                                borderColor: Get.theme.colorScheme.secondary,
                                textColor: Get.theme.primaryColor,
                                onPressCallback: () =>
                                    isMyOrders.value = true)),
                        hSpacer10(),
                        Expanded(
                            child: buttonText("Market Trades".tr,
                                bgColor: isMyOrders.value
                                    ? Colors.transparent
                                    : null,
                                borderColor: Get.theme.colorScheme.secondary,
                                textColor: Get.theme.primaryColor,
                                onPressCallback: () =>
                                    isMyOrders.value = false)),
                      ],
                    )),
                //const HistoryTabViews(),
                Obx(() => isMyOrders.value
                    ? const HistoryTabViews()
                    : _tradeListView()),
                vSpacer10(),
                InkWell(
                  onTap: () {
                    Get.to(const LockUpMiningScreen());
                  },
                  child: Material(
                    elevation: 5,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child: Image.asset("assets/images/mining_banner.jpg"),
                  ),
                ),
                vSpacer10(),
              ],
            ),
          ),
          const DashboardBottomButtonView()
        ],
      ),
    );
  }

  _selectedPairView() {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => InkWell(
              onTap: () => chooseCoinPairModal(),
              child: Row(
                children: [
                  textAutoSizeTitle(
                      _controller.selectedCoinPair.value.coinPair ?? "",
                      fontSize: Dimens.regularFontSizeLarge),
                  hSpacer5(),
                  showImageAsset(
                      icon: Icons.arrow_drop_down_outlined,
                      color: context.theme.primaryColor)
                ],
              ),
            ),
          ),
          Obx(() {
            final dbData = _controller.dashboardData.value;
            PriceData? lastPData;
            if (dbData.lastPriceData.isValid) {
              lastPData = dbData.lastPriceData?.first;
            }

            final isUp = (lastPData?.price ?? 0) >= (lastPData?.lastPrice ?? 0);
            return coinDetailsItemView(currencyFormat(lastPData?.price),
                "${currencyFormat(lastPData?.lastPrice)}(${dbData.orderData?.total?.baseWallet?.coinType ?? ""})",
                isSwap: true, fromKey: isUp ? FromKey.up : FromKey.down);
          }),
        ],
      ),
    );
  }

  void chooseCoinPairModal() {
    _controller.getCoinPairList("");
    Get.bottomSheet(
        Container(
            alignment: Alignment.bottomCenter,
            color: context.theme.scaffoldBackgroundColor,
            height: getContentHeight(),
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                textFieldSearch(
                    controller: _controller.searchEditController,
                    onTextChange: (value) =>
                        _controller.getCoinPairList(value)),
                vSpacer10(),
                listHeaderView("Coin".tr, "Last".tr, "Change".tr),
                dividerHorizontal(),
                Expanded(child: Obx(() {
                  return ListView(
                      shrinkWrap: true,
                      children:
                          List.generate(_controller.coinPairs.length, (index) {
                        return CoinPairItemView(
                            coinPair: _controller.coinPairs[index],
                            onTap: () {
                              Get.back();
                              _controller.selectedCoinPair.value =
                                  _controller.coinPairs[index];
                              _controller.getDashBoardData();
                            });
                      }));
                }))
              ],
            )),
        isDismissible: true);
  }

  _oderBookView() {
    return Container(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      decoration: boxDecorationRoundBorder(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textAutoSizeTitle("Order Book".tr,
                  fontSize: Dimens.regularFontSizeMid),
              Obx(() => Row(
                    children: [
                      OrderBookIcon(
                          FromKey.all,
                          _controller.selectedOrderSort.value,
                          () => _controller.selectedOrderSort.value =
                              FromKey.all),
                      hSpacer5(),
                      OrderBookIcon(
                          FromKey.sell,
                          _controller.selectedOrderSort.value,
                          () => _controller.selectedOrderSort.value =
                              FromKey.sell),
                      hSpacer5(),
                      OrderBookIcon(
                          FromKey.buy,
                          _controller.selectedOrderSort.value,
                          () => _controller.selectedOrderSort.value =
                              FromKey.buy),
                    ],
                  )),
            ],
          ),
          vSpacer5(),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            final total = _controller.dashboardData.value.orderData?.total;
            return listHeaderView(
                "${"Price".tr}(${total?.baseWallet?.coinType ?? ""})",
                "${"Amount".tr}(${total?.tradeWallet?.coinType ?? ""})",
                "Total".tr);
          }),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            return _controller.selectedOrderSort.value == FromKey.buy
                ? vSpacer0()
                : _controller.sellExchangeOrder.isEmpty
                    ? showEmptyView()
                    : Column(
                        children: List.generate(
                            _controller
                                .getListLength(_controller.sellExchangeOrder),
                            (index) => OderBookItemView(
                                exchangeOrder:
                                    _controller.sellExchangeOrder[index],
                                type: FromKey.sell)),
                      );
          }),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            PriceData? lastPData;
            if (_controller.dashboardData.value.lastPriceData.isValid)
              lastPData = _controller.dashboardData.value.lastPriceData?.first;
            final isUp = (lastPData?.price ?? 0) >= (lastPData?.lastPrice ?? 0);
            final color = isUp ? Colors.green : Colors.red;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    textAutoSizeKarla(coinFormat(lastPData?.price),
                        fontSize: Dimens.regularFontSizeMid, color: color),
                    Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward,
                        color: color, size: Dimens.iconSizeMinExtra),
                    hSpacer5(),
                    textAutoSizeKarla(
                        "${coinFormat(lastPData?.lastPrice)}(${_controller.dashboardData.value.orderData?.total?.baseWallet?.coinType ?? ""})",
                        fontSize: Dimens.regularFontSizeSmall),
                  ],
                ),
                InkWell(
                    onTap: () => Get.to(() => const OrdersBookAll()),
                    child: textAutoSizePoppins("Show More".tr))
              ],
            );
          }),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            return _controller.selectedOrderSort.value == FromKey.sell
                ? vSpacer0()
                : _controller.buyExchangeOrder.isEmpty
                    ? showEmptyView()
                    : Column(
                        children: List.generate(
                            _controller
                                .getListLength(_controller.buyExchangeOrder),
                            (index) => OderBookItemView(
                                exchangeOrder:
                                    _controller.buyExchangeOrder[index],
                                type: FromKey.buy)),
                      );
          }),
        ],
      ),
    );
  }

  _tradeListView() {
    return Container(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      decoration: boxDecorationRoundBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final total = _controller.dashboardData.value.orderData?.total;
            return listHeaderView(
                "${"Price".tr}(${total?.baseWallet?.coinType ?? ""})",
                "${"Amount".tr}(${total?.tradeWallet?.coinType ?? ""})",
                "Time".tr);
          }),
          dividerHorizontal(),
          Obx(() {
            return _controller.exchangeTrades.isEmpty
                ? showEmptyView()
                : Column(
                    // shrinkWrap: true,
                    children: List.generate(
                        _controller.exchangeTrades.length,
                        (index) => TradeItemView(
                            exchangeTrade: _controller.exchangeTrades[index])),
                  );
          }),
        ],
      ),
    );
  }
}
