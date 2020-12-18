import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/post_card.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';


class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  AndroidAlarmManager alarmManager = new AndroidAlarmManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Alarme'),
          onPressed: () {
            AndroidAlarmManager.periodic(Duration(seconds: 4), 0, () {
              print('ok');
            });
          },
        ),
      ),
    );
  }
}

class TestPagination extends StatefulWidget {
  @override
  _TestPaginationState createState() => _TestPaginationState();
}

class _TestPaginationState extends State<TestPagination> {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  void initState() {
    //  refreshChangeListener.addListener(() {});
    super.initState();
  }

  Future<void> refresh() async {
    print('reload');
    setState(() {
      refreshChangeListener.refreshed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Pagination'),
      ),
      body: RefreshIndicator(
        child: PaginateFirestore(
          itemsPerPage: 10,
          itemBuilder: (index, context, documentSnapshot) {
            var item = documentSnapshot.data();
            return PostCard(
                context,
                ItemData(0, 1, 'postadoPorNome', item['imagemURL'],
                    item['texto'], 'data', 1, []),
                User('', 'imageURL', 'apelido', 'email', 'genero', 1, 'senha',
                    'cidade', 'nascimento'));
          },
          query: FirebaseFirestore.instance
              .collection('postagens')
              .orderBy('id', descending: true),
          listeners: [
            refreshChangeListener,
          ],
          itemBuilderType: PaginateBuilderType.listView,
        ),
        onRefresh: refresh,
      ),
    );
  }
}
