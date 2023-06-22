import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ldk_node_flutter_demo/blocs/channel_opening/channel_opening_bloc.dart';
import 'package:ldk_node_flutter_demo/blocs/channel_opening/channel_opening_event.dart';
import 'package:ldk_node_flutter_demo/blocs/channel_opening/channel_opening_state.dart';
import 'package:lightning_node_repository/lightning_node_repository.dart';

class OpenChannelScreen extends StatelessWidget {
  const OpenChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Channel opening'),
      ),
      body: BlocProvider(
        create: (context) => ChannelOpeningBloc(
          lightningNodeRepository:
              RepositoryProvider.of<LightningNodeRepository>(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 24.0),
                Text(
                  'Add the details of the node you want to open a channel with.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                const OpenChannelForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OpenChannelForm extends StatefulWidget {
  const OpenChannelForm({super.key});

  @override
  State<OpenChannelForm> createState() => _OpenChannelFormState();
}

class _OpenChannelFormState extends State<OpenChannelForm> {
  final _addressIpFocusNode = FocusNode();
  final _addressPortFocusNode = FocusNode();
  final _counterpartyPublicKeyFocusNode = FocusNode();
  final _channelAmountSatsFocusNode = FocusNode();
  final _pushToCounterpartyMsat = FocusNode();

  @override
  void initState() {
    super.initState();
    _addressIpFocusNode.addListener(() {
      if (!_addressIpFocusNode.hasFocus) {
        context.read<ChannelOpeningBloc>().add(AddressIpUnfocused());
      }
    });
    _addressPortFocusNode.addListener(() {
      if (!_addressPortFocusNode.hasFocus) {
        context.read<ChannelOpeningBloc>().add(AddressPortUnfocused());
      }
    });
    _counterpartyPublicKeyFocusNode.addListener(() {
      if (!_counterpartyPublicKeyFocusNode.hasFocus) {
        context
            .read<ChannelOpeningBloc>()
            .add(CounterpartyPublicKeyUnfocused());
      }
    });
    _channelAmountSatsFocusNode.addListener(() {
      if (!_channelAmountSatsFocusNode.hasFocus) {
        context.read<ChannelOpeningBloc>().add(ChannelAmountSatsUnfocused());
      }
    });
    _pushToCounterpartyMsat.addListener(() {
      if (!_pushToCounterpartyMsat.hasFocus) {
        context
            .read<ChannelOpeningBloc>()
            .add(PushToCounterpartyMsatUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _addressIpFocusNode.dispose();
    _addressPortFocusNode.dispose();
    _counterpartyPublicKeyFocusNode.dispose();
    _channelAmountSatsFocusNode.dispose();
    _pushToCounterpartyMsat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChannelOpeningBloc, ChannelOpeningState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Channel opened'),
                content: const Text('Channel opened successfully'),
                actions: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar
            ..showSnackBar(
              const SnackBar(content: Text('Opening channel...')),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _AddressIpInput(focusNode: _addressIpFocusNode),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: _AddressPortInput(focusNode: _addressPortFocusNode),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _CounterpartyPublicKeyInput(
                focusNode: _counterpartyPublicKeyFocusNode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _ChannelAmountSatsInput(
                  focusNode: _channelAmountSatsFocusNode),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _PushToCounterpartyMsatInput(
                  focusNode: _pushToCounterpartyMsat),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _AnnounceChannelCheckbox(),
            ),
            const SizedBox(height: 16), // Spacing before the button
            const _OpenChannelButton(),
          ],
        ),
      ),
    );
  }
}

class _AddressIpInput extends StatelessWidget {
  const _AddressIpInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelOpeningBloc, ChannelOpeningState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.addressIp.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Ip',
            helperText:
                'A valid ip address of the node to connect to and open a channel with',
            errorText: state.addressIp.displayError != null
                ? 'Please ensure the ip entered is valid'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context.read<ChannelOpeningBloc>().add(AddressIpChanged(value));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _AddressPortInput extends StatelessWidget {
  const _AddressPortInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelOpeningBloc, ChannelOpeningState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.addressPort.value.toString(),
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Port',
            helperText:
                'A valid port of the node to connect to and open a channel with',
            errorText: state.addressPort.displayError != null
                ? 'Please ensure the port entered is valid'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context
                .read<ChannelOpeningBloc>()
                .add(AddressPortChanged(int.parse(value)));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _CounterpartyPublicKeyInput extends StatelessWidget {
  const _CounterpartyPublicKeyInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelOpeningBloc, ChannelOpeningState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.counterpartyPublicKey.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Counterparty public key',
            helperText:
                'The public key or node id of the node to connect to and open a channel with',
            errorText: state.counterpartyPublicKey.displayError != null
                ? 'Please ensure the public key entered is valid'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context
                .read<ChannelOpeningBloc>()
                .add(CounterpartyPublicKeyChanged(value));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _ChannelAmountSatsInput extends StatelessWidget {
  const _ChannelAmountSatsInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelOpeningBloc, ChannelOpeningState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.channelAmountSats.value.toString(),
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Channel amount sats',
            helperText:
                'The amount of sats to open the channel with. Must be greater than 0',
            errorText: state.channelAmountSats.displayError != null
                ? 'Please ensure the amount entered is valid'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context
                .read<ChannelOpeningBloc>()
                .add(ChannelAmountSatsChanged(int.parse(value)));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _PushToCounterpartyMsatInput extends StatelessWidget {
  const _PushToCounterpartyMsatInput({required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelOpeningBloc, ChannelOpeningState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.pushToCounterpartyMsat.value.toString(),
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Push to counterparty msat',
            helperText:
                'The amount of msat to push to the counterparty. Must be greater than 0',
            errorText: state.pushToCounterpartyMsat.displayError != null
                ? 'Please ensure the amount entered is valid'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context
                .read<ChannelOpeningBloc>()
                .add(PushToCounterpartyMsatChanged(int.parse(value)));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _AnnounceChannelCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelOpeningBloc, ChannelOpeningState>(
      builder: (context, state) {
        return CheckboxListTile(
          title: const Text('Announce channel'),
          subtitle: const Text(
              'Whether to announce the channel to the network or keep the channel private'),
          value: state.announceChannel,
          onChanged: (value) {
            context
                .read<ChannelOpeningBloc>()
                .add(AnnounceChannelChanged(value ?? false));
          },
        );
      },
    );
  }
}

class _OpenChannelButton extends StatelessWidget {
  const _OpenChannelButton();

  @override
  Widget build(BuildContext context) {
    final isValid =
        context.select((ChannelOpeningBloc bloc) => bloc.state.isValid);
    return ElevatedButton(
      onPressed: isValid
          ? () =>
              context.read<ChannelOpeningBloc>().add(ChannelOpeningSubmitted())
          : null,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors
            .grey, // This sets the color of the button when it's disabled.
      ),
      child: const Text('Open channel'),
    );
  }
}
