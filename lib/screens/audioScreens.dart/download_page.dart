import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatelessWidget {
  final Stream<FileResponse>? fileStream;
  final VoidCallback downloadFile;
  final Products products;

  const DownloadPage({
    Key? key,
    this.fileStream,
    required this.downloadFile,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final downloadAudio =
        Provider.of<AudioDownloadProvider>(context, listen: false);
    return StreamBuilder<FileResponse>(
      stream: fileStream,
      builder: (context, AsyncSnapshot snapshot) {
        // print(snapshot.data.originalUrl);
        var loading = !snapshot.hasData || snapshot.data is DownloadProgress;
        if (snapshot.hasData) {
          if (loading) {
            bool finished = (snapshot.data as DownloadProgress).progress == 1;
            String audioPath = (snapshot.data as DownloadProgress).originalUrl;
            if (finished == true) {
              downloadAudio.addAudio(products, audioPath);
              print("finiiiisheeeeeed");
            }
            double? percent = (snapshot.data as DownloadProgress).progress;

            int percentInt = (percent! * 100).ceilToDouble().toInt();
            return Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.arrow_down,
                      color: MyColors.primaryColor),
                  splashRadius: 1,
                ),
                Text(
                  percentInt.toString() + "%",
                  style: const TextStyle(
                      fontSize: 12, color: MyColors.primaryColor),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.arrow_down,
                      color: MyColors.primaryColor),
                  splashRadius: 1,
                ),
                const Text("Татсан",
                    style: TextStyle(fontSize: 12, color: MyColors.gray))
              ],
            );
          }
        } else {
          return Column(
            children: [
              IconButton(
                onPressed: () {
                  downloadFile();
                },
                icon: const Icon(IconlyLight.arrow_down, color: MyColors.gray),
                splashRadius: 1,
              ),
              const Text("Татах",
                  style: TextStyle(fontSize: 12, color: MyColors.gray))
            ],
          );
        }
      },
    );
  }
}
// (fileStream == null)
//                     ? 
//                     :