# LDK Node Flutter Demo

A project to demonstrate and teach about the use of the Lightning Development Kit and the related Bitcoin Development Kit to create a Bitcoin Lightning wallet app in Flutter, facilitated by packages like ldk_node_flutter and bdk_flutter.

## Getting Started with Flutter development

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Lightning Development Kit

## Bitcoin Development Kit

## BIP39 Mnemonic

The application will use bdk_flutter to generate a BIP39 compliant mnemonic, also known as seed phrase. This is currently not required when using ldk_node, but it enables the creation and recovery of both the Lightning wallet and the on-chain wallet while having to backup only one mnemonic. It also makes the use of ldk_node more secure, since currently (version 0.1.0) the only other entropy sources that ldk_node can consume or generate have to be stored on the file system, which is insecure. By generating the mnemonic first, it can be stored in and retrieved from secure storage and then be used only in memory.
