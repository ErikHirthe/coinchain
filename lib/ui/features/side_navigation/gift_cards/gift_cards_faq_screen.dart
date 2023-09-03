import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/gift_card.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

class GiftCardsFAQScreen extends StatelessWidget {
  const GiftCardsFAQScreen({super.key, required this.gcData});

  final GiftCardsData gcData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                appBarBackWithActions(title: "Gift Card Info".tr),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Stack(
                        children: [
                          Container(
                              width: Get.width,
                              height: Get.width / 2,
                              color: Colors.grey,
                              child: showImageNetwork(imagePath: gcData.secondBanner, boxFit: BoxFit.fitWidth)),
                          Container(
                            padding: const EdgeInsets.all(Dimens.paddingMid),
                            width: Get.width,
                            height: Get.width / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (gcData.secondHeader.isValid)
                                  textAutoSizeKarla(gcData.secondHeader ?? "", fontSize: Dimens.regularFontSizeMid, maxLines: 2, color: Colors.white),
                                if (gcData.secondDescription.isValid) vSpacer10(),
                                if (gcData.secondDescription.isValid)
                                  textAutoSizePoppins(gcData.secondDescription ?? "", color: Colors.white, maxLines: 7),
                              ],
                            ),
                          )
                        ],
                      ),
                      vSpacer20(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                        child: textAutoSizeKarla("FAQS".tr, fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.start),
                      ),
                      Column(children: List.generate(gcData.faq?.length ?? 0, (index) => faqItem(gcData.faq![index])))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
