import 'package:cool_wallpaper/model/stock_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List list;

  getData() {
    return StockPhoto.getPhoto().then((value) {
      list = new List();
      for (int i = 0; i < value.length; i++) {
        list.add(value[i].desc);
        // print(value[i].desc);
      }
      return list;
    });
  }

  @override
  void initState() {
    super.initState();

    list = new List();
  }

  @override
  Widget build(BuildContext context) {
    // print(getData());
    print(list.length);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add, size: 30,), onPressed: () {}),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? gridView()
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  Widget gridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) => new Container(
        decoration: BoxDecoration(
            color: Colors.indigo[100], borderRadius: BorderRadius.circular(8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: new Image.network(
            list[index],
            scale: 1,
            filterQuality: FilterQuality.high,
            // repeat: ImageRepeat.noRepeat,
            cacheHeight: 1000,
            // cacheWidth: 00,
            fit: BoxFit.fitHeight,
            // height: 400,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
            errorBuilder: (context, url, error) => Center(child: Text('Error connection')),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 5 : 4),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
