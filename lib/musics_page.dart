import 'package:flutter/material.dart';

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Musics'),
      ),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/after.jpg'),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Music Name',
                            style: TextStyle(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Singer\'s Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('05:12'),
                    // IconButton(icon: Icon(Icons.play_arrow, col), onPressed: () {}),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
