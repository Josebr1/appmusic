import 'package:appmusic/model/media.dart';
import 'package:appmusic/utils/api_response.dart';
import 'package:appmusic/view/widgets/player_list_widget.dart';
import 'package:appmusic/view_model/media_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {
    List<Media>? mediaList = apiResponse.data as List<Media>?;

    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator(),);
      case Status.COMPLETED:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 8,
                child: PlayerListWidget(mediaList!, (Media media) {
                  // Click
                }))
          ],
        );
      case Status.ERROR:
        return Center(child: Text('Por favor tente novamente'),);
      case Status.INITIAL:
      default:
        return Center(child: Text('Pesquise a música por artista.'),);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _inputController = TextEditingController();

    ApiResponse apiResponse = Provider
        .of<MediaViewModel>(context)
        .response;

    return Scaffold(
      appBar: AppBar(
        title: Text("Media Player"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withAlpha(50),
                borderRadius: BorderRadius.circular(30.0)
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
                controller: _inputController,
                onChanged: (value) {

                },
                onSubmitted: (value) {
                  if(value.isNotEmpty) {
                    // Provider.of<MediaViewModel>(context, listen: false);
                    Provider.of<MediaViewModel>(context, listen: false)
                        .fetchMediaData(value);
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: "Coloque o nome do artista"
                ),
              ),
            ),
          ),
          Expanded(child: getMediaWidget(context, apiResponse))
        ],
      ),
    );
  }
}