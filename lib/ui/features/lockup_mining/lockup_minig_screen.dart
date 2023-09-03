import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_mining_option_screen.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';

class LockUpMiningScreen extends StatefulWidget {
  const LockUpMiningScreen({super.key});

  @override
  State<LockUpMiningScreen> createState() => _LockUpMiningScreenState();
}

class _LockUpMiningScreenState extends State<LockUpMiningScreen> {
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
                          appBarBackWithActions(title: "Lock-up Mining".tr),
                          signInNeedView()
                        ])
                      : Column(
                          children: [
                            appBarBackWithActions(title: "Lock-up Mining".tr),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: _buildBody(),
                            ),
                            _buildSubmitButton()
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

Widget _buildBody() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Center(
        child: Text(
          "Mining earns non-stop",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        "Locked-up mining is the profit of mining in the platforms mining pool by hosting the USDT to the platforms super-computing power miner",
        textAlign: TextAlign.justify,
      ),
      const SizedBox(height: 30),
      const Center(
        child: Text(
          "product highlights",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 10),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "fetch on demand",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "dividend payout cycle",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Column(
            children: [
              Text(
                "Issued daily",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "current interset",
                style: TextStyle(color: Colors.grey),
              )
            ],
          )
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              RawMaterialButton(
                onPressed: () {},
                elevation: 0,
                fillColor: Colors.blue.withOpacity(.2),
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 35.0,
                  color: Colors.blue,
                ),
              ),
              vSpacer10(),
              const Text(
                "100% capital\nsecurity",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          Column(
            children: [
              RawMaterialButton(
                onPressed: () {},
                elevation: 0,
                fillColor: Colors.blue.withOpacity(.2),
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.attach_money,
                  size: 35.0,
                  color: Colors.blue,
                ),
              ),
              vSpacer10(),
              const Text(
                "continuous\nrevenue on\nholidays",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          Column(
            children: [
              RawMaterialButton(
                onPressed: () {},
                elevation: 0,
                fillColor: Colors.blue.withOpacity(.2),
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.card_giftcard,
                  size: 35.0,
                  color: Colors.blue,
                ),
              ),
              vSpacer10(),
              const Text(
                "value of the day\nafter successful\ndeposit",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          )
        ],
      ),
      const SizedBox(height: 30),
      const Center(
        child: Text(
          "for example",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 15),
      const Text(
        "Income calculation",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const Text(
          "A member locks 10,000U on the platform, chooses a wealth management product with a period of 7 days and a daily output of 0.5% -0.6% of the locked amount, and the daily output is as follows:\nMinimum: 10000Ux 0.5%=500U\nMaximum: 10000Ux 0.6%=600U\nThat is, after 7 days, you can get 3500U-4200U of income, the income is issued daily, and the issued income can be deposited and withdrawn at any time. After the lock-up principal expires, it will be automatically transferred to your asset account."),
      const SizedBox(height: 15),
      const Text(
        "About liquided damages",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const Text(
          "If you wish to transfer out the unexpired principal, a liquidated damage will be incurred. Liquidated damages = default settlement ratio remaining days* locked position quantity. Example: The default settlement ratio for locked warehouse mining is 0.4%, the remaining 3 days expire, and the locked warehouse quantity is 1000, then the liquidated damage = 0.4%*3*1000-12U, and the actual principal refund is 1000U-12U-988U")
    ],
  );
}

Widget _buildSubmitButton() {
  return Padding(
    padding: const EdgeInsets.only(
      left: 15,
      right: 15,
      bottom: 15,
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        minimumSize: const Size.fromHeight(50), // NEW
      ),
      onPressed: () {
        Get.to(const LockUpMiningOptionScreen());
      },
      child: const Text("I want to participate"),
    ),
  );
}
