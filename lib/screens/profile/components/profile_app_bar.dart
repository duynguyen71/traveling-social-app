import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traveling_social_app/screens/profile/components/create_post_type_dialog.dart';

import '../../../authentication/bloc/authentication_bloc.dart';
import '../../../authentication/bloc/authentication_state.dart';
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
      title: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) => Text(
          state.user.username,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        listener: (p0, p1) => p1.user.username.toString(),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
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
