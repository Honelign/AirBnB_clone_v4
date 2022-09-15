import 'package:flutter/material.dart';
import 'package:kin_music_player_app/coins/components/coin_icon.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/provider/coin_provider.dart';
import 'package:provider/provider.dart';

class TipArtistCard extends StatefulWidget {
  final String value;
  final String artistName;
  final String artistId;
  final Function refresher;
  const TipArtistCard({
    Key? key,
    required this.value,
    required this.refresher,
    required this.artistName,
    required this.artistId,
  }) : super(key: key);

  @override
  State<TipArtistCard> createState() => _TipArtistCardState();
}

class _TipArtistCardState extends State<TipArtistCard> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: isLoading == true
          ? Container()
          : InkWell(
              onTap: () async {
                isLoading = true;
                final provider =
                    Provider.of<CoinProvider>(context, listen: false);
                int remainingCoinAmount =
                    int.parse(await provider.getCoinBalance());
                int transferCoinAmount = int.parse(widget.value);

                // validate remaining coins
                if (remainingCoinAmount > transferCoinAmount) {
                  await provider.transferCoin(
                    transferCoinAmount,
                    widget.artistId,
                  );
                  widget.refresher();
                } else {
                  kShowToast(
                    message: lackingCoinsMessage,
                  );
                }

                isLoading = false;
              },
              child: isLoading == true
                  ? KinProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon and value
                        Row(
                          children: [
                            const CoinIcon(),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              widget.value + " ETB",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(
                                  0.75,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Button
                        // Container(
                        //   constraints: BoxConstraints(
                        //     maxWidth: MediaQuery.of(context).size.width * 0.5,
                        //     minWidth: 120,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     color: kSecondaryColor,
                        //   ),
                        //   padding: const EdgeInsets.symmetric(horizontal: 12),
                        //   child: Center(
                        //     child: Text(
                        //       "Tip ${widget.artistName}",
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //       ),
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
            ),
    );
  }
}
