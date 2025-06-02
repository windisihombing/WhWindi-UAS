import 'package:flutter/material.dart';
import 'package:whazlansaja/model/dosen.dart';
import 'package:whazlansaja/data_saya.dart';

class PesanScreen extends StatefulWidget {
  final Dosen dosen;

  const PesanScreen({super.key, required this.dosen});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<ChatDetail> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.dosen.details);
  }

  void _kirimPesan() {
    final teks = _controller.text.trim();
    if (teks.isNotEmpty) {
      setState(() {
        _messages.add(ChatDetail(role: 'saya', message: teks));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: AssetImage(widget.dosen.img),
            radius: 16,
          ),
          title: Text(
            widget.dosen.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text('Online'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final chat = _messages[index];
                final isDosen = chat.role == 'dosen';

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisAlignment: isDosen
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (isDosen)
                        CircleAvatar(
                          backgroundImage: AssetImage(widget.dosen.img),
                          radius: 14,
                        ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDosen
                                ? colorScheme.tertiary
                                : colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(isDosen ? 0 : 12),
                              bottomRight: Radius.circular(isDosen ? 12 : 0),
                            ),
                          ),
                          child: Text(
                            chat.message,
                            style: TextStyle(
                              color: isDosen
                                  ? colorScheme.onTertiary
                                  : colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      if (!isDosen)
                        CircleAvatar(
                          backgroundImage: AssetImage(DataSaya.gambar),
                          radius: 14,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.emoji_emotions),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Ketikkan pesan...',
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _kirimPesan,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
