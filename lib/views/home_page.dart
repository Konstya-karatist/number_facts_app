import 'package:flutter/material.dart';

import '../controllers/number_controller.dart';
import '../models/number_fact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final NumberController _numberController = NumberController();

  NumberFact? _fact;
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadFact() async {
    setState(() {
      _isLoading = true;
      _fact = null;
      _error = null;
    });

    try {
      final fact = await _numberController.getNumberFact(_textController.text);

      if (!mounted) {
        return;
      }

      setState(() {
        _fact = fact;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Факты о числах')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Введите число',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Например, 42',
                      labelText: 'Число',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) {
                      if (!_isLoading) {
                        _loadFact();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _loadFact,
                    icon: const Icon(Icons.search),
                    label: const Text('Получить факт'),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (_error != null) _ErrorCard(message: _error!),
                  if (_fact != null) _FactCard(fact: _fact!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  final NumberFact fact;

  const _FactCard({required this.fact});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Число ${fact.number}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(fact.text),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: TextStyle(color: colorScheme.onErrorContainer),
        ),
      ),
    );
  }
}
