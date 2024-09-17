import 'package:app/pages/register/controllers/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SelectSite extends StatefulWidget {
  const SelectSite({
    super.key,
  });

  @override
  State<SelectSite> createState() => _SelectSiteState();
}

class _SelectSiteState extends State<SelectSite> {
  final controller = Get.find<RegisterController>();

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
        const Text('Location',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Flexible(
            child: Obx(() => (controller.corps.isEmpty)
                ?  const Center(child: CupertinoActivityIndicator())
                : CupertinoButton(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      _showDialog(
                        CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          scrollController: FixedExtentScrollController(
                            initialItem: 0,
                          ),
                          onSelectedItemChanged: (int selectedItem) {
                            controller.setSite(
                                controller.selectedCorp().sites[selectedItem]);
                          },
                          children: List<Widget>.generate(
                              controller.selectedCorp().sites.length, (int i) {
                            return Center(
                                child: Text(
                              controller.selectedCorp().sites[i].name,
                            ));
                          }),
                        ),
                      );
                    },
                    child: Text(
                      controller.selectedSite().name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ))),
      ],
    );
  }
}
