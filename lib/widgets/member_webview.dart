import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'no_network_widget.dart';

class MemberWebView extends StatefulWidget {
  final String initialUrl;
  final bool Function(String url)? onNavigationRequest;

  const MemberWebView({
    super.key,
    required this.initialUrl,
    this.onNavigationRequest,
  });

  @override
  State<MemberWebView> createState() => MemberWebViewState();
}

class MemberWebViewState extends State<MemberWebView>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  int _loadingProgress = 0;
  String _currentUrl = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
                if (progress >= 100) {
                  _isLoading = false;
                }
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
                _currentUrl = url;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _currentUrl = url;
              });
              // 注入 JS：隱藏網頁原有的底部導航（App 有自己的底部導航）
              _injectHideFooterJs();
            }
          },
          onWebResourceError: (WebResourceError error) {
            // 只處理主框架錯誤
            if (error.isForMainFrame ?? false) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              }
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            // 允許在 wehood.org 域名內導航
            if (url.contains('wehood.org') ||
                url.contains('localhost') ||
                url.startsWith('about:')) {
              return NavigationDecision.navigate;
            }

            // 外部鏈接：允許（可根據需要改為用瀏覽器打開）
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterApp',
        onMessageReceived: (JavaScriptMessage message) {
          _handleJsMessage(message.message);
        },
      )
      ..setUserAgent(AppConstants.userAgent)
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  /// 注入 JS 隱藏網頁底部導航欄（App 有自己的底部導航）
  void _injectHideFooterJs() {
    _controller.runJavaScript('''
      (function() {
        // 隱藏網頁原有的底部固定導航
        var footerFixed = document.querySelector('.footer-fixed-container');
        if (footerFixed) {
          footerFixed.style.display = 'none';
        }
        
        // 為 body 添加 padding-bottom，避免內容被 App 底部導航遮擋
        document.body.style.paddingBottom = '70px';
        
        // 標記為 App 環境
        document.body.setAttribute('data-app-env', 'android');
        
        // 通知網頁這是 App 環境（網頁可以根據此做適配）
        if (typeof window.FlutterApp !== 'undefined') {
          window.isFlutterApp = true;
        }
      })();
    ''');
  }

  void _handleJsMessage(String message) {
    // 處理來自網頁的 JS 消息
    debugPrint('JS Message: $message');
  }

  /// 外部調用：重新加載頁面
  void reload() {
    _controller.reload();
  }

  /// 外部調用：返回上一頁，返回是否成功
  Future<bool> goBack() async {
    final canGoBack = await _controller.canGoBack();
    if (canGoBack) {
      await _controller.goBack();
      return true;
    }
    return false;
  }

  /// 外部調用：加載新 URL
  void loadUrl(String url) {
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_hasError) {
      return NoNetworkWidget(
        onRetry: () {
          setState(() {
            _hasError = false;
            _isLoading = true;
          });
          _controller.loadRequest(Uri.parse(widget.initialUrl));
        },
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),

        // 頂部加載進度條
        if (_isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _loadingProgress / 100,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
              minHeight: 3,
            ),
          ),
      ],
    );
  }
}
