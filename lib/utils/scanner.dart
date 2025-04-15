import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/*
class QRViewTracesci extends StatefulWidget {
  const QRViewTracesci({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewTracesciState();
}

class _QRViewTracesciState extends State<QRViewTracesci> with TickerProviderStateMixin {
  String? result;
  bool flashOn = false;
  MobileScannerController cameraController = MobileScannerController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        centerTitle: true,
        title: const Text(
          'Product Scanner',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF5F5F5)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(
                      'Scan the barcode or QR code by using the device camera for required details.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 250,
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          ClipRect(
                            child: SizedBox(
                              width: 250,
                              height: 180,
                              child: MobileScanner(
                                controller: cameraController,
                                onDetect: (BarcodeCapture barcodeCapture) {
                                  final List<Barcode> barcodes = barcodeCapture.barcodes;
                                  final Size imageSize = Size(
                                    barcodeCapture.size?.width ?? 0,
                                    barcodeCapture.size?.height ?? 0,
                                  );

                                  for (final barcode in barcodes) {
                                    final corners = barcode.corners;

                                    if (corners != null && imageSize.width > 0 && imageSize.height > 0) {
                                      double centerX = 0;
                                      double centerY = 0;

                                      for (final corner in corners) {
                                        centerX += corner.dx;
                                        centerY += corner.dy;
                                      }

                                      centerX /= corners.length;
                                      centerY /= corners.length;

                                      final normalizedX = centerX / imageSize.width;
                                      final normalizedY = centerY / imageSize.height;

                                      const scanAreaLeft = 0.3;
                                      const scanAreaRight = 0.7;
                                      const scanAreaTop = 0.3;
                                      const scanAreaBottom = 0.7;

                                      if (normalizedX >= scanAreaLeft &&
                                          normalizedX <= scanAreaRight &&
                                          normalizedY >= scanAreaTop &&
                                          normalizedY <= scanAreaBottom) {
                                        if (result == null) {
                                          setState(() {
                                            result = barcode.rawValue;
                                          });
                                          _navigateToAddToner();
                                          break;
                                        }
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Positioned(
                                left: 0,
                                right: 0,
                                top: _animation.value * 160,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.transparent, Colors.orange, Colors.transparent],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildCorner(Alignment.topLeft, Colors.orange),
                          _buildCorner(Alignment.topRight, Colors.orange),
                          _buildCorner(Alignment.bottomLeft, Colors.orange),
                          _buildCorner(Alignment.bottomRight, Colors.orange),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (result != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: _buildResultRow('Scanned Code:', result!),
                    ),
                  const SizedBox(height: 20),
                  if (result != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                          text: 'Finish',
                          color: Colors.green,
                          onPressed: _navigateToAddToner,
                        ),
                        const SizedBox(width: 12),
                        _buildButton(
                          text: 'Retry',
                          color: Colors.grey,
                          onPressed: () => setState(() => result = null),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 16),
        child: FloatingActionButton(
          onPressed: () async {
            await cameraController.toggleTorch();
            setState(() => flashOn = !flashOn);
          },
          backgroundColor: Colors.white,
          elevation: 4,
          child: Icon(
            flashOn ? Icons.flash_on : Icons.flash_off,
            color: flashOn ? Colors.amber : Colors.grey.shade700,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, Color color) {
    bool isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    bool isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    return Positioned(
      left: isLeft ? 0 : null,
      right: !isLeft ? 0 : null,
      top: isTop ? 0 : null,
      bottom: !isTop ? 0 : null,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? BorderSide(color: color, width: 3) : BorderSide.none,
            bottom: !isTop ? BorderSide(color: color, width: 3) : BorderSide.none,
            left: isLeft ? BorderSide(color: color, width: 3) : BorderSide.none,
            right: !isLeft ? BorderSide(color: color, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _navigateToAddToner() {
    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
*/



