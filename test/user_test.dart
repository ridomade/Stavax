import 'package:flutter_test/flutter_test.dart';
import 'package:stavax_new/provider/classUser.dart';

void main() {
  group('UsersProvider', () {
    test(
        'tambahPlaylistBaru2 adds a new playlist to UsersProvider\'s playListArr',
        () {
      // Arrange
      UsersProvider usersProvider = UsersProvider();
      String playlistId = '1';

      // Act
      usersProvider.tambahPlaylistBaru2(
        id: playlistId,
        namePlaylist: 'New Playlist',
        descPlaylist: 'Playlist Description',
        selectedImage: 'imageData',
        selectedImageFileName: 'imageFileName',
        imageUrll: 'imageUrl',
      );

      // Assert
      expect(usersProvider.playListArr.length, 1);
      expect(usersProvider.playListArr[0].id, playlistId);
      // Add more assertions if needed to check other fields of the added playlist
    });
  });
}
