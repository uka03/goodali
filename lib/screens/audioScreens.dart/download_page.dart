// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:goodali/Utils/styles.dart';
// import 'package:iconly/iconly.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class DownloadPage extends StatelessWidget {
//   final Stream<FileResponse>? fileStream;
//   final VoidCallback downloadFile;

//   const DownloadPage({
//     Key? key,
//     this.fileStream,
//     required this.downloadFile,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<FileResponse>(
//       stream: fileStream,
//       builder: (context, snapshot) {
//         // print(snapshot.data.originalUrl);
//         var loading = !snapshot.hasData || snapshot.data is DownloadProgress;

//         if (snapshot.hasError) {
//           return const Text('Error');
//         } else if (loading) {
//           double? percent = (snapshot.data as DownloadProgress).progress;

//           int percentInt = (percent! * 100).ceilToDouble().toInt();
//           return CircularPercentIndicator(
//             radius: 20,
//             lineWidth: 3,
//             animation: true,
//             percent: percent,
//             backgroundColor: MyColors.border1,
//             progressColor: MyColors.success,
//             center: Text(
//               percentInt.toString() + "%",
//               style: const TextStyle(fontSize: 12.0, color: MyColors.black),
//             ),
//           );
//         } else {
//           return Column(
//             children: [
//               IconButton(
//                 onPressed: () {},
//                 icon:
//                     const Icon(IconlyLight.arrow_down, color: MyColors.success),
//                 splashRadius: 1,
//               ),
//               const Text("Татагдсан",
//                   style: TextStyle(fontSize: 12, color: MyColors.gray))
//             ],
//           );
//         }
//       },
//     );
//   }
// }
