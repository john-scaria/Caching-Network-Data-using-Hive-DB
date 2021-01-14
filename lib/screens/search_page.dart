import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:network_caching_hive/bloc/news_bloc/news_bloc.dart';
import 'package:network_caching_hive/models/models.dart';
import 'package:network_caching_hive/screens/browser.dart';
import 'package:network_caching_hive/utils/utils.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                hintText: 'Enter Text', icon: Icon(Icons.search)),
          ),
          actions: [
            RaisedButton(
                color: Colors.orange,
                child: Text('Search'),
                onPressed: () {
                  FocusManager.instance.primaryFocus.unfocus();
                  String _searchText =
                      _searchController.text?.trim()?.toUpperCase();
                  if (_searchText.isNotEmpty && _searchText != null) {
                    if (_searchText.length > 20) {
                      Toast.show(
                        "Topic length too long!!",
                        context,
                        duration: Toast.LENGTH_SHORT,
                        gravity: Toast.BOTTOM,
                      );
                      return;
                    } else {
                      BlocProvider.of<NewsBloc>(context)
                          .add(SearchEvent(topic: _searchText));
                    }
                  }
                })
          ],
        ),
        body: Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsSearchOptionLoadedState) {
                  return searchItem(state.topic, state.newsList);
                }
                if (state is NewsSearchErrorState) {
                  return searchError(state.topic);
                }
                if (state is NewsLoading) {
                  return searchLoading();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget searchItem(String _topic, List<News> _newsList) => Container(
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Text(_topic),
          subtitle: Text('Available'),
          trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pop(context, _topic);
              }),
          onTap: () => openBottomSheet(context, _newsList, _topic),
        ),
      );

  Widget searchError(String _topic) => Container(
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Text(_topic),
          subtitle: Text('Unavailable !!'),
        ),
      );

  Widget searchLoading() => Container(
      height: 100.0,
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: CircularProgressIndicator(),
      ));

  void openBottomSheet(
      BuildContext context, List<News> newsList, String _topic) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.blueGrey,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text('$_topic'),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: bottomList(newsList)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomList(List<News> _newsList) => ListView.builder(
        itemCount: _newsList.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('${_newsList.elementAt(index).title}'),
          subtitle: Text(
              '${TimeFormatter.toUnderStandable(_newsList.elementAt(index).pDate)}'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Browser(
                    link: '${_newsList.elementAt(index).link}',
                    source: '${_newsList.elementAt(index).source}',
                  ),
                ));
          },
        ),
      );
}
