import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:whazlansaja/data_saya.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';
import '../model/dosen.dart';


class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  late Future<List<Dosen>> _dosenFuture;

  @override
  void initState() {
    super.initState();
    _dosenFuture = loadDosen();
  }

  Future<List<Dosen>> loadDosen() async {
    final String jsonString =
        await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => Dosen.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title:  Text(
          DataSaya.nama,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(
                    child: Text(
                      'Belum ada pencarian',
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Dosen>>(
        future: _dosenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dosens = snapshot.data!;
            return ListView.builder(
              itemCount: dosens.length,
              itemBuilder: (context, index) {
                final dosen = dosens[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PesanScreen(dosen: dosen),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(dosen.img),
                  ),
                  title: Text(dosen.name),
                  subtitle: Text(
                    dosen.details.isNotEmpty
                        ? dosen.details.last.message
                        : 'Belum ada chat',
                  ),
                  trailing: const Text('Baru'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync),
            label: 'Pembaruan',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Komunitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.call),
            label: 'Panggilan',
          ),
        ],
      ),
    );
  }
}
