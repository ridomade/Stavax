import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/firebaseFetch/artistSongFetch.dart';
import 'package:stavax_new/firebaseFetch/insidePlaylistFetch.dart';
import 'package:stavax_new/firebaseFetch/playlistFetch.dart';
import 'package:stavax_new/firebaseFetch/songFetch.dart';
import '../constants/colors.dart';
import '../screen/addtoplaylist.dart';
import '../screen/musicplayer.dart';
import '../provider/classPlaylist.dart';
import '../provider/classSong.dart';
import '../provider/classUser.dart';

late UsersProvider usersProvider;

class detailedPlaylist extends StatefulWidget {
  final Playlist iniPlaylist;
  final int currIdx;
  const detailedPlaylist(
      {Key? key, required this.iniPlaylist, required this.currIdx})
      : super(key: key);

  @override
  State<detailedPlaylist> createState() => _detailedPlaylistState();
}

class _detailedPlaylistState extends State<detailedPlaylist> {
  @override
  void initState() {
    if (widget.iniPlaylist.songList.isEmpty) {
      _initializeSongs();
    }
    super.initState();
  }

  void _initializeSongs() async {
    try {
      await context.read<UsersProvider>().tambahLagukePlaylistDariFetch(
          datas: await insidePlaylistFetch(), playlist: widget.iniPlaylist);
    } catch (e) {
      print("Error fetching songs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
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
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: widget.iniPlaylist.image != null
                      ? File(widget.iniPlaylist.image)
                              .existsSync() // Check if it's a local file
                          ? Image.file(
                              File(widget.iniPlaylist.image),
                              width: 100,
                              height: 100,
                            )
                          : Image.network(
                              widget.iniPlaylist.image,
                              width: 100,
                              height: 100,
                            )
                      : SizedBox
                          .shrink(), // An empty container, you can use other widgets like Container() if needed
                ),
                SizedBox(
                  height: 13,
                ),
                Text(
                  widget.iniPlaylist.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  widget.iniPlaylist.desc,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: context
                        .watch<UsersProvider>()
                        .playListArr[widget.currIdx]
                        .songList
                        .length,
                    itemBuilder: ((context, index) {
                      if (index <=
                          context
                              .watch<UsersProvider>()
                              .playListArr[widget.currIdx]
                              .songList
                              .length) {
                        return listPlaylistSong(
                          iniplaylistSong: context
                              .watch<UsersProvider>()
                              .playListArr[widget.currIdx],
                          CurrIdx: index,
                          iniUsers: context.watch<UsersProvider>(),
                        );
                      }
                    }),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  margin:
                      EdgeInsets.only(right: 20, bottom: 20), // Add margin here
                  child: FloatingActionButton(
                    backgroundColor: color3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              //tambah lagu
                              addToPlaylist(iniplaylist: widget.iniPlaylist),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add_rounded,
                      size: 50,
                      color: color1,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class listPlaylistSong extends StatelessWidget {
  final Playlist iniplaylistSong;
  final UsersProvider iniUsers;
  final int CurrIdx;
  const listPlaylistSong(
      {Key? key,
      required this.iniplaylistSong,
      required this.iniUsers,
      required this.CurrIdx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AudioPlayerScreen(
                listSong: iniplaylistSong.songList,
                song: iniplaylistSong
                    .songList[CurrIdx], // Use widget.currIdx here
                CurrIdx: CurrIdx,
              );

              // AudioPlayerScreen(
              //     listSong: iniplaylistSong.songList,
              //     song: iniplaylistSong.songList[CurrIdx],
              //     CurrIdx: CurrIdx);
            }));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            height: 82,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Color(0xff004e96),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: iniplaylistSong.songList[CurrIdx].image != null
                            ? File(iniplaylistSong.songList[CurrIdx].image)
                                    .existsSync() // Check if it's a local file
                                ? Image.file(
                                    File(iniplaylistSong
                                        .songList[CurrIdx].image),
                                    width: 56,
                                    height: 56,
                                  )
                                : iniplaylistSong.songList[CurrIdx].image
                                        .startsWith(
                                            'assets/') // Check if it's an asset
                                    ? Image.asset(
                                        iniplaylistSong.songList[CurrIdx].image,
                                        width: 56,
                                        height: 56,
                                      )
                                    : Image.network(
                                        iniplaylistSong.songList[CurrIdx].image,
                                        width: 56,
                                        height: 56,
                                      )
                            : SizedBox.shrink(),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            iniplaylistSong.songList[CurrIdx].title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            iniplaylistSong.songList[CurrIdx].artist,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            context.read<UsersProvider>().hapusLagukePlaylist(
                                playlist: iniplaylistSong,
                                song: iniplaylistSong.songList[CurrIdx]);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 111,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF004E96),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Remove Song",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
