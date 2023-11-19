import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../constants/colors.dart';
import '../provider/classSong.dart';
import '../screen/musicplayer.dart';
import '../provider/classPlaylist.dart';

List<Songs> filteredSongs = songArr;

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
                size: 34,
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

              // Conditionally execute different actions based on isAdded
              if (isAdded) {
                // If isAdded is true, add the song to the playlist
                context.read<UsersProvider>().tambahLagukePlaylist(
                    playlist: widget.iniPlaylist, song: widget.iniListLagu);
              } else {
                // If isAdded is false, remove the song from the playlist
                context.read<UsersProvider>().hapusLagukePlaylist(
                    playlist: widget.iniPlaylist, song: widget.iniListLagu);
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
                      ClipRRect(
                        child: Image.asset(
                          widget.iniListLagu.image,
                          height: 60,
                          width: 60,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
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