class QRViewTracesci extends StatefulWidget {
  const QRViewTracesci({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewTracesciState();
}

class _QRViewTracesciState extends State<QRViewTracesci> with TickerProviderStateMixin {
  String? result;
  bool flashOn = false;
  MobileScannerController cameraController = MobileScannerController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Set zoom after camera initializes
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        await cameraController.setZoomScale(0.5); // Max zoom for testing
        print('Zoom set to 1.0'); // Debug log
      } catch (e) {
        print('Error setting zoom: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        centerTitle: true,
        title: const Text(
          'Product Scanner',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF5F5F5)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(
                      'Scan the barcode or QR code by using the device camera for required details.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 250,
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          ClipRect(
                            child: SizedBox(
                              width: 250,
                              height: 180,
                              child: MobileScanner(
                                controller: cameraController,
                                onDetect: (BarcodeCapture barcodeCapture) {
                                  final List<Barcode> barcodes = barcodeCapture.barcodes;
                                  final Size imageSize = Size(
                                    barcodeCapture.size?.width ?? 0,
                                    barcodeCapture.size?.height ?? 0,
                                  );

                                  for (final barcode in barcodes) {
                                    final corners = barcode.corners;

                                    if (corners != null && imageSize.width > 0 && imageSize.height > 0) {
                                      double centerX = 0;
                                      double centerY = 0;

                                      for (final corner in corners) {
                                        centerX += corner.dx;
                                        centerY += corner.dy;
                                      }

                                      centerX /= corners.length;
                                      centerY /= corners.length;

                                      final normalizedX = centerX / imageSize.width;
                                      final normalizedY = centerY / imageSize.height;

                                      const scanAreaLeft = 0.3;
                                      const scanAreaRight = 0.7;
                                      const scanAreaTop = 0.3;
                                      const scanAreaBottom = 0.7;

                                      if (normalizedX >= scanAreaLeft &&
                                          normalizedX <= scanAreaRight &&
                                          normalizedY >= scanAreaTop &&
                                          normalizedY <= scanAreaBottom) {
                                        if (result == null) {
                                          setState(() {
                                            result = barcode.rawValue;
                                          });
                                          _navigateToAddToner();
                                          break;
                                        }
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Positioned(
                                left: 0,
                                right: 0,
                                top: _animation.value * 160,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.transparent, Colors.orange, Colors.transparent],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildCorner(Alignment.topLeft, Colors.orange),
                          _buildCorner(Alignment.topRight, Colors.orange),
                          _buildCorner(Alignment.bottomLeft, Colors.orange),
                          _buildCorner(Alignment.bottomRight, Colors.orange),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (result != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: _buildResultRow('Scanned Code:', result!),
                    ),
                  const SizedBox(height: 20),
                  if (result != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                          text: 'Finish',
                          color: Colors.green,
                          onPressed: _navigateToAddToner,
                        ),
                        const SizedBox(width: 12),
                        _buildButton(
                          text: 'Retry',
                          color: Colors.grey,
                          onPressed: () => setState(() => result = null),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await cameraController.toggleTorch();
                setState(() => flashOn = !flashOn);
              },
              backgroundColor: Colors.white,
              elevation: 4,
              child: Icon(
                flashOn ? Icons.flash_on : Icons.flash_off,
                color: flashOn ? Colors.amber : Colors.grey.shade700,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () async {
                try {
                  await cameraController.setZoomScale(1.0); // Force max zoom
                  print('Zoom manually set to 1.0');
                } catch (e) {
                  print('Error setting zoom: $e');
                }
              },
              backgroundColor: Colors.white,
              elevation: 4,
              child: const Icon(
                Icons.zoom_in,
                color: Colors.grey,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, Color color) {
    bool isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    bool isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    return Positioned(
      left: isLeft ? 0 : null,
      right: !isLeft ? 0 : null,
      top: isTop ? 0 : null,
      bottom: !isTop ? 0 : null,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? BorderSide(color: color, width: 3) : BorderSide.none,
            bottom: !isTop ? BorderSide(color: color, width: 3) : BorderSide.none,
            left: isLeft ? BorderSide(color: color, width: 3) : BorderSide.none,
            right: !isLeft ? BorderSide(color: color, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _navigateToAddToner() {
    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}


class DualQRScannerTracesci extends StatefulWidget {
  const DualQRScannerTracesci({Key? key}) : super(key: key);

  @override
  _DualQRScannerTracesciState createState() => _DualQRScannerTracesciState();
}

class _DualQRScannerTracesciState extends State<DualQRScannerTracesci> with TickerProviderStateMixin {
  String? firstResult;
  String? secondResult;
  bool flashOn = false;
  bool isScanningSecondQR = false;
  double zoomScale = 0.67; // Initial zoom level approximating 3x
  MobileScannerController cameraController = MobileScannerController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Set initial zoom after camera initializes
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        await cameraController.setZoomScale(zoomScale);
        print('Initial zoom set to $zoomScale');
      } catch (e) {
        print('Error setting initial zoom: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        centerTitle: true,
        title: const Text(
          'Product Scanner',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF5F5F5)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(
                      isScanningSecondQR
                          ? 'Scan the Toner code to complete the process. '
                          : 'Scan the Quarter ID code to begin. (Quarter QR/Bar Code of the entry)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 250,
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          ClipRect(
                            child: SizedBox(
                              width: 250,
                              height: 180,
                              child: MobileScanner(
                                controller: cameraController,
                                onDetect: (BarcodeCapture barcodeCapture) {
                                  final List<Barcode> barcodes = barcodeCapture.barcodes;
                                  final Size imageSize = Size(
                                    barcodeCapture.size?.width ?? 0,
                                    barcodeCapture.size?.height ?? 0,
                                  );

                                  for (final barcode in barcodes) {
                                    final corners = barcode.corners;

                                    if (corners != null && imageSize.width > 0 && imageSize.height > 0) {
                                      // Calculate the center of the barcode
                                      double centerX = 0;
                                      double centerY = 0;

                                      for (final corner in corners) {
                                        centerX += corner.dx;
                                        centerY += corner.dy;
                                      }

                                      centerX /= corners.length;
                                      centerY /= corners.length;

                                      // Convert to normalized coordinates (0-1)
                                      final normalizedX = centerX / imageSize.width;
                                      final normalizedY = centerY / imageSize.height;

                                      // Define scan area matching the scanner box (adjust as needed)
                                      const scanAreaLeft = 0.25;   // Roughly 25% from left
                                      const scanAreaRight = 0.75;  // Roughly 75% from left
                                      const scanAreaTop = 0.35;    // Adjusted for vertical center
                                      const scanAreaBottom = 0.65; // Adjusted for vertical center

                                      // Check if barcode center is within the scan area
                                      if (normalizedX >= scanAreaLeft &&
                                          normalizedX <= scanAreaRight &&
                                          normalizedY >= scanAreaTop &&
                                          normalizedY <= scanAreaBottom) {
                                        if (firstResult == null && !isScanningSecondQR) {
                                          setState(() {
                                            firstResult = barcode.rawValue;
                                          });
                                        } else if (secondResult == null && isScanningSecondQR) {
                                          setState(() {
                                            secondResult = barcode.rawValue;
                                          });
                                        }
                                        break; // Exit after detecting a valid barcode
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Positioned(
                                left: 0,
                                right: 0,
                                top: _animation.value * 160,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.transparent, Colors.orange, Colors.transparent],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildCorner(Alignment.topLeft, Colors.orange),
                          _buildCorner(Alignment.topRight, Colors.orange),
                          _buildCorner(Alignment.bottomLeft, Colors.orange),
                          _buildCorner(Alignment.bottomRight, Colors.orange),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (firstResult != null || secondResult != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (firstResult != null)
                            _buildResultRow('Quarter ID:', firstResult!),
                          if (secondResult != null)
                            _buildResultRow('Serial No:', secondResult!),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (firstResult != null && !isScanningSecondQR)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                          text: 'Scan Toner Code',
                          color: Colors.blue,
                          onPressed: () => setState(() => isScanningSecondQR = true),
                        ),
                        const SizedBox(width: 12),
                        _buildButton(
                          text: 'Retry',
                          color: Colors.grey,
                          onPressed: () => setState(() => firstResult = null),
                        ),
                      ],
                    ),
                  if (secondResult != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                          text: 'Finish',
                          color: Colors.green,
                          onPressed: _returnScannedData,
                        ),
                        const SizedBox(width: 12),
                        _buildButton(
                          text: 'Retry Second',
                          color: Colors.grey,
                          onPressed: () => setState(() => secondResult = null),
                        ),
                        const SizedBox(width: 12),
                        _buildButton(
                          text: 'Reset All',
                          color: Colors.red,
                          onPressed: () => setState(() {
                            firstResult = null;
                            secondResult = null;
                            isScanningSecondQR = false;
                          }),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  // Zoom adjustment slider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Zoom: ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: zoomScale,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: (zoomScale * 3 + 1).toStringAsFixed(1) + 'x', // Approximate zoom factor
                            onChanged: (value) async {
                              setState(() {
                                zoomScale = value;
                              });
                              try {
                                await cameraController.setZoomScale(zoomScale);
                                print('Zoom adjusted to $zoomScale');
                              } catch (e) {
                                print('Error adjusting zoom: $e');
                              }
                            },
                            activeColor: Colors.orange,
                            inactiveColor: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 16),
        child: FloatingActionButton(
          onPressed: () async {
            await cameraController.toggleTorch();
            setState(() => flashOn = !flashOn);
          },
          backgroundColor: Colors.white,
          elevation: 4,
          child: Icon(
            flashOn ? Icons.flash_on : Icons.flash_off,
            color: flashOn ? Colors.amber : Colors.grey.shade700,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, Color color) {
    bool isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    bool isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    return Positioned(
      left: isLeft ? 0 : null,
      right: !isLeft ? 0 : null,
      top: isTop ? 0 : null,
      bottom: !isTop ? 0 : null,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? BorderSide(color: color, width: 3) : BorderSide.none,
            bottom: !isTop ? BorderSide(color: color, width: 3) : BorderSide.none,
            left: isLeft ? BorderSide(color: color, width: 3) : BorderSide.none,
            right: !isLeft ? BorderSide(color: color, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _returnScannedData() {
    if (firstResult != null && secondResult != null) {
      String combinedResult = '$firstResult-$secondResult';
      Navigator.pop(context, combinedResult);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}