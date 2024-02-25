### flutter 便利

react hooks みたいなの -> flutter pub add flutter_hooks

```
import 'package:flutter_hooks/flutter_hooks.dart';

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final hooksCounter = useState<int>(0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Demo Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${hooksCounter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            OutlinedButton(
              onPressed: () {
                hooksCounter.value++;
              },
              child: const Text('hooks increment'),
            ),
          ],
        ),
      ),
    );
  }
}

```

api 通信に必要なもの -> flutter pub add http

```
import 'package:http/http.dart' as http;

Future<void> fetchApiData() async {
  try {
    final res = await http.get(Uri.parse('http://localhost:8080'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print(data);
    }
  } catch (e) {
    print(e.toString());
  }
}
```

整形がぐちゃぐちゃになるので prettier 的なのを見つけたい

### go 便利

echo -> ルーティング
gorm -> ORM

比較的さわりはいいが、ポインターなどが難しい。
エラー処理が多くなりがちリーディングで脳の無駄なメモリ消費しがち
