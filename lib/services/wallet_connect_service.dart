import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectService {
  late Web3App wcClient;

  WalletConnectService() {
    _initialize();
  }

  Future<void> _initialize() async {
    wcClient = await Web3App.createInstance(
      projectId: '001316',
      relayUrl: 'wss://relay.walletconnect.com',
      metadata: const PairingMetadata(
        name: 'Qubic Wallet',
        description: 'Connect to your wallet for managing your assets',
        url: 'https://wallet.qubic.org/public',
        icons: ['assets/images/logo_blue.png'],
        redirect: Redirect(
          native: 'qubicwallet://',
          universal: 'https://qubicwallet.com/app',
        ),
      ),
    );
  }

  Future<Uri?> createSession() async {
    final ConnectResponse resp = await wcClient.connect(
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1', 'eip155:5'],
          methods: ['personal_sign', 'eth_sendTransaction'],
          events: ['accountsChanged'],
        ),
      },
    );
    return resp.uri;
  }

  Future<void> killSession(String topic) async {
    await wcClient.disconnectSession(
      topic: topic,
      reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
    );
  }
}