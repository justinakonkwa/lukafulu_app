// ignore_for_file: prefer_const_constructors

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lukafulu/language/choose_language.dart';
import 'package:lukafulu/main_page.dart';
import 'package:lukafulu/pages/authantification/login_page.dart';
import 'package:lukafulu/pages/menu/chatpage.dart';
import 'package:lukafulu/theme/theme_provider.dart';
import 'package:lukafulu/widgets/app_text.dart';
import 'package:lukafulu/widgets/app_text_large.dart';
import 'package:lukafulu/widgets/bouton_next.dart';
import 'package:lukafulu/widgets/constantes.dart';
import 'package:lukafulu/widgets/lign.dart';
import 'package:lukafulu/widgets/message_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({
    super.key,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPageIndex = 0;
  String number = '';

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController adress =
      TextEditingController(text: 'Bobanga, Q/beau marché,/kinshasa');

  Future<Map<String, String?>> _getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'address': prefs.getString('address'),
      'email': prefs.getString('email'),
    };
  }

  bool isLoading = false;
  bool isLoadingLogout = false;

  // -------- fonction to select a picture or to take a picture ----------
  showDialogConfirm() {
    //show a dialog box to ask user to confirm to remove from cart
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        content: AppText(
          text: translate('chat.show_message_3'),
          textAlign: TextAlign.center,
        ),
        actions: [
          //camera method
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: ListTile(
              title: Center(
                child: AppText(
                  text: translate('chat.button_4'),
                ),
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () async {},
            ),
          ),
          sizedbox,
          //galarie method
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: ListTile(
              title: Center(
                child: AppText(
                  text: translate('chat.button_5'),
                ),
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () async {},
            ),
          ),

          //cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: AppText(
              text: translate('button.cancel'),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // -------- Desconnected item from app method ----------
  showDialogLogout() {
    // Show a dialog box to ask the user to confirm logout
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        content: AppText(
          text: translate("settings.logout_message"),
          textAlign: TextAlign.center,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText(
              text: translate('button.cancel'),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

          // Yes button
          TextButton(
            onPressed: () async {
              setState(() {
                isLoadingLogout = true; // Start loading
              });

              // Clear user data from SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('name');
              await prefs.remove('userId');

              // Optionally, navigate to the LoginPage or another screen
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        MainPage()), // Replace with your login page
                (Route<dynamic> route) => false,
              );

              setState(() {
                isLoadingLogout = false; // Stop loading
              });
            },
            child: isLoadingLogout
                ? CupertinoActivityIndicator(
                    color: Theme.of(context).colorScheme.primary)
                : AppText(text: translate("settings.logout")),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: _currentPageIndex);

    // Écouter les changements d'onglets et mettre à jour la page correspondante
    _tabController.addListener(() {
      if (_tabController.index != _currentPageIndex) {
        _pageController.jumpToPage(_tabController.index);
      }
    });

    // Écouter les changements de page et mettre à jour l'index de l'onglet
    _pageController.addListener(() {
      if (_pageController.page!.round() != _currentPageIndex) {
        _tabController.animateTo(
          _pageController.page!.round(),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: AppText(
          text: 'Profil',
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              sizedbox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 2,
                          ),
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      Positioned(
                        child: InkWell(
                          onTap: () async => showDialogConfirm(),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 2,
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: Icon(
                              FluentIcons.camera_28_regular,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              sizedbox,
              Container(
                padding: EdgeInsets.only(
                    left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).highlightColor,
                ),

                height: 45.0, // Hauteur totale du TabBar
                child: TabBar(
                  controller: _tabController,
                  automaticIndicatorColorAdjustment: false,
                  tabs: [
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                8.0), // Espace de 8 pixels à gauche et à droite
                        child: Container(
                          height: 40.0, // Hauteur fixe pour chaque onglet
                          alignment: Alignment.center,
                          child: Text(
                            translate('User'),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 40.0,
                          alignment: Alignment.center,
                          child: Text(
                            translate('Settings'),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                  dividerColor: Colors.transparent,

                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                        8), // Coins arrondis pour l'indicateur
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,

                  labelColor: Theme.of(context).colorScheme.inversePrimary,
                  unselectedLabelColor: Colors.grey,
                  labelPadding:
                      EdgeInsets.zero, // Réinitialiser le padding des labels
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    // Vérifiez si le widget est encore monté avant de mettre à jour l'état
                    if (mounted) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    }
                  },
                  children: [
                    SingleChildScrollView(child: user()),
                    SingleChildScrollView(child: setting()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget user() {
    return FutureBuilder<Map<String, String?>>(
      future: _getUserInfo(), // Appel à la méthode pour récupérer les infos
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur lors de la récupération des données'));
        } else {
          // Données récupérées avec succès
          final userInfo = snapshot.data;

          // Vérifiez si l'utilisateur est connecté
          if (userInfo?['email'] == null || userInfo!['email']!.isEmpty) {
            return Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black12,
                    child: Icon(
                      CupertinoIcons.person,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                  AppTextLarge(
                    text: "Connecte-toi ou crée un compte pour voir vos statistiques !",
                    size: 16,
                    textAlign: TextAlign.center,
                  ),
                  sizedbox,
                  NextButton(
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    width: 200,
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Theme.of(context).colorScheme.background,
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: LoginPage(),
                          );
                        },
                      );
                    },
                    child: AppText(
                      text: "S'inscrire ou se connecter",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedbox,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  height: 50.0,
                  child: CupertinoTextField(
                    padding: EdgeInsets.only(left: 15),
                    controller: name..text = userInfo['name'] ?? '',
                    placeholder: 'Nom',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontFamily: 'Montserrat',
                    ),
                    readOnly: true,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                sizedbox,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  height: 50.0,
                  child: CupertinoTextField(
                    padding: EdgeInsets.only(left: 15),
                    controller: adress..text = userInfo['address'] ?? '',
                    placeholder: 'Adresse',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontFamily: 'Montserrat',
                    ),
                    readOnly: true,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Icon(CupertinoIcons.location_solid),
                    ),
                  ),
                ),
                sizedbox,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  height: 50.0,
                  child: CupertinoTextField(
                    padding: EdgeInsets.only(left: 15),
                    controller: email..text = userInfo['email'] ?? '',
                    placeholder: 'Email',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontFamily: 'Montserrat',
                    ),
                    readOnly: true,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Icon(CupertinoIcons.mail),
                    ),
                  ),
                ),
                sizedbox,
                sizedbox,
                Center(
                  child: NextButton(
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () async {
                      // Ajoutez ici la logique pour sauvegarder les modifications si besoin
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.save_edit_24_regular,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        AppText(
                          text: translate('Sauvegarde'),
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }

  Widget setting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            children: [
              card1(
                ontap: () {
                  showLanguagePopup(context: context);
                },
                icon: Icons.translate_outlined,
                title: translate("settings.language"),
                icon2: Icons.switch_right_outlined,
                showLast: false,
              ),
              Consumer<ThemeProvider>(
                builder: (context, provider, child) {
                  bool theme = provider.currentTheme;
                  return myCard(
                    ontap: () => provider.changeTheme(!theme),
                    context: context,
                    fistWidget:
                        const Icon(FluentIcons.brightness_high_48_filled),
                    title: theme
                        ? translate('theme.light')
                        : translate('theme.dark'),
                    secondWidget: const Icon(FluentIcons.arrow_fit_20_regular),
                    showLast: true,
                  );
                },
              ),
            ],
          ),
        ),
        sizedbox,
        sizedbox,
        AppText(
          text: translate("settings.support_and_feedback").toUpperCase(),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            children: [
              myCard(
                ontap: () {
                  showMessageDialog(context,
                      title: translate("settings.contactUs"),
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(text: 'WWW.Futela.com'),
                        ],
                      ),
                      isConfirmation: false,
                      isSale: false);
                },
                context: context,
                fistWidget: const Icon(FluentIcons.call_48_regular),
                title: translate("settings.contactUs"),
                showLast: false,
              ),
              myCard(
                ontap: () {
                  // donner les avis
                  StoreRedirect.redirect(
                    androidAppId: 'com.naara.futela',
                    iOSAppId: 'com.naara.futela',
                  );
                },
                context: context,
                fistWidget: const Icon(FluentIcons.star_half_28_regular),
                title: translate("settings.leaveReview"),
                showLast: true,
              ),
              // card1(
              //     ontap: () {
              //
              //     },
              //     icon: CupertinoIcons.share,
              //     title: translate("settings.shareApp"),
              //     showLast: true)
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppText(
          text: translate("settings.app").toUpperCase(),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            children: [
              myCard(
                ontap: () {
                  // myLaunchUrl(
                  //     'https://raw.githubusercontent.com/Pacome0106/isKiling_app_info/main/README.md');
                },
                context: context,
                fistWidget: const Icon(FluentIcons.shield_error_24_regular),
                title: translate("settings.privacy_policy"),
                showLast: false,
              ),
              myCard(
                ontap: () {
                  // myLaunchUrl(
                  //     'https://raw.githubusercontent.com/Pacome0106/isKiling_app_info/main/conditions.md');
                },
                context: context,
                fistWidget:
                    const Icon(FluentIcons.book_question_mark_24_regular),
                title: translate("settings.terms_and_conditions"),
                showLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: myCard(
            ontap: () => showDialogLogout(),
            context: context,
            fistWidget: const Icon(FluentIcons.sign_out_24_regular),
            secondWidget: const SizedBox(),
            title: translate("settings.logout"),
            showLast: true,
          ),
        ),
        sizedbox,
        sizedbox,
      ],
    );
  }

  Widget myCard({
    required BuildContext context,
    required Function() ontap,
    required Widget fistWidget,
    required String title,
    Widget secondWidget = const Icon(FluentIcons.ios_chevron_right_20_regular),
    bool showLast = false,
  }) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          ListTile(
            leading: fistWidget,
            title: Container(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: title,
              ),
            ),
            trailing: secondWidget,
            // subtitle: Container(),
          ),
          if (!showLast) const Lign(indent: 60, endIndent: 0)
        ],
      ),
    );
  }

  Widget card1({
    required VoidCallback ontap,
    required IconData icon,
    required String title,
    IconData icon2 = Icons.navigate_next_outlined,
    bool showLast = false,
  }) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon),
            title: Container(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: title,
              ),
            ),
            trailing: Icon(icon2),
          ),
          if (!showLast)
            Container(
              margin: EdgeInsets.only(left: 60),
              height: 0.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
        ],
      ),
    );
  }
}
