import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/providers/tickets_provider.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/event_tiles.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load tickets when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ticketsProvider = Provider.of<TicketsProvider>(context, listen: false);
      if (ticketsProvider.tickets.isEmpty && !ticketsProvider.isLoading) {
        ticketsProvider.loadTickets();
      }
    });

    return Scaffold(
      appBar: const Appbar(title: 'My Tickets'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<TicketsProvider>(
          builder: (context, ticketsProvider, child) {
            final tickets = ticketsProvider.tickets;
            return RefreshIndicator(
              onRefresh: () async {
                await ticketsProvider.loadTickets();
              },
              child: ticketsProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tickets.isEmpty
                      ? const Center(
                          child: Text(
                            'No tickets purchased yet.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView(
                          children: [
                            EventTiles(eventModel: tickets),
                            const SizedBox(height: 20),
                          ],
                        ),
            );
          },
        ),
      ),
    );
  }
}