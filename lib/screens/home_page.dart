import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_caching_hive/bloc/dark_bloc/dark_bloc.dart';
import 'package:network_caching_hive/bloc/news_bloc/news_bloc.dart';

import 'left_side.dart';
import 'right_side.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: null,
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Center(
                  child: Text('TimeLine News !!'),
                ),
              ),
              Expanded(
                child: _settingsList(context, _size),
              ),
            ],
          ),
        ),
        body: CacheCheck(),
      ),
    );
  }

  Widget _settingsList(BuildContext context, Size _size) => ListView(
        children: [
          BlocBuilder<DarkBloc, DarkState>(
            builder: (context, state) {
              return SwitchListTile(
                title: Text('Dark Mode'),
                value: state.isDark,
                onChanged: (value) {
                  BlocProvider.of<DarkBloc>(context)
                      .add(DarkToggleEvent(isDark: value));
                },
              );
            },
          ),
        ],
      );
}

class CacheCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsInitial) {
          return FutureBuilder(
            future: state.removed,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return snapshot.data
                      ? MyBody()
                      : Center(
                          child: Text('Unable to Load!!'),
                        );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return MyBody();
      },
    );
  }
}

class MyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LeftSide(),
          Expanded(
            child: RightSide(),
          ),
        ],
      ),
    );
  }
}
