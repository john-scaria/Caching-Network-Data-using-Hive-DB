import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_caching_hive/bloc/db_bloc/db_bloc.dart';
import 'package:network_caching_hive/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:network_caching_hive/bloc/news_bloc/news_bloc.dart';
import 'package:network_caching_hive/models/models.dart';
import 'package:network_caching_hive/screens/browser.dart';
import 'package:network_caching_hive/utils/utils.dart';

class RightSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
        bottom: 10.0,
        right: 10.0,
        left: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
                child: BlocBuilder<NavigationBloc, NavigationState>(
                  buildWhen: (previous, current) {
                    if (previous is NavigationItemSelectedState &&
                        current is NavigationItemSelectedState) {
                      if (previous.selectedIndex == current.selectedIndex) {
                        return false;
                      }
                    }
                    if (previous is NavigationHomeSelectedState &&
                        current is NavigationHomeSelectedState) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is NavigationItemSelectedState) {
                      return headingTopicArea(state.title, context);
                    }
                    if (state is NavigationHomeSelectedState) {
                      return headingHomeArea(state.title);
                    }
                    if (state is NavigationInitial) {
                      return headingHomeArea(state.title);
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              Expanded(child: NewsBody()),
            ],
          ),
        ),
      ),
    );
  }

  Row headingTopicArea(String _heading, BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _heading,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _buildAlert(context, _heading);
              })
        ],
      );

  _buildAlert(BuildContext context, String _heading) {
    showDialog(
      barrierDismissible: true,
      useSafeArea: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to Delete?'),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                BlocProvider.of<DbBloc>(context)
                    .add(DeleteTopicDbEvent(topic: _heading));
                BlocProvider.of<NavigationBloc>(context)
                    .add(NavigationHomeTappedEvent());
                BlocProvider.of<NewsBloc>(context).add(NewsHomeTappedEvent());
                Navigator.pop(context);
              }),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  Text headingHomeArea(String _heading) => Text(
        _heading,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
      );
}

class NewsBody extends StatefulWidget {
  @override
  _NewsBodyState createState() => _NewsBodyState();
}

class _NewsBodyState extends State<NewsBody> {
  Completer<void> _refreshCompleter;
  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsBloc, NewsState>(
      /*  buildWhen: (previous, current) {
        if (previous is NewsItemLoadedState && current is NewsItemLoadedState) {
          if (previous.topic == current.topic) {
            return false;
          }
        }
        if (previous is NewsHomeLoadedState && current is NewsHomeLoadedState) {
          return false;
        }
        return true;
      }, */
      listener: (context, state) {
        if (state is NewsItemLoadedState || state is NewsHomeLoadedState) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      builder: (context, state) {
        if (state is NewsHomeLoadedState) {
          return RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<NewsBloc>(context).add(
                RefreshHomeEvent(),
              );
              return _refreshCompleter.future;
            },
            child: newsList(state.newsList),
          );
        }
        if (state is NewsItemLoadedState) {
          return RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<NewsBloc>(context).add(
                RefreshItemEvent(topic: state.topic),
              );
              return _refreshCompleter.future;
            },
            child: newsList(state.newsList),
          );
        }
        if (state is NewsItemError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    BlocProvider.of<NewsBloc>(context).add(
                      RefreshItemEvent(topic: state.topic),
                    );
                  },
                )
              ],
            ),
          );
        }
        if (state is NewsHomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    BlocProvider.of<NewsBloc>(context).add(
                      RefreshHomeEvent(),
                    );
                  },
                )
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget newsList(List<News> _displayList) => ListView.builder(
        itemCount: _displayList.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('${_displayList.elementAt(index).title}'),
          subtitle: Text(
              '${TimeFormatter.toUnderStandable(_displayList.elementAt(index).pDate)}'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Browser(
                    link: '${_displayList.elementAt(index).link}',
                    source: '${_displayList.elementAt(index).source}',
                  ),
                ));
          },
        ),
      );
}
