// Breakpoints
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/rendering.dart';
import 'package:panter_web/wild_card.dart';

final colorsGrey = Color(0xffE4DFDA);

/// main is entry point of Flutter application
void main() {
  // Desktop platforms aren't a valid platform.
  if (!kIsWeb) _setTargetPlatformForDesktop();
  return runApp(MyApp());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (_, constraints) {
      final _breakpoint = Breakpoint.fromConstraints(constraints);
      return Scaffold(
        body: SingleChildScrollView(
          // controller: ,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // color: Colors.red,
                margin: new EdgeInsets.only(
                    right: 50, left: 16, top: 32, bottom: 32),

                alignment: Alignment.centerLeft,
                height: screenSize.height / 4, // width: screenSize.width / 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, right: 50,left: 16),
                  child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fitHeight,
                      child: TypeWriter()),
                ),
              ),
              Container(
                child: GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        // _breakpoint.window == WindowSize.small ||
                        _breakpoint.window == WindowSize.xsmall ? 1 : 3,
                    // crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: _breakpoint.gutters,
                    mainAxisSpacing: _breakpoint.gutters,
                  ),
                  padding: EdgeInsets.all(_breakpoint.gutters*4),
                  children: [
                    DraggableCard(
                      child: MyAppCards(
                        offsetBuild: Duration(milliseconds: 400),
                        size: screenSize,
                        active: true,
                        initText: "Fase 1",
                        text: "Pant",
                        iconData: Icons.cached,
                      ),
                    ),
                    DraggableCard(
                      child: MyAppCards(
                        offsetBuild: Duration(milliseconds: 800),
                        size: screenSize,
                        initText: "Fase 2",
                        active: false,
                        iconData: Icons.local_dining_sharp,
                      ),
                    ),
                    DraggableCard(
                      child: MyAppCards(
                        offsetBuild: Duration(milliseconds: 
                        1000),
                        size: screenSize,
                        initText: "Fase 3",
                        active: false,
                        iconData: Icons.view_in_ar,
                      ),
                    ),
                  ],
                ),
              ),
                Container(height: screenSize.height/3,),

              Container(
                  color: Colors.grey[100],
                  height: screenSize.height / 3,
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // width: _breakpoint.gutters*10,
                          child: FittedBox(fit: BoxFit.cover,
                            child: Text("PANTER AS",style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),)),
                        ),
                        SizedBox(height: 32,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                                child: Text("Kontakt oss"), onPressed: () {}),
                        SizedBox(width: 32,),

                            FlatButton(
                                child: Text("Personvern"), onPressed: () {}),
                            // FlatButton(
                            //     child: Text("Kontakt oss"), onPressed: () {}),
                        SizedBox(height: 32,),

                          ],
                          
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      );

      //   // body: Container(
      //   //   padding: EdgeInsets.all(_breakpoint.gutters),
      //   //   child: GridView.builder(
      //   //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   //       crossAxisCount: _breakpoint.columns,
      //   //       crossAxisSpacing: _breakpoint.gutters,
      //   //       mainAxisSpacing: _breakpoint.gutters,
      //   //     ),
      //   //     itemCount: 200,
      //   //     itemBuilder: (_, index) {
      //   //       return Container(
      //   //         child: Card(
      //   //           child: Text(
      //   //             index.toString(),
      //   //           ),
      //   //         ),
      //   //       );
      //   //     },
      //   //   ),
      //   // ),
      // );
    });
  }
}
