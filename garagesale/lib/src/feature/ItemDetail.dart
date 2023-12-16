import 'package:flutter/material.dart';

/// Item detail page.
class ItemDetail extends StatelessWidget {
  static String id = 'item_detail_page';

  const ItemDetail({
    Key? key,
    required this.user,
    required this.price,
    required this.title,
    required this.description,
    required this.p0,
    required this.p1,
    required this.p2,
    required this.p3,
  }) : super(key: key);

  final String user;
  final String title;
  final String price;
  final String description;
  final String p0;
  final String p1;
  final String p2;
  final String p3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Item Detail'),
        backgroundColor: Colors.indigo,
        elevation: 0, // Remove the appbar shadow
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: p0 == ' ' ? 0 : 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  if (p0 != ' ') Thumbnail(tag: 'picture0', imagePath: p0),
                  const SizedBox(width: 5.0),
                  if (p1 != ' ') Thumbnail(tag: 'picture1', imagePath: p1),
                  const SizedBox(width: 5.0),
                  if (p2 != ' ') Thumbnail(tag: 'picture2', imagePath: p2),
                  const SizedBox(width: 5.0),
                  if (p3 != ' ') Thumbnail(tag: 'picture3', imagePath: p3),
                ],
              ),
            ),
            const SizedBox(height: 30),
            buildDetailRow('Item', title),
            buildDetailRow('Price', '\$$price'),
            buildDetailRow('Description', description),
            buildDetailRow('Seller', user.split("@")[0]),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$label:',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Thumbnail extends StatelessWidget {
  final String tag;
  final String imagePath;

  const Thumbnail({Key? key, required this.tag, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Scaffold(
                body: Center(
                  child: Hero(
                    tag: tag,
                    child: Image.network(imagePath),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        child: Hero(
          tag: tag,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
