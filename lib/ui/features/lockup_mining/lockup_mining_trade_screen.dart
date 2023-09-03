import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/mining_options.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_controller.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_mining_option_screen.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';

class LockupMiningTradeScreen extends StatefulWidget {
  final MiningOption? miningOption;
  final double? userBalance;
  const LockupMiningTradeScreen(
      {super.key, this.miningOption, this.userBalance});

  @override
  State<LockupMiningTradeScreen> createState() =>
      _LockupMiningTradeScreenState();
}

class _LockupMiningTradeScreenState extends State<LockupMiningTradeScreen> {
  final _controller = Get.find<LockupController>();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
              child: Obx(
                () {
                  return gUserRx.value.id == 0
                      ? Column(children: [
                          appBarBackWithActions(
                              title: widget.miningOption?.name),
                          signInNeedView()
                        ])
                      : Column(
                          children: [
                            appBarBackWithActions(
                                title: widget.miningOption?.name),
                            const SizedBox(height: 20),
                            _buildHeader(widget.miningOption!),
                            const SizedBox(height: 30),
                            _buildBody(
                                widget.miningOption!,
                                widget.userBalance!,
                                amountController,
                                _controller)
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildHeader(MiningOption data) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get USDT',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              data.name!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'recent(daily earnings)',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              "${data.dailyRateOfReturnMin}~${data.dailyRateOfReturnMax}%",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget _buildBody(MiningOption data, double userBalance,
    TextEditingController amountController, LockupController lockupController) {
  var expectedRevenueMin = (data.dailyRateOfReturnMin! / 100) *
      int.parse(data.period!) *
      data.singleLimitMin!;
  var expectedRevenueMax = (data.dailyRateOfReturnMax! / 100) *
      int.parse(data.period!) *
      data.singleLimitMax!;
  return Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: Material(
            color: Colors.blue,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 30,
                bottom: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "${data.period}(Day)",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "financial cycle",
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${data.singleLimitMin}~${data.singleLimitMax}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "single limit (USDT)",
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Material(
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.grey.shade50,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "dividend\npayment time",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          "daily",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "default\nsettlement ratio",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          "${data.defaultSettlementRatio}%",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "expected\nrevenue (USDT)",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          "${expectedRevenueMin.toStringAsFixed(2)}~${expectedRevenueMax.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "available assets (USDT)",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          "$userBalance",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("investment amount"),
                    const SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        hintText: "0",
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                    "Mining earns non-stop\nLocked-up mining is the profit of mining in the platforms mining pool by hosting the USDT to the platforms super-computing power miner"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              submitMining(
                  data, userBalance, amountController, lockupController);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: const Size.fromHeight(50), // NEW
            ),
            child: const Text("Subscription"))
      ],
    ),
  );
}

void submitMining(MiningOption miningOption, double userBalance,
    TextEditingController controller, LockupController lockupController) {
  if (controller.text.isEmpty) {
    showToast("You have not enough balance");
    return;
  }
  double investmentAmount = double.parse(controller.text.toString());

  if (investmentAmount < miningOption.singleLimitMin!) {
    showToast("Minimum amount is ${miningOption.singleLimitMin}");
    return;
  }
  if (investmentAmount > miningOption.singleLimitMax!) {
    showToast("Maximum amount is ${miningOption.singleLimitMax}");
    return;
  }
  if (investmentAmount > userBalance) {
    showToast("You have not enough balance");
    return;
  }

  lockupController.userDoMining(
    miningOptionID: miningOption.id!,
    investmentAmount: investmentAmount,
    period: miningOption.period!,
    dailyReturnPercent: miningOption.dailyRateOfReturnMin!,
  );

  Get.to(const LockUpMiningOptionScreen());
}
