import 'package:flutter/material.dart';


class MessageComponent extends StatelessWidget {

  final Map<String, dynamic> data;

  MessageComponent(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundImage: NetworkImage(this.data['fromPhotoUrl']),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.data['from'], style: Theme.of(context).textTheme.subhead,),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: this.data['imgUrl'] == null ? Text(this.data['text']) : Image.network(this.data['imgUrl'], width: 250,),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
