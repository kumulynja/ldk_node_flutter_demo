# Lightning Node Repository package

The LightningNodeRepository will be responsible for abstracting the internal implementation details of how we connect, communicate and transact on the lightning network. In this case, it will be integrating with [LDK](https://lightningdevkit.org) but we can always change the internal implementation later on and our application will be unaffected.

## Models

### Payment

The Payment model will describe a payment in the context of the lightning domain. For the purposes of this example, a payment will consist of ...

## API

Just like most packages, the lightning_node_repository defines it's API surface via lib/lightning_node_repository.dart

The LightningNodeRepository exposes a Stream<Payment> which we can subscribe to in order to be notified of incoming payments. In addition, it exposes methods to make a payment, createChannel, closeChannel, and ....

Note: The LightningNodeRepository is also responsible for handling low-level errors that can occur in the data layer and exposes a clean, simple set of errors that align with the domain.