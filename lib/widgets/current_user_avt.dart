import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/constants/api_constants.dart';

import '../authentication/bloc/authentication_state.dart';
import '../view_model/user_view_model.dart';

class CurrentUserAvt extends StatelessWidget {
  const CurrentUserAvt({
    Key? key,
    required this.onTap,
    required this.size,
  }) : super(key: key);
  final Function onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => onTap(),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
              ),
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: FittedBox(
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    imageUrl: '$imageUrl${state.user.avt}',
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                    errorWidget: (context, value, c) =>
                        Image.asset('assets/images/blank-profile-picture.png'),
                  ),
                ),
              ),
            ),
          );
        },
     );
  }
}
