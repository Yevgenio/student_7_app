import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_7_app/services/memo_service.dart';
import 'package:student_7_app/services/image_service.dart';
import 'package:student_7_app/routes/routes.dart';

class HomeMemoSwiper extends StatefulWidget {
  const HomeMemoSwiper({Key? key}) : super(key: key);

  @override
  _HomeMemoSwiperState createState() => _HomeMemoSwiperState();
}

class _HomeMemoSwiperState extends State<HomeMemoSwiper> {
  final MemoService memoService = MemoService();
  List<dynamic> memos = [];
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchMemos();
    startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

 void startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted && memos.isNotEmpty) {
        setState(() {
          currentIndex = (currentIndex + 1) % memos.length;
        });
      }
    });
  }

  Future<void> fetchMemos() async {
    try {
      List<dynamic> fetchedMemos = await memoService.fetchMemos();
      if (mounted) {
        setState(() {
          memos = fetchedMemos;
        });
      }
    } catch (e) {
      print('Error fetching memos: $e');
    }
  }

  void handleMemoTap(BuildContext context, dynamic memo) {
    if (memo['immediateRedirect'] == true) {
      navigateToDestination(context, memo);
    } else {
      Navigator.pushNamed(
        context,
        '/memoLanding',
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
        Navigator.pushNamed(context, '/memoLanding', arguments: memo);
        break;
      default:
        print('Unknown memo type');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (memos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final memo = memos[currentIndex];

    return GestureDetector(
      onTap: () => handleMemoTap(context, memo),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<String>(
                future: ImageService.getProcessedImageUrl(memo['imagePath']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Image.network(snapshot.data!, height: 100, fit: BoxFit.cover);
                },
              ),
              const SizedBox(height: 8),
              Text(
                memo['name'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                memo['description'],
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}