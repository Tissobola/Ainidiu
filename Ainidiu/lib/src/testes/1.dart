import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/post_card.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Drop extends StatefulWidget {
  @override
  _DropState createState() => _DropState();
}

class _DropState extends State<Drop> {
  String atual = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drop"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(onPressed: () {
            showDialog(context: context, child: SearchableDropdown.single(
              items: [
              DropdownMenuItem(
                child: Text('data1'),
                onTap: () {
                  print('object');
                },
              ),
              DropdownMenuItem(child: Text('data2')),
              DropdownMenuItem(child: Text('data3')),
              DropdownMenuItem(child: Text('data4')),
              DropdownMenuItem(child: Text('data5')),
              DropdownMenuItem(child: Text('data6'))
            ], onChanged: () {}));
          }),
          DropdownButton(
            hint: Text(
              'Hint'
            ),
            onChanged: (value) {
              print(value);
              setState(() {
                //atual = value;
              });
            },
            items: [
              DropdownMenuItem(
                child: Text('data1'),
                onTap: () {
                  print('object');
                },
              ),
              DropdownMenuItem(child: Text('data2')),
              DropdownMenuItem(child: Text('data3')),
              DropdownMenuItem(child: Text('data4')),
              DropdownMenuItem(child: Text('data5')),
              DropdownMenuItem(child: Text('data6'))
            ],
          ),
          Text(atual)
        ],
      ),
    );
  }
}

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
                User('', 'imageURL', 'apelido', 'email', 'genero', 1, 'senha', 'ad',
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
