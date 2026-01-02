import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 📱 Screen size detection
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final bool isTablet = screenWidth > 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive Home"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          children: [
            // 🧠 Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Welcome to Responsive UI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 26 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📦 Main content (responsive)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (isTablet || isLandscape) {
                    // 🧩 Two-column layout
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        contentCard("Card 1"),
                        contentCard("Card 2"),
                        contentCard("Card 3"),
                        contentCard("Card 4"),
                      ],
                    );
                  } else {
                    // 📱 Single-column layout
                    return ListView(
                      children: [
                        contentCard("Card 1"),
                        contentCard("Card 2"),
                        contentCard("Card 3"),
                      ],
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 12),

            // 🔘 Footer / Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Action 1"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Action 2"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 🔧 Reusable content widget
  Widget contentCard(String title) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
