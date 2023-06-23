import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/screens/lightning/channel_closing_screen.dart';
import 'package:ldk_node_flutter_demo/screens/lightning/channel_opening_screen.dart';
import 'package:ldk_node_flutter_demo/screens/lightning/invoice_generation_screen.dart';
import 'package:ldk_node_flutter_demo/screens/lightning/invoice_payment_screen.dart';
import 'package:ldk_node_flutter_demo/screens/lightning/on_chain_funding_screen.dart';
import 'package:ldk_node_flutter_demo/screens/lightning/spontaneous_send_screen.dart';
import 'package:ldk_node_flutter_demo/screens/lightning/lightning_home_screen.dart';

GoRoute lightningRoutes = GoRoute(
  path: '/lightning',
  name: 'lightning',
  pageBuilder: (BuildContext context, GoRouterState state) {
    return const MaterialPage(
      child: LightningHomeScreen(),
    );
  },
  routes: [
    // Define subroutes for Lightning Wallet here.
    GoRoute(
      path: 'on-chain-funding',
      name: 'on-chain-funding',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const MaterialPage(
          child: OnChainFundingScreen(),
        );
      },
    ),
    GoRoute(
      path: 'channel-opening',
      name: 'channel-opening',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const MaterialPage(
          child: ChannelOpeningScreen(),
        );
      },
    ),
    GoRoute(
      path: 'channel-closing',
      name: 'channel-closing',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const MaterialPage(
          child: ChannelClosingScreen(),
        );
      },
    ),
    GoRoute(
      path: 'invoice-generation',
      name: 'invoice-generation',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const MaterialPage(
          child: InvoiceGenerationScreen(),
        );
      },
    ),
    GoRoute(
      path: 'invoice-payment',
      name: 'invoice-payment',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const MaterialPage(
          child: InvoicePaymentScreen(),
        );
      },
    ),
    GoRoute(
      path: 'spontaneous-send',
      name: 'spontaneous-send',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const MaterialPage(
          child: SpontaneousSendScreen(),
        );
      },
    ),
  ],
);
