import 'package:flutter/cupertino.dart';
import '../../../utils/size_config.dart';

class UserIcon extends StatelessWidget {
  const UserIcon({Key? key}) : super(key: key);

  final String path = 'assets/images/avatar.png';

  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage(path);
    print(path);
    Image image = Image(image: assetImage);
    return Container(
      child: image,
      //width: SizeConfig.screenWidth * 1 ,
      //height: SizeConfig.screenHeight * 1 ,
    );
  }
}
