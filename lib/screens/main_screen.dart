import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/member_webview.dart';
import '../utils/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 底部導航對應的 URL
  final List<_NavItem> _navItems = [
    _NavItem(
      label: '首頁',
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
      url: AppConstants.memberHomeUrl,
    ),
    _NavItem(
      label: '商品',
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
      url: AppConstants.shopProductUrl,
    ),
    _NavItem(
      label: '出席',
      icon: Icons.qr_code_scanner_rounded,
      activeIcon: Icons.qr_code_scanner_rounded,
      url: AppConstants.attendUrl,
      isSpecial: true,
    ),
    _NavItem(
      label: '義工',
      icon: Icons.volunteer_activism_outlined,
      activeIcon: Icons.volunteer_activism_rounded,
      url: AppConstants.volunteerUrl,
    ),
    _NavItem(
      label: '個人',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      url: AppConstants.accountUrl,
    ),
  ];

  // 每個 tab 的 WebView key，用於保持狀態
  final List<GlobalKey<MemberWebViewState>> _webViewKeys = List.generate(
    5,
    (_) => GlobalKey<MemberWebViewState>(),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(_navItems.length, (index) {
            return MemberWebView(
              key: _webViewKeys[index],
              initialUrl: _navItems[index].url,
              onNavigationRequest: _handleNavigation,
            );
          }),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = _currentIndex == index;

              if (item.isSpecial) {
                // 中間掃碼按鈕特殊樣式
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.primaryColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTapped(index),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textLight,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.textLight,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      // 點擊當前 tab，刷新頁面
      _webViewKeys[index].currentState?.reload();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  bool _handleNavigation(String url) {
    // 處理特殊 URL 導航
    // 返回 true 表示允許導航，false 表示攔截
    return true;
  }

  Future<bool> _onWillPop() async {
    // 嘗試讓當前 WebView 返回上一頁
    final canGoBack =
        await _webViewKeys[_currentIndex].currentState?.goBack() ?? false;
    if (canGoBack) return false;

    // 如果不在首頁 tab，切換到首頁
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }

    // 顯示退出確認對話框
    return await _showExitDialog();
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              '退出應用',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text('確定要退出 DEEPSEE 睇下仙嗎？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  '取消',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('退出'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String url;
  final bool isSpecial;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.url,
    this.isSpecial = false,
  });
}
