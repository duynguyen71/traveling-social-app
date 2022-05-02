import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/screens/edit_profile/components/custom_outline_text_field.dart';

class DialogEditImage extends StatelessWidget {
  const DialogEditImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomOutlineTextField(
            controller: null,
            hintText: "Image Url",
            labelText: "Image",
            validate: null,
          ),
          SizedBox(height: 20),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.camera, color: kPrimaryColor),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text("Cacel"),
              ),
              SizedBox(width: 20),
              Text("Save"),
              SizedBox(width: 20),
            ],
          )
        ],
      ),
    );
  }
}
