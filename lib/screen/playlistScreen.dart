import 'package:flutter/material.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../constants/colors.dart';
import '../screen/detailedPlaylist.dart';
import '../screen/makePlaylist.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../provider/classPlaylist.dart';

class playlistScreen extends StatefulWidget {
  const playlistScreen({super.key});

  @override
  State<playlistScreen> createState() => _playlistScreenState();
}

class _playlistScreenState extends State<playlistScreen> {
  @override
  Widget build(BuildContext context) {
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
                "Your playlist",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 34,
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 24),
              child: Column(
                children: [
                  searchBox(),
                  SizedBox(
                    height: 26,
                  ),
                  Expanded(
                    child: context.watch<UsersProvider>().playListArr.isEmpty
                        ? Center(
                            child: Text(
                              "Playlist is empty, please make one",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: context
                                .watch<UsersProvider>()
                                .playListArr
                                .length,
                            itemBuilder: (context, index) {
                              if (index <
                                  context
                                      .watch<UsersProvider>()
                                      .playListArr
                                      .length) {
                                return _buildPlaylistScreen(
                                  initialPlaylist: context
                                      .watch<UsersProvider>()
                                      .playListArr[index],
                                  listPlaylist: context.watch<UsersProvider>(),
                                  currIdx: index,
                                );
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: color3, // Set your desired background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius to control the button's shape
                ),
                elevation: 0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => makePlaylist(),
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
        ));
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      decoration:
          BoxDecoration(color: color3, borderRadius: BorderRadius.circular(20)),
      child: const TextField(
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
      ),
    );
  }
}

class _buildPlaylistScreen extends StatefulWidget {
  final Playlist initialPlaylist;
  final UsersProvider listPlaylist;
  final int currIdx;

  const _buildPlaylistScreen({
    Key? key,
    required this.initialPlaylist,
    required this.listPlaylist,
    required this.currIdx,
  }) : super(key: key);

  @override
  State<_buildPlaylistScreen> createState() => _BuildPlaylistScreenState();
}

class _BuildPlaylistScreenState extends State<_buildPlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return detailedPlaylist(
                iniPlaylist:
                    context.watch<UsersProvider>().playListArr[widget.currIdx],
                currIdx: widget.currIdx,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 68,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // Wrap the Row with Expanded
              child: Container(
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: widget.initialPlaylist.image != null
                          ? File(widget.initialPlaylist.image)
                                  .existsSync() // Check if it's a local file
                              ? Image.file(
                                  File(widget.initialPlaylist.image),
                                  width: 100,
                                  height: 100,
                                )
                              : Image.network(
                                  widget.initialPlaylist.image,
                                  width: 100,
                                  height: 100,
                                )
                          : SizedBox
                              .shrink(), // An empty container, you can use other widgets like Container() if needed
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.initialPlaylist.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.initialPlaylist.desc,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        context.read<UsersProvider>().deletePlaylist(
                              playlist: widget.initialPlaylist,
                            );
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
                              "Delete Playlist",
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
    );
  }
}
