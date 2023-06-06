import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DietTab extends StatefulWidget {
  @override
  _DietTabState createState() => _DietTabState();
}

class _DietTabState extends State<DietTab> {
  final String userId = 'xyz'; // Assume the user ID is 'xyz'
  final String collectionName = 'meals';
  late FirebaseFirestore _firestore;
  late CollectionReference _mealsCollection;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _mealsCollection = _firestore.collection(collectionName);
    _ensureCollectionExists();
  }

  Future<void> _ensureCollectionExists() async {
    final collectionExists =
        await _mealsCollection.doc(userId).get().then((doc) => doc.exists);
    if (!collectionExists) {
      await _mealsCollection.doc(userId).set({});
    }
  }

  Future<void> _updateMealState(String meal, bool isDone) async {
    final today = DateTime.now();
    final documentId = '${today.year}-${today.month}-${today.day}';

    await _mealsCollection
        .doc(userId)
        .collection(collectionName)
        .doc(documentId)
        .set({
      meal: isDone,
    }, SetOptions(merge: true));

    setState(() {}); // Refresh the UI
  }

  Future<bool> _isMealCompleted(String meal) async {
    final today = DateTime.now();
    final documentId = '${today.year}-${today.month}-${today.day}';

    final document = await _mealsCollection
        .doc(userId)
        .collection(collectionName)
        .doc(documentId)
        .get();
    final data = document.data() as Map<String, dynamic>?;

    return data?[meal] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet'),
      ),
      body: Column(
        children: [
          _buildMealCard('Breakfast', 'Healthy breakfast option',
              'assets/images/breakfast.jpg'),
          _buildMealCard(
              'Lunch', 'Nutritious lunch meal', 'assets/images/lunch.jpg'),
          _buildMealCard(
              'Dinner', 'Delicious dinner recipe', 'assets/images/dinner.jpg'),
        ],
      ),
    );
  }

  Widget _buildMealCard(String title, String description, String image) {
    final meal = title;
    return Card(
      child: ListTile(
        leading: Image.asset(
          image,
          width: double.infinity,
          height: 0.7 * MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: FutureBuilder<bool>(
          future: _isMealCompleted(meal),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final isCompleted = snapshot.data ?? false;

            return isCompleted
                ? Icon(Icons.check, color: Colors.green)
                : ElevatedButton(
                    onPressed: () {
                      _updateMealState(meal, true);
                    },
                    child: Text('Done'),
                  );
          },
        ),
      ),
    );
  }
}
