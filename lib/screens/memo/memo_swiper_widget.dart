import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:student_7_app/services/memo_service.dart';
import 'package:student_7_app/widgets/cached_image.dart';

class MemoSwiperWidget extends StatefulWidget {
  const MemoSwiperWidget({Key? key}) : super(key: key);

  @override
  _MemoSwiperWidgetState createState() => _MemoSwiperWidgetState();
}

class _MemoSwiperWidgetState extends State<MemoSwiperWidget> {
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
        arguments: memo['_id'],
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
            : SizedBox(
                height: 300,
                child: Swiper(
                  itemCount: memos.length,
                  autoplay: true,
                  autoplayDelay: 8000,
                  pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeColor: Colors.white,
                      size: 8.0,
                      activeSize: 10.0,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final memo = memos[index];
                    return GestureDetector(
                      onTap: () => handleMemoTap(context, memo),
                        child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background Image
                          CachedImage(
                          imagePath: memo['imagePath'] ?? 'default',
                          fit: BoxFit.cover,
                          ),
                          // Gradient Overlay
                          Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                            ],
                            ),
                          ),
                          ),
                          // Memo Text (Title + Description)
                          Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                              memo['name'] ?? 'הכרזה',
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              memo['description'] ?? '',
                              style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            ],
                          ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
  }
}