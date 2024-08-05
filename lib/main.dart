import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_task_2/Post.dart';
import 'package:http/http.dart' as http;

Future <List<Post>> fetch_Data() async{
  final response =await http.get(Uri.parse( 'https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    // If the server did return a 200 it is correct,
    // it will parse the JSON.
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Post.fromJson(json)).toList();// to convert it to list of object
   
  } else {
    // erorr
    
    throw Exception('Failed to load data');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task 2',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
 late Future <List<Post>> Future_Post; // late mean it is not creating the var immidiatly

 void initState() {//The initState() method is called exactly once and then never again
    super.initState();
    Future_Post = fetch_Data();// this to call the future fun and store the data in this var
  } 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<Post>>(
            future: Future_Post,// the var we store the fetched data
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,// the items num
                  itemBuilder: (context, index){
                    Post post = snapshot.data![index];// store each object
                    return ListTile(
                  title: Text(post.title), // we can simply call the data from post class because we have objects list not JSON
                  subtitle: Text(post.body),
                );
              },
            );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
    );
  }
}