import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:network_caching_hive/bloc/dark_bloc/dark_bloc.dart';
import 'package:network_caching_hive/bloc/news_bloc/news_bloc.dart';

import 'left_side.dart';
import 'right_side.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<DataConnectionStatus> listener;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _connectionChecker(context);
  }

  _connectionChecker(BuildContext context) {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          if (_counter == 0) {
            _counter++;
          } else {
            _showFlushBar(
              context,
              'Data connection is available.',
              Colors.greenAccent,
            );
          }
          break;
        case DataConnectionStatus.disconnected:
          if (_counter == 0) {
            _counter++;
          }
          _showFlushBar(
            context,
            'You are disconnected from the internet.',
            Colors.redAccent,
          );
          break;
      }
    });
  }

  _showFlushBar(BuildContext _context, String _message, Color _color) {
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.BOTTOM,
      message: _message,
      isDismissible: true,
      icon: Icon(
        Icons.info,
        color: _color,
      ),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    )..show(_context);
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  Future<bool> _buildAlert(BuildContext context) async {
    final bool _isExit = await showDialog<bool>(
      barrierDismissible: true,
      useSafeArea: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to Exit?'),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context, false);
              }),
        ],
      ),
    );
    return _isExit;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          final bool _isExit = await _buildAlert(context);
          if (_isExit) {
            dispose();
            return true;
          }
          return false;
        },
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
