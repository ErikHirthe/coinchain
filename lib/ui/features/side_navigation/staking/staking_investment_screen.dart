import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/staking.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'staking_controller.dart';

class StakingInvestmentScreen extends StatefulWidget {
  const StakingInvestmentScreen({Key? key}) : super(key: key);

  @override
  State<StakingInvestmentScreen> createState() => _StakingInvestmentScreenState();
}

class _StakingInvestmentScreenState extends State<StakingInvestmentScreen> {
  bool isLoading = true;
  final _controller = Get.find<StakingController>();
  RxList<Investment> investmentList = <Investment>[].obs;
  bool hasMoreData = true;
  int loadedPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getInvestmentList(false));
  }

  void getInvestmentList(bool loadMore) async {
    if (!loadMore) {
      loadedPage = 0;
      hasMoreData = true;
      investmentList.clear();
    }
    isLoading = true;
    loadedPage++;
    _controller.getStakingInvestmentList(loadedPage, (listResponse) {
      isLoading = false;
      loadedPage = listResponse.currentPage ?? 0;
      hasMoreData = listResponse.nextPageUrl != null;
      final list = List<Investment>.from(listResponse.data!.map((x) => Investment.fromJson(x)));
      investmentList.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return investmentList.isEmpty
          ? handleEmptyViewWithLoading(isLoading)
          : Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  itemCount: investmentList.length,
                  itemBuilder: (context, index) {
                    if (hasMoreData && index == investmentList.length - 1) getInvestmentList(true);
                    return StakingInvestmentItemView(investment: investmentList[index], onCancel: () => getInvestmentList(false));
                  }),
            );
    });
  }
}

class StakingInvestmentItemView extends StatelessWidget {
  const StakingInvestmentItemView({Key? key, required this.investment, required this.onCancel}) : super(key: key);
  final Investment investment;
  final Function() onCancel;

  @override
  Widget build(BuildContext context) {
    final statusData = getStakingStatusData(investment.status);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.radiusCorner)),
        onTap: () => showBottomSheetFullScreen(context, StakingInvestmentDetailsView(investment: investment),
            title: "Investment Details".tr, isScrollControlled: false),
        child: Container(
          decoration: boxDecorationRoundCorner(),
          padding: const EdgeInsets.all(Dimens.paddingMid),
          margin: const EdgeInsets.only(bottom: Dimens.paddingMid),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textAutoSizeKarla(investment.coinType ?? "", fontSize: Dimens.regularFontSizeMid),
                  textAutoSizeKarla("${investment.minimumMaturityPeriod ?? 0} ${"Days".tr}", fontSize: Dimens.regularFontSizeMid),
                ],
              ),
              vSpacer10(),
              twoTextSpace("Daily Earning".tr, "${coinFormat(investment.earnDailyBonus)} ${investment.coinType ?? ""}"),
              vSpacer5(),
              twoTextSpace("Investment Amount".tr, "${coinFormat(investment.investmentAmount)} ${investment.coinType ?? ""}"),
              vSpacer5(),
              twoTextSpace("Status".tr, statusData.first, subColor: statusData.last),
              vSpacer5(),
              twoTextSpace("Estimated Interest".tr, "${coinFormat(investment.totalBonus)} ${investment.coinType ?? ""}"),
              if (investment.status == StakingInvestmentStatus.running)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [hSpacer20(), buttonText("Cancel".tr, onPressCallback: () => _cancelMyInvestment(context), bgColor: Colors.redAccent)],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelMyInvestment(BuildContext context) {
    alertForAction(
      context,
      title: "Cancel Investment".tr,
      subTitle: "Do you want to cancel your Investment".tr,
      buttonTitle: "Cancel".tr,
      buttonColor: Colors.red,
      onOkAction: () {
        Get.find<StakingController>().investmentCanceled(investment.uid ?? "", () {
          Get.back();
          onCancel();
        });
      },
    );
  }
}

class StakingInvestmentDetailsView extends StatelessWidget {
  const StakingInvestmentDetailsView({Key? key, required this.investment}) : super(key: key);
  final Investment investment;

  @override
  Widget build(BuildContext context) {
    final statusData = getStakingStatusData(investment.status);
    final typeData = getStakingTermsData(investment.termsType);
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
        children: [
          twoTextSpace("Coin Type".tr, investment.coinType ?? ""),
          vSpacer5(),
          twoTextSpace("Type".tr, typeData.first, subColor: typeData.last),
          vSpacer5(),
          twoTextSpace("Stake Date".tr, formatDate(investment.createdAt, format: dateTimeFormatDdMMMMYyyyHhMm)),
          vSpacer5(),
          twoTextSpace("Daily Interest".tr, "${coinFormat(investment.earnDailyBonus)} ${investment.coinType ?? ""}"),
          vSpacer5(),
          twoTextSpace("End Date".tr, formatDate(investment.endDate, format: dateTimeFormatDdMMMMYyyyHhMm)),
          vSpacer5(),
          twoTextSpace("Minimum Maturity Period".tr, "${investment.minimumMaturityPeriod ?? 0} ${"Days".tr}"),
          vSpacer5(),
          twoTextSpace("Offer Percentage".tr, "${coinFormat(investment.offerPercentage)}%"),
          vSpacer5(),
          twoTextSpace("Remain Interest Day".tr, "${investment.remainInterestDay ?? 0} ${"Days".tr}"),
          vSpacer5(),
          twoTextSpace("Invested Amount".tr, "${coinFormat(investment.investmentAmount)} ${investment.coinType ?? ""}"),
          vSpacer5(),
          twoTextSpace("Total Bonus".tr, "${coinFormat(investment.totalBonus)} ${investment.coinType ?? ""}"),
          vSpacer5(),
          twoTextSpace("Auto Renew".tr, investment.autoRenewStatus == 2 ? "Enabled".tr : "Disabled".tr),
          vSpacer5(),
          twoTextSpace("Status".tr, statusData.first, subColor: statusData.last),
          vSpacer5(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textAutoSizeKarla("Est. APR".tr, fontSize: Dimens.regularFontSizeLarge),
              textAutoSizeKarla("${coinFormat(investment.offerPercentage)}%", fontSize: Dimens.regularFontSizeMid, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}
