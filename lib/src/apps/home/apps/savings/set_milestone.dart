import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mukai/brick/models/milestones.model.dart';
import 'package:mukai/brick/models/saving.model.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:flutter/material.dart';

class MilestoneInputWidget extends StatefulWidget {
  final ValueChanged<List<Milestone>> onMilestonesChanged;
  const MilestoneInputWidget({required this.onMilestonesChanged});

  @override
  State<MilestoneInputWidget> createState() => _MilestoneInputWidgetState();
}

class _MilestoneInputWidgetState extends State<MilestoneInputWidget> {
  List<TextEditingController> _nameControllers = [TextEditingController()];
  List<TextEditingController> _amountControllers = [TextEditingController()];
  WalletController get walletController => Get.put(WalletController());

  void _addMilestone() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _amountControllers.add(TextEditingController());
    });
  }

  @override
  void initState() {
    super.initState();
    // Ensure controllers are in sync
    if (_amountControllers.length < _nameControllers.length) {
      _amountControllers.addAll(
        List.generate(_nameControllers.length - _amountControllers.length,
            (_) => TextEditingController()),
      );
    }
  }

  @override
  void dispose() {
    for (var c in _nameControllers) {
      c.dispose();
    }
    for (var c in _amountControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() {
    final milestones = List.generate(_nameControllers.length, (i) {
      final name = _nameControllers[i].text.trim();
      final amount = _amountControllers[i].text.trim();
      return Milestone(name: name, amount: amount);
    }).where((m) => m.name.isNotEmpty || m.amount.isNotEmpty).toList();
    widget.onMilestonesChanged(milestones);
    // save milestones
  }

  void _removeMilestone(int index) {
    setState(() {
      _nameControllers[index].dispose();
      _nameControllers.removeAt(index);
      _amountControllers[index].dispose();
      _amountControllers.removeAt(index);
    });
    _onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Milestones', style: semibold14Black),
        heightSpace,
        ...List.generate(_nameControllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: boxWidget(
                    child: TextField(
                      controller: _nameControllers[i],
                      onChanged: (_) => _onChanged(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Milestone ${i + 1}',
                        hintStyle: semibold14Grey,
                        contentPadding: EdgeInsets.all(fixPadding * 1.5),
                      ),
                      style: semibold14Black,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: boxWidget(
                    child: TextField(
                      controller: _amountControllers[i],
                      onChanged: (_) => _onChanged(),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Amount',
                        hintStyle: semibold14Grey,
                        contentPadding: EdgeInsets.all(fixPadding * 1.5),
                      ),
                      style: semibold14Black,
                    ),
                  ),
                ),
                if (_nameControllers.length > 1)
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeMilestone(i),
                  ),
              ],
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addMilestone,
            icon: Icon(Icons.add, color: primaryColor),
            label: Text('Add Milestone', style: TextStyle(color: primaryColor)),
          ),
        ),
      ],
    );
  }

  boxWidget({required Widget child}) {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: screenBGColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: recShadow,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: recWhiteColor,
        ),
        child: child,
      ),
    );
  }
}
