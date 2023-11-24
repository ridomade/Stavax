import 'dart:io';

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../provider/classSong.dart';
import '../screen/musicplayer.dart';

List<Songs> filteredSongs = songArr;

class search_song extends StatefulWidget {
  const search_song({Key? key}) : super(key: key);

  @override
  _search_songState createState() => _search_songState();
}

class _search_songState extends State<search_song> {
  String searchString = ''; // Variabel penyimpanan string pencarian

  @override
  Widget build(BuildContext context) {
    filterSongs(); // Filter daftar lagu berdasarkan pencarian

    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              "Search",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 19, right: 19),
        child: Column(
          children: [
            SizedBox(
              height: 7,
            ),
            formCari(),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  return songSearchResult(
                    iniListLagu: filteredSongs[index],
                    currIdx: index,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formCari() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      decoration:
          BoxDecoration(color: color3, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchString = value; // Update string pencarian saat nilai berubah
          });
        },
      ),
    );
  }

  void filterSongs() {
    filteredSongs = songArr
        .where((song) =>
            song.title.toLowerCase().contains(searchString.toLowerCase()))
        .toList();
  }
}

class songSearchResult extends StatelessWidget {
  final Songs iniListLagu;
  final int currIdx;

  const songSearchResult(
      {Key? key, required this.iniListLagu, required this.currIdx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 82,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
              color: Color(0xff004e96),
              borderRadius: BorderRadius.all(Radius.circular(9))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AudioPlayerScreen(
                      listSong: filteredSongs,
                      song: filteredSongs[currIdx],
                      CurrIdx: currIdx,
                    );
                  }));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: iniListLagu.image != null
                            ? File(iniListLagu.image)
                                    .existsSync() // Check if it's a local file
                                ? Image.file(
                                    File(iniListLagu.image),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : iniListLagu.image.startsWith(
                                        'assets/') // Check if it's an asset
                                    ? Image.asset(
                                        iniListLagu.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        iniListLagu.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                            : SizedBox.shrink(),
                      ),
                      // ClipRRect(
                      //   child: Image.asset(
                      //     iniListLagu.image,
                      //     height: 60,
                      //     width: 60,
                      //   ),
                      //   borderRadius: BorderRadius.all(Radius.circular(5)),
                      // ),
                      SizedBox(
                        width: 11.81,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            iniListLagu.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            iniListLagu.artist,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Icon(Icons.more_vert_rounded,
                  color: Color.fromARGB(255, 255, 255, 255), size: 30),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
