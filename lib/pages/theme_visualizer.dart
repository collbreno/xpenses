import 'package:flutter/material.dart';

class ThemeVisualizer extends StatelessWidget {
  const ThemeVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Theme.of(context).brightness.toString()),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          ElevatedButton(onPressed: () {}, child: Text("Elevated Button")),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () {}, child: Text("Outlined Button")),
          const SizedBox(height: 12),
          TextButton(onPressed: () {}, child: Text("Text Button")),
          const SizedBox(height: 12),
          const ListTile(
            title: Text("List Tile"),
            leading: Icon(Icons.person),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text("Card")),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Primary color",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Secondary color",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Theme.of(context).colorScheme.tertiary,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Tertiary color",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
