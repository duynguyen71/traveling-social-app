import 'package:flutter/material.dart';
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/utilities/ValidationUntil.dart';
import 'package:traveling_social_app/widgets/rounded_button.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';
import 'package:provider/provider.dart';

class DayCostInputDialog extends StatefulWidget {
  const DayCostInputDialog({Key? key}) : super(key: key);

  @override
  State<DayCostInputDialog> createState() => _DayCostInputDialogState();
}

class _DayCostInputDialogState extends State<DayCostInputDialog> {
  final _costController = TextEditingController();
  final _dayController = TextEditingController();
  String? costError;
  String? dayError;

  _saveCost(BuildContext context) {
    var cost = _costController.text;
    // if (cost.isEmpty ||!ValidationUntil.isNumber(cost)) setState(() => costError = "Please select cost");
    var days = _dayController.text;
    // if (days.isEmpty||!ValidationUntil.isNumber(days)) setState(() => dayError = "Please select days");
    context.read<CreateReviewPostCubit>().updateReviewPost(
          cost: double.tryParse(cost),
          days: int.tryParse(days),
        );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    var post = context.read<CreateReviewPostCubit>().state.post;
    _dayController.text = post.days.toString();
    _dayController.selection = TextSelection.fromPosition(
        TextPosition(offset: _dayController.text.length));
    _costController.text = post.cost.toString();
    _costController.selection = TextSelection.fromPosition(
        TextPosition(offset: _costController.text.length));
  }

  @override
  void dispose() {
    _costController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Total day',
                    errorText: dayError,
                  ),
                  controller: _dayController,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Cost', errorText: costError),
                  keyboardType: TextInputType.number,
                  controller: _costController,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () => _saveCost(context),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: RoundedIconButton(
                  onClick: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.close,
                  size: 22))
        ],
      ),
    );
  }
}
