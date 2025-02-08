import 'package:flutter/material.dart';
import '../../config.dart';
import 'memo_item.dart';
import '../../services/memo_service.dart';

class MemoWidget extends StatefulWidget {

  const MemoWidget({Key? key}) : super(key: key);
  
  @override
  _MemoQueryState createState() => _MemoQueryState();
}

class _MemoQueryState extends State<MemoWidget> with AutomaticKeepAliveClientMixin  {
  final MemoService memoService = MemoService();
  List<dynamic> memos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMemos();
  }

  Future<void> fetchMemos() async {
    try {
      final fetchedMemos = await memoService.fetchMemos();
      setState(() {
        memos = fetchedMemos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching memos: $e');
    }
  }

  void handleMemoTap(BuildContext context, dynamic memo) {
    if (memo['immediateRedirect'] == true) {
      navigateToDestination(context, memo);
    } else {
      Navigator.pushNamed(
        context,
        '/memoDetails',
        arguments: memo,
      );
    }
  }

  void navigateToDestination(BuildContext context, dynamic memo) {
    switch (memo['type']) {
      case 'deal':
        Navigator.pushNamed(context, '/dealDetails', arguments: memo['targetId']);
        break;
      case 'chat':
        Navigator.pushNamed(context, '/chatDetails', arguments: memo['targetId']);
        break;
      case 'external':
        print('Open external link: ${memo['externalLink']}'); // Add URL launch logic
        break;
      case 'blog':
        Navigator.pushNamed(context, '/memoDetails', arguments: memo['_id']);
        break;
      default:
        print('Unknown memo type');
    }
  }

  @override
  Widget build(BuildContext context) {
        return isLoading
        ? const Center(child: CircularProgressIndicator())
        : memos.isEmpty
            ? const Center(child: Text('אין הכרזות'))
            : Padding(
                padding: const EdgeInsets.all(AppTheme.itemPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 212,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: memos.length,
                        itemBuilder: (context, index) {
                          final memo = memos[index];
                          return MemoItem(
                            imageUrl: memo['imagePath'] ?? 'default',
                            name: memo['name'] ?? 'New Memo',
                            description: memo['description'] ?? '',
                            memoId: memo['_id'],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }
  
  @override
  bool get wantKeepAlive => true;
}
