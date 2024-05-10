import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/boarding/onboarding_model.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<OnBoardingModel> boarding = [
    OnBoardingModel(
        image: 'assets/images/one.png',
        title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,'),
    OnBoardingModel(
        image: 'assets/images/two.png',
        title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,'),
    OnBoardingModel(
        image: 'assets/images/three.png',
        title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,'),
  ];
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
                child: PageView.builder(
                  controller: boardController,
                  itemBuilder: (context, index) =>
                      buildOnBoardingItem(boarding[index]),
                  itemCount: boarding.length,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                )),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // move to shop login screen
                    submit();
                    //navigateAndFinish(context, ShopLoginScreen());

                  },
                  child: Row(
                    children: <Widget>[
                      Text('SKIP'),
                      Icon(Icons.skip_next), // replace with your desired icon
                    ],
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    // moving to the next page
                    if(isLast) {
                      // move to shop login screen
                      submit();
                      //navigateAndFinish(context, ShopLoginScreen());

                    }else {
                      boardController.nextPage(
                          duration: Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }

                  },
                  child: Row(
                    children: <Widget>[
                      Text('NEXT'),
                      Icon(Icons
                          .arrow_forward), // replace with your desired icon
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildOnBoardingItem(OnBoardingModel boardingModel) {
    return Column(
      children: [
        Expanded(
            child: Image(
              image: AssetImage('${boardingModel.image}'),
            )),
        const SizedBox(
          height: 20,
        ),
        Text(
          '${boardingModel.title}',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          '${boardingModel.description}',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(
          height: 20,
        ),
        SmoothPageIndicator(
            controller: boardController,
            count: boarding.length,
            effect: ExpandingDotsEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 5))
      ],
    );
  }
  void submit() {
   CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
     if (value) {
       navigateAndFinish(context, ShopLoginScreen());
     }
   });
  }
}
