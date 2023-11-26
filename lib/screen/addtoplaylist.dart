import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../constants/colors.dart';
import '../provider/classSong.dart';
import '../screen/musicplayer.dart';
import '../provider/classPlaylist.dart';

List<Songs> filteredSongs = songArr;
List<Playlist> playlistParam = [];
List<Songs> songParam = [];

class addToPlaylist extends StatefulWidget {
  final Playlist iniplaylist;
  const addToPlaylist({Key? key, required this.iniplaylist}) : super(key: key);

  @override
  _addToPlaylistState createState() => _addToPlaylistState();
}

class _addToPlaylistState extends State<addToPlaylist> {
  String searchString = ''; // Variabel penyimpanan string pencarian

  @override
  Widget build(BuildContext context) {
    filterSongs();
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
              "Add To Playlist",
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
        padding: EdgeInsets.only(top: 10, left: 19, right: 19),
        child: Column(
          children: [
            SizedBox(
              height: 2,
            ),
            formCari(),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  return searchSongResult(
                      iniListLagu: songArr[index],
                      iniPlaylist: widget.iniplaylist);
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (playlistParam.isNotEmpty && songParam.isNotEmpty) {
                      for (int i = 0; i < playlistParam.length; i++) {
                        print(">>>>>>");
                        print(playlistParam[i].id);
                        print(playlistParam[i].name);
                        print(playlistParam[i].image);
                        print(playlistParam[i].desc);
                        print(playlistParam[i].imageUrl);
                        print(playlistParam[i].songList);
                        print(">>>>>>");
                        print(songParam[i].id);
                        print(songParam[i].title);
                        print(songParam[i].artist);
                        print(songParam[i].image);
                        print(songParam[i].song);
                        print(">>>>>>");
                        context.read<UsersProvider>().tambahLagukePlaylist(
                            playlist: playlistParam[i], song: songParam[i]);
                      }
                    }
                    playlistParam.clear();
                    songParam.clear();
                  },
                  child: Container(
                      margin: EdgeInsets.all(13),
                      width: 173,
                      height: 56,
                      decoration: BoxDecoration(
                        color: color3,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Add Songs",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                ))
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

class searchSongResult extends StatefulWidget {
  final Songs iniListLagu;
  final Playlist iniPlaylist;
  searchSongResult(
      {Key? key, required this.iniListLagu, required this.iniPlaylist})
      : super(key: key);

  bool isChecked = false;
  @override
  State<searchSongResult> createState() => _searchSongResultState();
}

class _searchSongResultState extends State<searchSongResult> {
  bool isAdded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isAdded = !isAdded;
              if (isAdded) {
                playlistParam.add(widget.iniPlaylist);
                songParam.add(widget.iniListLagu);
              } else {
                playlistParam.remove(widget.iniPlaylist);
                songParam.remove(widget.iniListLagu);
              }
            });
          },
          child: Container(
            height: 82,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: Color(0xff004e96),
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: widget.iniListLagu.image != null
                            ? File(widget.iniListLagu.image)
                                    .existsSync() // Check if it's a local file
                                ? Image.file(
                                    File(widget.iniListLagu.image),
                                    width: 56,
                                    height: 56,
                                  )
                                : widget.iniListLagu.image.startsWith(
                                        'assets/') // Check if it's an asset
                                    ? Image.asset(
                                        widget.iniListLagu.image,
                                        width: 56,
                                        height: 56,
                                      )
                                    : Image.network(
                                        widget.iniListLagu.image,
                                        width: 56,
                                        height: 56,
                                      )
                            : SizedBox.shrink(),
                      ),
                      SizedBox(
                        width: 11.81,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.iniListLagu.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            widget.iniListLagu.artist,
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
                Icon(
                  Icons.check_circle_rounded,
                  color: isAdded
                      ? Colors.blue
                      : Color.fromARGB(255, 255, 255, 255),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
