import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as wf;
import 'package:webview_windows/webview_windows.dart' as ww;

/// Enum hasil pembayaran
enum MidtransPaymentResult { success, pending, failed, cancelled }

class MidtransSnapScreen extends StatefulWidget {
  final String snapUrl;
  final String? orderId;

  const MidtransSnapScreen({
    super.key,
    required this.snapUrl,
    this.orderId,
  });

  @override
  State<MidtransSnapScreen> createState() => _MidtransSnapScreenState();
}

class _MidtransSnapScreenState extends State<MidtransSnapScreen> {
  // Mobile (Android/iOS)
  late final wf.WebViewController _mobileController;
  
  // Desktop (Windows)
  final ww.WebviewController _windowsController = ww.WebviewController();
  
  bool _isLoading = true;
  bool _hasResult = false;
  bool _isWindowsInit = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      _initWindowsWebview();
    } else {
      _initMobileWebview();
    }
  }

  void _initMobileWebview() {
    _mobileController = wf.WebViewController()
      ..setJavaScriptMode(wf.JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        wf.NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
            _checkUrl(url);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
            _checkUrl(url);
          },
          onNavigationRequest: (req) {
            final handled = _checkUrl(req.url);
            return handled ? wf.NavigationDecision.prevent : wf.NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.snapUrl));
  }

  Future<void> _initWindowsWebview() async {
    try {
      await _windowsController.initialize();
      _windowsController.url.listen((url) {
        _checkUrl(url);
      });
      _windowsController.loadingState.listen((state) {
        if (state == ww.LoadingState.loading) {
          if (mounted) setState(() => _isLoading = true);
        } else {
          if (mounted) setState(() => _isLoading = false);
        }
      });
      await _windowsController.loadUrl(widget.snapUrl);
      if (!mounted) return;
      setState(() {
        _isWindowsInit = true;
      });
    } catch (e) {
      debugPrint('Windows Webview error: $e');
    }
  }

  bool _checkUrl(String url) {
    if (_hasResult) return true;
    final lower = url.toLowerCase();

    if (lower.startsWith('bengkelin://payment/finish')) {
      _handleResult(MidtransPaymentResult.success);
      return true;
    }
    if (lower.startsWith('bengkelin://payment/pending')) {
      _handleResult(MidtransPaymentResult.pending);
      return true;
    }
    if (lower.startsWith('bengkelin://payment/error')) {
      _handleResult(MidtransPaymentResult.failed);
      return true;
    }
    return false;
  }

  void _handleResult(MidtransPaymentResult result) {
    if (_hasResult || !mounted) return;
    _hasResult = true;
    
    // Windows webview perlu didispose dengan benar agar tidak bocor memory
    if (Platform.isWindows && _isWindowsInit) {
      _windowsController.dispose();
    }
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    if (Platform.isWindows && !_hasResult && _isWindowsInit) {
      _windowsController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_hasResult) {
          _handleResult(MidtransPaymentResult.cancelled);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'Pembayaran',
            style: TextStyle(
              color: Color(0xFF1B3A5E),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF1B3A5E)),
            onPressed: () => _handleResult(MidtransPaymentResult.cancelled),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF1B3A5E)),
              onPressed: () {
                if (Platform.isWindows && _isWindowsInit) {
                  _windowsController.reload();
                } else if (!Platform.isWindows) {
                  _mobileController.reload();
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            if (Platform.isWindows)
              _isWindowsInit
                  ? ww.Webview(_windowsController)
                  : const SizedBox()
            else
              wf.WebViewWidget(controller: _mobileController),
              
            if (_isLoading)
              Container(
                color: Colors.white,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B3A5E)),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Memuat halaman pembayaran...',
                        style: TextStyle(
                          color: Color(0xFF1B3A5E),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
