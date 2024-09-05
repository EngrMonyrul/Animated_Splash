import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  ValueNotifier<double> _swipeDistance = ValueNotifier(0.0);
  bool _isAnimationControllerDismiss = false;

  late AnimationController _entryAnimationController;
  late Animation _entryAnimation;

  late AnimationController _sliderAnimationController;
  late Animation _sliderAnimation;

  late AnimationController _labelAnimationController;
  late Animation _labelAnimation;

  void setSystemUi() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void setEntryAnimationController() {
    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _entryAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void setSliderAnimationController() {
    _sliderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _sliderAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sliderAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _sliderAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            _sliderAnimationController.reverse();
          },
        );
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            _sliderAnimationController.forward();
          },
        );
      }
    });

    _sliderAnimationController.forward();
  }

  void setLabelAnimationController() {
    // await Future.delayed(const Duration(seconds: 01));
    _labelAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _labelAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _labelAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            _labelAnimationController.reverse();
          },
        );
      }
    });

    _labelAnimationController.forward();
  }

  Future<void> initAnimation() async {
    await _entryAnimationController.forward();
  }

  @override
  void initState() {
    setSystemUi();
    setEntryAnimationController();
    setSliderAnimationController();
    setLabelAnimationController();
    initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _entryAnimationController.dispose();
    _sliderAnimationController.dispose();
    _labelAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _entryAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0.0, (screenSize.height * .4) * (1 - _entryAnimation.value)),
            child: Opacity(
              opacity: _entryAnimation.value,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 4; i++)
                            Transform.scale(
                              scale: 4,
                              child: AnimatedBuilder(
                                animation: _sliderAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                        (i == 1 || i == 3)
                                            ? (-25.0 + (100.0 * _sliderAnimation.value))
                                            : -100.0 * _sliderAnimation.value,
                                        0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 40),
                                      child: Opacity(
                                        opacity: 1.0 - _sliderAnimation.value,
                                        child: Text(
                                          "Prime Tech Solutions Ltd",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white.withOpacity(0.1),
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(0.0, (screenSize.height * .4) * (1 - _labelAnimation.value)),
                      child: Opacity(
                        opacity: _labelAnimation.value,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF000000).withOpacity(.1),
                                offset: const Offset(0, 0),
                                blurRadius: 300,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/prime_tech_bd_solutions_ltd_logo-removebg-preview.png",
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Prime Tech",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Solutions LTD.",
                                      style: TextStyle(fontSize: 26, color: Colors.white),
                                    ),
                                    Expanded(
                                        child: Text(
                                      "THE DOOR TO OPEN APPROPRIATE TECHNOLOGY",
                                      style: TextStyle(fontSize: 9, color: Colors.white),
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
