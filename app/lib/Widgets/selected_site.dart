import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:app/States/register_form.dart';
// import 'package:app/api/corps.dart';

class SelectedSite extends StatefulWidget {
  const SelectedSite({super.key});

  @override
  State<SelectedSite> createState() => _SelectedSiteState();
}

class _SelectedSiteState extends State<SelectedSite> {
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
    final form = Provider.of<RegisterForm>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Selected your site: '),
        const SizedBox(height: 7),
        Consumer<RegisterForm>(
            builder: (_, value, __) => CupertinoButton.filled(
                onPressed: (value.corp == null)
                    ? null
                    : () {
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
                              form.site = value.corp!.sites[selectedItem];
                            },
                            children: List<Widget>.generate(
                                value.corp!.sites.length, (int i) {
                              return Center(
                                  child: Text(
                                value.corp!.sites[i].name,
                              ));
                            }),
                          ),
                        );
                      },
                child: Center(
                  child: Text(
                    (value.site == null)
                        ? "Selected Site First"
                        : value.site!.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                )))
      ],
    );
  }
}
