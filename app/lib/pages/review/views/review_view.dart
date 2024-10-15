import 'dart:convert';

import 'package:app/pages/error/views/error_view.dart';
import 'package:app/pages/review/controllers/review_controller.dart';
import 'package:app/services/api_service.dart';
import 'package:app/widgets/input_part_layout.dart';
import 'package:app/widgets/register_btn.dart';
import 'package:app/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  Future<void> confirmRegisterEmployee() async {
    Utils(Get.context!).startLoading();

    var token = await ApiService.to.getToken();
    // print('Review token is $token');
    final body = ReviewController.to.employee().toJson();

    final response = await http.post(
      Uri.parse('https://${ApiService.host}/api/v1/emp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token == null ? '' : 'Bearer $token'
      },
      body: body,
    );

    Utils(Get.context!).stopLoading();

    if (response.statusCode == 401) {
      Get.offAllNamed('/login');
      return;
    }

    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      Get.to(const ErrorView(
        title: 'Review',
        message: 'Something went wrong,\nPlease try again later.',
      ));
      return;
    }

    showCupertinoDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => const _ShowSuccess(),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/');
    });
    return;

    // ApiService.to
    //     .confirmRegisterEmployee(ReviewController.to.employee())
    //     .then((response) {
    //   Utils(ctx).stopLoading();
    //   if (response.status.isOk) {
    //     showCupertinoDialog(
    //       context: ctx,
    //       barrierDismissible: false,
    //       builder: (_) => const _ShowSuccess(),
    //     );
    //     Future.delayed(const Duration(seconds: 2), () {
    //       Get.offAllNamed('/');
    //     });
    //     return;
    //   }

    //   if (response.status.isServerError) {
    //     final body = json.decode(response.bodyString!) as Map<String, dynamic>;
    //     print('========= ReviewView confirmRegisterEmployee ${body}');
    //     Get.off(const ErrorView(
    //       title: 'Face Scan',
    //       message: 'Something went wrong,\nPlease try again later.',
    //     ));
    //     return;
    //   }

    //   final body = json.decode(response.bodyString!) as Map<String, dynamic>;
    //   Utils(ctx).showError('Error: ${body['detail']}');
    // }).onError((error, stack) {
    //   Utils(ctx).stopLoading();
    //   Get.off(const ErrorView(
    //     title: 'Face Scan',
    //     message: 'Something went wrong,\nPlease try again later.',
    //   ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Review'),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: controller.obx(
                (employee) => ListView(children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 26.0, bottom: 28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Review Employee',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0)),
                              SizedBox(height: 12),
                              Text(
                                  'Review employee data that extracted (ocr) from id card.'),
                            ],
                          ),
                        ),
                      ),
                      InputPartLayout(title: 'Extracted Data', children: [
                        _DisplayData(
                            title: 'ID', controller: controller.idController()),
                        _DisplayData(
                            title: 'First Name TH',
                            controller: controller.fnameTHController()),
                        _DisplayData(
                            title: 'Last Name TH',
                            controller: controller.lnameTHController()),
                        _DisplayData(
                            title: 'First Name EN',
                            controller: controller.fnameENController()),
                        _DisplayData(
                            title: 'Last Name EN',
                            controller: controller.lnameENController()),
                        _DisplayData(
                          title: 'Site',
                          controller: controller.siteController(),
                          editable: false,
                        ),
                        _DisplayData(
                            title: 'Username',
                            controller: controller.usernameController()),
                        _DisplayData(
                            title: 'Email',
                            controller: controller.emailController()),
                        _DisplayData(
                            title: 'Password',
                            controller: controller.passwordController()),
                        const _DisplaySelectIsAdmin() //! admin
                      ]),
                      Obx(() => RegisterButtonLayout(
                            onPrev: () => Get.back(),
                            nextTitle: 'Submit',
                            onNext: !(controller.valid())
                                ? null
                                : confirmRegisterEmployee,
                          ))
                    ]),
                onLoading: const Center(child: CupertinoActivityIndicator()),
                onError: (message) => Center(
                    child: Text(message!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: "Netflix",
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold))))));
  }
}

class _DisplayData extends StatelessWidget {
  const _DisplayData(
      {required this.title, this.controller, this.editable = true});

  final String title;
  final TextEditingController? controller;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
        placeholder: 'Required',
        prefix: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        decoration: const BoxDecoration(),
        controller: controller,
        readOnly: !editable);
  }
}

class _DisplaySelectIsAdmin extends StatefulWidget {
  const _DisplaySelectIsAdmin();

  @override
  State<_DisplaySelectIsAdmin> createState() => _DisplaySelectIsAdminState();
}

class _DisplaySelectIsAdminState extends State<_DisplaySelectIsAdmin> {
  final options = [false, true];
  var index = 0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Admin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Flexible(
            child: CupertinoButton(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          onPressed: () {
            _showDialog(
              CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(
                  initialItem: index,
                ),
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    index = selectedItem;
                  });
                  ReviewController.to.setIsAdmin(options[selectedItem]);
                },
                children: List<Widget>.generate(options.length, (int i) {
                  return Center(
                      child: Text(
                    options[i] ? "Yes" : "No",
                  ));
                }),
              ),
            );
          },
          child: Text(
            options[index] ? "Yes" : "No",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        )),
      ],
    );
  }
}

class _ShowSuccess extends StatefulWidget {
  const _ShowSuccess({super.key});

  @override
  State<_ShowSuccess> createState() => _ShowSuccessState();
}

class _ShowSuccessState extends State<_ShowSuccess>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutExpo,
      ),
    );

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ScaleTransition(
      scale: _animation,
      child: const Icon(
        CupertinoIcons.check_mark_circled,
        size: 160,
        color: CupertinoColors.systemGreen,
      ),
    ));
  }
}
