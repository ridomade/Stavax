import 'package:flutter/material.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../provider/classPlaylist.dart';
import '../screen/detailedPlaylist.dart';
import '../constants/colors.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class playlist_home extends StatelessWidget {
  final Playlist iniplaylist;
  final UsersProvider listPlaylist;
  final int currIdx;
  const playlist_home(
      {Key? key,
      required this.iniplaylist,
      required this.listPlaylist,
      required this.currIdx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return detailedPlaylist(
              iniPlaylist: context.watch<UsersProvider>().playListArr[currIdx],
              currIdx: currIdx);
        }));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image.file(
                File(iniplaylist.image),
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              iniplaylist.name,
              style: TextStyle(
                height: 2,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              iniplaylist.desc,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        width: 120,
        height: 148,
        decoration: BoxDecoration(
          color: color3,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
