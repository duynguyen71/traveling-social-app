import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/screens/profile/components/create_post_type_dialog.dart';
import 'package:traveling_social_app/view_model/user_view_model.dart';

import '../../../constants/app_theme_constants.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _handleButtonCreatePostClicked() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const CreatePostTypeDialog();
        },
        backgroundColor: Colors.transparent,
      );
    }

    return SliverAppBar(
      centerTitle: true,
      title: Selector<UserViewModel, String>(
        builder: (context, value, child) => Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        selector: (p0, p1) => p1.user!.username.toString(),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop([true]);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black45,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 1),
        child: Divider(
          color: kPrimaryColor.withOpacity(.2),
          height: 1,
        ),
      ),
      backgroundColor: Colors.white,
      // title: Text('Traveling Crew',style: TextStyle(color: Colors.black,fontSize: 20),),
      floating: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/search.svg",
            color: Colors.black87,
          ),
        ),
        IconButton(
            onPressed: () => _handleButtonCreatePostClicked(),
            icon: const Icon(Icons.edit, color: Colors.black45)),
        const SizedBox(
          width: 5,
        ),
      ],
      // expandedHeight: 250,
    );
  }
}
