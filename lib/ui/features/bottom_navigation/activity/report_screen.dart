import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/report/withdraw_history_response.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/activity/activity_controller.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _controller = Get.put(ActivityScreenController());
  int selectedReportType = 0;
  WithdrawHistoryResponse withdrawHistoryResponse = WithdrawHistoryResponse();

  void fetchWithdrawHistory() {
    APIRepository().getWithdrawHistory().then((response) {
      if (response.success) {
        withdrawHistoryResponse =
            WithdrawHistoryResponse.fromJson(response.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => gUserRx.value.id == 0
          ? Column(children: [
              appBarMain(context, title: "Reports".tr),
              signInNeedView()
            ])
          : Column(
              children: [
                appBarMain(context, title: "Reports".tr),
                dropDownListIndex(
                    reportTypes, _controller.selectedType.value, "All type".tr,
                    (value) {
                  _controller.selectedType.value = value;
                  selectedReportType = value;
                  switch (value) {
                    case 0:
                      fetchWithdrawHistory();
                      break;
                    case 1:
                      break;
                    case 2:
                      break;
                    case 3:
                      fetchWithdrawHistory();
                      break;
                  }
                  setState(() {});
                  _controller.getListData(false);
                }),
                selectedReportType == 3
                    ? _withdrawalContainer(response: withdrawHistoryResponse)
                    : SizedBox()
              ],
            ),
    );
  }
}

List<String> reportTypes = [
  'Trade History',
  'Lockup Mining History',
  'Deposit History',
  'Withdrawal History',
];

Widget _withdrawalContainer({required WithdrawHistoryResponse response}) {
  return response.data!.isEmpty
      ? showLoading()
      : Expanded(
          child: ListView(
            shrinkWrap: true,
            children: response.data!.map((e) => Text(e.createdAt!)).toList(),
          ),
        );
}
