import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import '../widgets/tiles/transaction_tile.dart';

enum TxnFilter { all, today, week, month, debit, credit }

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final FirestoreService _firestore = FirestoreService();

  List<TransactionModel> _allTxns = [];
  List<TransactionModel> _displayTxns = [];
  bool _isLoading = false;
  TxnFilter _activeFilter = TxnFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final txns = await _firestore.getAllTransactions();
      // Ensure transactions are sorted newest -> oldest
      txns.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      setState(() {
        _allTxns = txns;
      });
      _applyFilter(_activeFilter, refreshState: false);
    } catch (e, st) {
      debugPrint("Error loading transactions: $e\n$st");
      // keep existing lists (or clear) and show message via SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transactions')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter(TxnFilter filter, {bool refreshState = true}) {
    final now = DateTime.now();
    List<TransactionModel> result;

    switch (filter) {
      case TxnFilter.today:
        result = _allTxns.where((t) {
          final d = t.timestamp;
          return d.year == now.year && d.month == now.month && d.day == now.day;
        }).toList();
        break;

      case TxnFilter.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        result = _allTxns.where((t) {
          final d = t.timestamp;
          return !d.isBefore(startOfWeek) && !d.isAfter(endOfWeek);
        }).toList();
        break;

      case TxnFilter.month:
        result = _allTxns.where((t) {
          final d = t.timestamp;
          return d.year == now.year && d.month == now.month;
        }).toList();
        break;

      case TxnFilter.debit:
        result = _allTxns.where((t) => t.type.toLowerCase() == 'debit').toList();
        break;

      case TxnFilter.credit:
        result = _allTxns.where((t) => t.type.toLowerCase() == 'credit').toList();
        break;

      case TxnFilter.all:
      default:
        result = List.from(_allTxns);
    }

    // Keep newest -> oldest ordering
    result.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (refreshState) {
      setState(() {
        _activeFilter = filter;
        _displayTxns = result;
      });
    } else {
      _displayTxns = result;
    }
  }

  Widget _buildFilterChips() {
    final choices = {
      TxnFilter.all: 'All',
      TxnFilter.today: 'Today',
      TxnFilter.week: 'Week',
      TxnFilter.month: 'Month',
      TxnFilter.debit: 'Debit',
      TxnFilter.credit: 'Credit',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: choices.entries.map((entry) {
          final isSelected = _activeFilter == entry.key;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (_) => _applyFilter(entry.key),
              selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadTransactions,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildFilterChips(),
          const SizedBox(height: 8),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _onRefresh,
              child: _displayTxns.isEmpty
                  ? ListView( // keep scrollable for RefreshIndicator
                children: [
                  SizedBox(height: 80),
                  Icon(Icons.receipt_long, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'No transactions found',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Try scanning SMS or tap refresh',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    ),
                  )
                ],
              )
                  : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _displayTxns.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final txn = _displayTxns[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: TransactionTile(transaction: txn),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
