import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/mining_options.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_controller.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_mining_trade_screen.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_order_screen.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class LockUpMiningOptionScreen extends StatefulWidget {
  const LockUpMiningOptionScreen({super.key});

  @override
  State<LockUpMiningOptionScreen> createState() =>
      _LockUpMiningOptionScreenState();
}

class _LockUpMiningOptionScreenState extends State<LockUpMiningOptionScreen> {
  final _controller = Get.put(LockupController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _controller.getMiningOption(),
    );
  }

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
                              title: "Lock-up Mining Options".tr),
                          signInNeedView()
                        ])
                      : Column(
                          children: [
                            appBarBackWithActions(
                                title: "Lock-up Mining Options".tr),
                            Obx(() => _controller.isDataLoading.value == false
                                ? _buildHeader(_controller
                                    .miningOptionsResponse.value.item!)
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  )),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              child: _buildBody(_controller),
                            )
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

Widget _buildHeader(UserMiningOverall data) {
  return Container(
    margin: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "funds in custody",
                    style: TextStyle(color: Colors.white60),
                  ),
                  Text(
                    "${currencyFormat(double.parse(data.fundsInCustody!))} USDT",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const LockupMiningOrderScreen());
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white.withOpacity(.8)),
                child: Text(
                  'Order',
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white30,
          padding:
              const EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "${data.expectedEarnings ?? 0}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "expected\nearnings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "${data.cumulativeIncome ?? 0}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "cumulative\nincome",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "${data.orderInCustody ?? 0}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "order in\ncustoday",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget _buildBody(LockupController controller) {
  return Obx(() => controller.isDataLoading.value == true
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : Column(
          children: controller.miningOptionsResponse.value!.data!
              .map((e) => _buildLockUpMiningItem(
                  e,
                  double.parse(controller
                      .miningOptionsResponse.value!.item!.fundsInCustody!)))
              .toList(),
        ));
}

Widget _buildLockUpMiningItem(MiningOption data, double userAmount) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Material(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.grey.shade50,
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${data.name}",
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(LockupMiningTradeScreen(
                      miningOption: data,
                      userBalance: userAmount,
                    ));
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.blue),
                  child: const Text(
                    "Buy",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "single limit",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.singleLimitMin}~${data.singleLimitMax}",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "daily rate of return",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.dailyRateOfReturnMin}~${data.dailyRateOfReturnMax}%",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "period",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.period}(Day)",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
          ])),
    ),
  );
}
