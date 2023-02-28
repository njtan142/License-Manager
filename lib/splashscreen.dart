  import 'package:flutter/material.dart';
  import 'package:flutter/src/widgets/container.dart';
  import 'package:flutter/src/widgets/framework.dart';
  import 'package:license_manager/main.dart';
  import 'package:license_manager/widget_builder.dart';

  class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      Future.delayed(const Duration(seconds: 2)).then((value) {
        replacePage(context, SessionChecker());
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                          height: 150, child: Image.asset("assets/police.png")),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Traffic and Violation Records",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
