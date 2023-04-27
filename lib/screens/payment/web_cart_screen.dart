import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/screens/payment/cart_screen.dart';

class WebCartPopupButton extends StatefulWidget {
  const WebCartPopupButton({Key? key}) : super(key: key);

  @override
  _WebCartPopupButtonState createState() => _WebCartPopupButtonState();
}

class _WebCartPopupButtonState extends State<WebCartPopupButton> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePopup,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFFBF9F8),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/images/web_icon_cart.svg',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _togglePopup() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double popupWidth = 400;
    double popupHeight = 410;
    double leftPosition = offset.dx;
    double topPosition = offset.dy + size.height;

    if (offset.dx + popupWidth > screenWidth) {
      leftPosition = screenWidth - popupWidth;
    }

    if (offset.dy + size.height + popupHeight > screenHeight) {
      topPosition = offset.dy - popupHeight;
    }

    return OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          left: leftPosition,
          top: topPosition,
          child: Material(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const SizedBox(height: 400, width: 300, child: CartScreen()),
            ),
          ),
        );
      },
    );
  }
}
