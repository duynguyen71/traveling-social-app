import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
      {Key? key,
      required this.text,
      this.textStyle,
      this.textAlign,
      this.textColor = Colors.white})
      : super(key: key);

  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Color? textColor;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with AutomaticKeepAliveClientMixin {
  bool isExpandableText = false;

  @override
  void initState() {
    if (widget.text.length > 100) {
      setState(() {
        isExpandableText = true;
      });
    } else {
      setState(() {
        isExpandableText = false;
      });
    }
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.text,
          style: widget.textStyle ?? TextStyle(color: widget.textColor),
          maxLines: isExpandableText ? 2 : null,
          overflow: isExpandableText ? TextOverflow.ellipsis : null,
          textAlign: widget.textAlign ?? TextAlign.start,
        ),
        widget.text.length > 100
            ? TextButton(
                onPressed: () {
                  setState(() {
                    isExpandableText = !isExpandableText;
                  });
                },
                child: Text(
                  isExpandableText
                      ? AppLocalizations.of(context)!.showMore
                      : AppLocalizations.of(context)!.showLess,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
