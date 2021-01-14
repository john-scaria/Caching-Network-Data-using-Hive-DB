import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_caching_hive/bloc/db_bloc/db_bloc.dart';
import 'package:network_caching_hive/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:network_caching_hive/bloc/news_bloc/news_bloc.dart';
import 'package:network_caching_hive/bloc/search_bloc/search_bloc.dart';

import 'search_page.dart';

class LeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            homeButton(context),
            Expanded(child: BlocBuilder<DbBloc, DbState>(
              builder: (context, state) {
                if (state is DbInitial) {
                  return topicList(state.topicList);
                }
                if (state is DbLoadedState) {
                  return topicList(state.topicList);
                }
                if (state is DbInsertErrorState) {
                  return topicList(state.topicList);
                }
                if (state is DbDeleteErrorState) {
                  return topicList(state.topicList);
                }
                return Center(child: CircularProgressIndicator());
              },
            )),
            addButton(context),
          ],
        ),
      ),
    );
  }

  Widget homeButton(BuildContext context) => Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationHomeTappedEvent());
              BlocProvider.of<NewsBloc>(context).add(NewsHomeTappedEvent());
            },
          ),
        ),
      );

  Widget addButton(BuildContext context) => Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              String _searchData = (await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      )))
                  ?.trim();
              if ((_searchData == null || _searchData.isEmpty)) {
                BlocProvider.of<NavigationBloc>(context)
                    .add(NavigationHomeTappedEvent());
                BlocProvider.of<NewsBloc>(context).add(NewsHomeTappedEvent());
                BlocProvider.of<SearchBloc>(context).add(SearchResetEvent());
              } else {
                BlocProvider.of<DbBloc>(context)
                    .add(AddTopicDbEvent(topic: _searchData));
                BlocProvider.of<NavigationBloc>(context)
                    .add(NavigationHomeTappedEvent());
                BlocProvider.of<NewsBloc>(context).add(NewsHomeTappedEvent());
                BlocProvider.of<SearchBloc>(context).add(SearchResetEvent());
              }
            },
          ),
        ),
      );

  Widget topicList(List<String> _displayList) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _displayList.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              BlocProvider.of<NavigationBloc>(context).add(
                NavigationItemTappedEvent(
                    title: _displayList.elementAt(index), selectedIndex: index),
              );
              BlocProvider.of<NewsBloc>(context).add(
                NewsItemTappedEvent(
                  topic: _displayList.elementAt(index),
                ),
              );
            },
            child: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                if (state is NavigationItemSelectedState) {
                  if (state.selectedIndex == index) {
                    return listItem(_displayList.elementAt(index), true);
                  }
                }
                return listItem(_displayList.elementAt(index), false);
              },
            ),
          ),
        ),
      );

  Widget listItem(String _elementData, bool _isSelected) => Container(
        decoration: BoxDecoration(
          color: _isSelected ? Colors.lightGreen : Colors.blueAccent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(_elementData),
            ),
          ),
        ),
      );
}
