import 'package:flutter/material.dart';
import 'constants.dart';
import 'message_provider.dart';
import 'info_screen.dart';
import 'diary_screen.dart';
import 'storage_service.dart';
import 'view_diary_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _message = '목록';
  List<Map<String, String>> _diaries = [];
  final StorageService _storageService = StorageService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    final diaries = await _storageService.loadDiaries();
    setState(() {
      _diaries = diaries.toList(); // 최신 글이 위로 오도록 역순으로 정렬
    });
  }

  Future<void> _deleteDiary(int index) async {
    final diaries = await _storageService.loadDiaries();
    diaries.removeAt(index);
    await _storageService.saveDiaries(diaries);
    _loadDiaries();
  }

  void _updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  void _navigateToInfoScreen() {
    setState(() {
      _message = '정보';
    });
  }

  void _navigateToDiaryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DiaryScreen(onSave: () {
                _loadDiaries();
                _updateMessage('목록');
              })),
    );
  }

  void _navigateToViewDiaryScreen(String dateTime, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ViewDiaryScreen(dateTime: dateTime, content: content)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_message),
        backgroundColor: Colors.green,
      ),
      body: _message == '정보' ? InfoScreen() : _buildDiaryList(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: '일기쓰기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: '정보',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            _navigateToInfoScreen();
          } else if (index == 1) {
            _navigateToDiaryScreen();
          } else {
            _updateMessage(MessageProvider.getMessage(index));
          }
        },
      ),
    );
  }

  Widget _buildDiaryList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _diaries.length,
      itemBuilder: (context, index) {
        final diary = _diaries[index];
        final dateTime = diary['dateTime']!;
        final content = diary['content']!;
        final displayContent = content.split('\n').take(3).join('\n');
        final isTruncated = content.split('\n').length > 3 ||
            content.length > displayContent.length;

        return Dismissible(
          key: Key(diary['dateTime']!),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _deleteDiary(index);
          },
          child: Container(
            width: double.infinity,
            child: GestureDetector(
              onTap: () => _navigateToViewDiaryScreen(dateTime, content),
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDateTime(dateTime),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        isTruncated ? '$displayContent......' : displayContent,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}
