import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiData = useState<List<dynamic>>([]);

    Future<void> fetchApiData() async {
      try {
        final res = await http.get(Uri.parse('http://localhost:8080/todos'));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          apiData.value = data;
        }
      } catch (e) {
        print(e.toString());
      }
    }

    useEffect(() {
      fetchApiData();
      return null;
    }, [apiData]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Demo Home Page"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTodoPage(),
            ),
          );
          if (result == true) {
            fetchApiData();
          }
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: apiData.value.length,
                itemBuilder: (context, index) {
                  final item = apiData.value[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(item['description'].toString()),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final res = await http.delete(
                                Uri.parse(
                                    'http://localhost:8080/todos/${item['id']}'),
                              );
                              if (res.statusCode == 200) {
                                fetchApiData();
                              }
                            },
                            child: Icon(Icons.restore_from_trash_outlined),
                          ),
                          TextButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTodoPage(item: item),
                                ),
                              );
                              if (result == true) {
                                fetchApiData();
                              }
                            },
                            child: Icon(Icons.create_outlined),
                          ),
                          item["status"]
                              ? const Text('Done')
                              : const Text('In Progress')
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTodoPage extends HookWidget {
  final Map<String, dynamic> item;

  const EditTodoPage({Key? key, required this.item}) : super(key: key);

  Future<void> putApiData(BuildContext context, String title,
      String description, bool isDone) async {
    try {
      final res = await http.put(
        Uri.parse('http://localhost:8080/todos/${item['id']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'status': isDone,
        }),
      );
      if (res.statusCode == 200) {
        Navigator.pop(context, true); // 更新後に前の画面に戻る
      } else {
        print('Error: ${res.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: item['title']);
    final descriptionController =
        TextEditingController(text: item['description']);
    final isDone = useState<bool>(item['status']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            CheckboxListTile(
              title: const Text('Is Done'),
              value: isDone.value,
              onChanged: (bool? value) {
                isDone.value = value!;
              },
            ),
            ElevatedButton(
              onPressed: () {
                putApiData(context, titleController.text,
                    descriptionController.text, isDone.value);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateTodoPage extends HookWidget {
  Future<void> createApiData(
      BuildContext context, String title, String description) async {
    try {
      final res = await http.post(
        Uri.parse('http://localhost:8080/todos'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'status': false,
        }),
      );
      if (res.statusCode == 201) {
        Navigator.pop(context, true); // 更新後に前の画面に戻る
      } else {
        print('Error: ${res.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: "");
    final descriptionController = TextEditingController(text: "");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () {
                createApiData(
                    context, titleController.text, descriptionController.text);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
