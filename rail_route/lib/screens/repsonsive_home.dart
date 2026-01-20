import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            // Header
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

            // Responsive Content (LayoutBuilder)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600 || isLandscape) {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: const [
                        ContentCard(title: "Card 1"),
                        ContentCard(title: "Card 2"),
                        ContentCard(title: "Card 3"),
                        ContentCard(title: "Card 4"),
                      ],
                    );
                  } else {
                    return ListView(
                      children: const [
                        ContentCard(title: "Card 1"),
                        ContentCard(title: "Card 2"),
                        ContentCard(title: "Card 3"),
                      ],
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 12),

            // Footer Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/demo');
                    },
                    child: const Text("Go to Demo"),
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
}