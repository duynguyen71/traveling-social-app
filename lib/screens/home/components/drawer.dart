import 'package:flutter/material.dart';
import 'package:traveling_social_app/constants/app_theme_constants.dart';
import 'package:traveling_social_app/models/NavigationItem.dart';
import 'package:traveling_social_app/models/User.dart';
import 'package:traveling_social_app/screens/home/components/drawer_header.dart';
import 'package:traveling_social_app/screens/login/login_screen.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/view_model/user_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 250.0,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [DrawerHeaderUserCard(user: user)],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: navigationItems.length,
                itemBuilder: (context, index) {
                  NavigationItem item = navigationItems[index];
                  return Material(
                    child: InkWell(
                      child: ListTile(
                        leading: Icon(item.iconData),
                        title: Text(item.title),
                        hoverColor: Colors.red,
                        focusColor: Colors.red,
                        onTap: () {
                          onNavigationClickItemPressed(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const DrawerFooter(),
          ],
        ),
      ),
    );
  }

  void onNavigationClickItemPressed(BuildContext context, int index) {
    switch (index) {
      case 3:
        {
          //close the drawer
          // Navigator.pop(context);
          //
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => ProfileSettingScreen(),
          //     ));

          break;
        }
      case 5: //sign out
        {
          ApplicationUtility.pushAndReplace(context, const LoginScreen());
          context.read<UserViewModel>().signOut();
          // context.read<AuthenticateService>().signOut();
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
          break;
        }

      default:
        {
          // Navigator.pop(context);
          return;
        }
    }
  }
}

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.all(kDefaultPadding / 4),
      child: Text(
        "khanhduytravel.com",
        style:
            Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
      ),
      decoration: const BoxDecoration(color: kPrimaryColor),
    );
  }
}
