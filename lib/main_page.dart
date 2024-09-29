import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lukafulu/pages/menu/chatpage.dart';
import 'package:lukafulu/pages/menu/userpage.dart';

class MainPage extends StatelessWidget {
  int currentIndex;

  MainPage({
    this.currentIndex = 0,  // Initialize currentIndex with a default value of 0
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: currentIndex,  // Use the initialized or passed value of currentIndex
          length: 2,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
               TabBarView(
                children: [
                  HomePage(),
                  UserDetailsPage(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.all(5),
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).hoverColor,
                  ),
                  child: ClipPath(
                    clipper: const ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      mouseCursor: MouseCursor.uncontrolled,

                      indicatorColor: Theme.of(context).focusColor,
                      labelColor: Theme.of(context).colorScheme.inversePrimary,
                      unselectedLabelColor: Theme.of(context).focusColor,
                      tabs: const [
                        Tab(
                          child: Icon(
                            Icons.roofing,
                            size: 30,
                          ),
                        ),
                        Tab(
                          child: Icon(
                            FluentIcons.settings_24_regular,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
