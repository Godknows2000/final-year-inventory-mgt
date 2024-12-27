import 'dart:io';
import 'package:hugeicons/hugeicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Repository/login_repo.dart';
import 'package:salespro_admin/Screen/Authentication/sign_up.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
import 'package:salespro_admin/Screen/Widgets/static_string/static_string.dart';
import 'package:salespro_admin/const.dart';
import '../../Repository/signup_repo.dart';
import '../Widgets/Constant Data/constant.dart';
import 'forgot_password.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import 'package:responsive_framework/responsive_framework.dart' as rf;

class EmailLogIn extends StatefulWidget {
  const EmailLogIn({super.key});

  static const String route = '/login/email';

  @override
  State<EmailLogIn> createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  late String email, password;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? user;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> checkUser({required BuildContext context}) async {
    final isActive = await PurchaseModel().isActiveBuyer();
    if (isActive) {
      validateAndSave();
      return true;
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Not Active User"),
          content:
              const Text("Please use the valid purchase code to use the app."),
          actions: [
            TextButton(
              onPressed: () {
                // Exit app
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {
                  exit(0);
                }
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
  }

  void showPopUP() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: 400,
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        FeatherIcons.x,
                        color: kTitleColor,
                      ).onTap(() {
                        finish(context);
                      }),
                    ],
                  ),
                  const SizedBox(height: 100.0),
                  Text(
                    lang.S.of(context).pleaseDownloadOurMobileApp,
                    textAlign: TextAlign.center,
                    style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 21.0),
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: const DecorationImage(
                              image: AssetImage('images/playstore.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: const DecorationImage(
                              image: AssetImage('images/appstore.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var currentUser = FirebaseAuth.instance.currentUser;
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    bool isTabAndPhone = rf.ResponsiveValue<bool>(context,
        defaultValue: false,
        conditionalValues: [
          rf.Condition.smallerThan(name: BreakpointName.MD.name, value: true)
        ]).value;
    bool isMobile = rf.ResponsiveValue<bool>(context,
        defaultValue: false,
        conditionalValues: [
          rf.Condition.smallerThan(name: BreakpointName.LG.name, value: true)
        ]).value;
    return Scaffold(
      backgroundColor: kMainColor600,
      body: PopScope(
        canPop: true,
        child: Consumer(builder: (context, ref, watch) {
          final loginProvider = ref.watch(logInProvider);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.white, // Background color of the container
                        borderRadius: BorderRadius.circular(
                            100), // Adjust the radius as needed
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            blurRadius: 10, // Shadow blur
                            spreadRadius: 2, // Shadow spread
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(
                          10), // Padding inside the container
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            100), // Match the container's radius
                        child: Image.asset(
                          'images/app-icon.png',
                          height: 65,
                        ),
                      ),
                    ),
                    ResponsiveGridRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveGridCol(
                              lg: 6,
                              md: 6,
                              child: Center(
                                child: Container(
                                  height: isTabAndPhone
                                      ? MediaQuery.of(context).size.width / 1.1
                                      : MediaQuery.of(context).size.height /
                                          1.2,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(isTabAndPhone
                                              ? 'images/loginLogo2.png'
                                              : 'images/login logo.png'))),
                                ),
                              )),
                          ResponsiveGridCol(
                              lg: 6,
                              md: 6,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: isTabAndPhone ? 10 : 50,
                                    left: isTabAndPhone ? 10 : 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(isMobile ? 20 : 44.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Welcome to ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontSize: isMobile
                                                              ? 24
                                                              : 40,
                                                          color: kTitleColor,
                                                          fontWeight: isMobile
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                                  .bold),
                                                  children: [
                                                TextSpan(
                                                  text: 'Final Year Project',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontSize: isMobile
                                                              ? 24
                                                              : 40,
                                                          color: kMainColor600,
                                                          fontWeight: isMobile
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                                  .bold),
                                                )
                                              ])),
                                          Text(
                                            'Welcome back, Please login in to your account',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    color: kNutral500,
                                                    fontSize:
                                                        isMobile ? 14 : 20),
                                          ),
                                          SizedBox(
                                            height: isMobile ? 15 : 25,
                                          ),
                                          Form(
                                            key: globalKey,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Email can\'n be empty';
                                                    } else if (!value
                                                        .contains('@')) {
                                                      return 'Please enter a valid email';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    loginProvider.email = value;
                                                  },
                                                  showCursor: true,
                                                  controller: emailController,
                                                  cursorColor: kTitleColor,
                                                  decoration:
                                                      kInputDecoration.copyWith(
                                                    prefixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 48,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color:
                                                                      kBorderColor)),
                                                          // color: Color(0xff98A2B3),
                                                        ),
                                                        child: const HugeIcon(
                                                          icon: HugeIcons
                                                              .strokeRoundedMail01,
                                                          color: kNutral600,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                    hintText:
                                                        'Enter your email address',
                                                    hintStyle:
                                                        kTextStyle.copyWith(
                                                            color: kNutral700),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(4.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                          color: kBorderColor,
                                                          width: 1),
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                      borderSide: BorderSide(
                                                          color: kMainColor600,
                                                          width: 1),
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                ),
                                                const SizedBox(height: 20.0),
                                                TextFormField(
                                                  obscureText: _hidePassword,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Password can\'t be empty';
                                                    } else if (value.length <
                                                        4) {
                                                      return 'Please enter a bigger password';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    loginProvider.password =
                                                        value;
                                                  },
                                                  controller:
                                                      passwordController,
                                                  showCursor: true,
                                                  cursorColor: kTitleColor,
                                                  decoration:
                                                      kInputDecoration.copyWith(
                                                    prefixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 48,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color:
                                                                      kBorderColor)),
                                                          // color: Color(0xff98A2B3),
                                                        ),
                                                        child: const HugeIcon(
                                                          icon: HugeIcons
                                                              .strokeRoundedSquareLock02,
                                                          color: kNutral600,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                    ),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _hidePassword =
                                                                !_hidePassword;
                                                          });
                                                        },
                                                        icon: _hidePassword
                                                            ? const Icon(
                                                                Icons
                                                                    .visibility_off_outlined,
                                                                color:
                                                                    kNutral600,
                                                              )
                                                            : const HugeIcon(
                                                                icon: HugeIcons
                                                                    .strokeRoundedView,
                                                                color: Colors
                                                                    .black,
                                                                size: 24.0,
                                                              )),
                                                    // labelText: 'Password',
                                                    floatingLabelAlignment:
                                                        FloatingLabelAlignment
                                                            .start,
                                                    labelStyle:
                                                        kTextStyle.copyWith(
                                                            color: kTitleColor),
                                                    hintText:
                                                        'Enter your password',
                                                    hintStyle:
                                                        kTextStyle.copyWith(
                                                            color: kNutral700),
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(4.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                          color: kBorderColor,
                                                          width: 1),
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                      borderSide: BorderSide(
                                                          color: kMainColor600,
                                                          width: 2),
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                ),
                                                const SizedBox(height: 10.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: ListTile(
                                                        onTap: () =>
                                                            Navigator.pushNamed(
                                                                context,
                                                                ForgotPassword
                                                                    .route),
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        horizontalTitleGap: 5,
                                                        leading: const HugeIcon(
                                                          icon: HugeIcons
                                                              .strokeRoundedSquareLock02,
                                                          color: kNutral600,
                                                          size: 24.0,
                                                        ),
                                                        title: Text(
                                                          'Forgot password?',
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kTitleColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Expanded(
                                                      flex: 1,
                                                      child: ListTile(
                                                        onTap: () =>
                                                            Navigator.pushNamed(
                                                                context,
                                                                SignUp.route),
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        horizontalTitleGap: 5,
                                                        leading: const HugeIcon(
                                                          icon: HugeIcons
                                                              .strokeRoundedUserAdd01,
                                                          color: kNutral600,
                                                          size: 24.0,
                                                        ),
                                                        title: Text(
                                                          'Register',
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kTitleColor),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        isMobile ? 10 : 20.0),
                                                ButtonGlobal(
                                                    buttontext: 'Login',
                                                    buttonDecoration:
                                                        kButtonDecoration.copyWith(
                                                            color:
                                                                kMainColor600,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0)),
                                                    onPressed: () async {
                                                      if (validateAndSave()) {
                                                        loginProvider
                                                            .signIn(context);
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                        ]),
                  ],
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
