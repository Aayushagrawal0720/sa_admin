// Widget inss() {
//   final as = Provider.of<InstrumentFetchService>(context, listen: false);
//   // as.loadData();
//   //
//   SharedPreferenc().setInstrumentdate(DateTime.now().toString());
//   SharedPreferenc().getInstrumentDate().then((value) {
//     if (value.toString() != "null") {
//       var date = DateTime.parse(value);
//       var now = DateTime.now();
//       if (date.day == now.day &&
//           date.month == now.month &&
//           date.year == now.year) {
//         as.setDone();
//       } else {
//         as.loadData();
//       }
//     } else {
//       as.loadData();
//     }
//   });
//
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: MediaQuery.of(context).size.height,
//     color: Colors.white,
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           "assets/logo/quicktrades.png",
//           scale: 6,
//         ),
//         SizedBox(height: 20),
//         Container(
//           width: MediaQuery.of(context).size.width / 2,
//           child: LinearProgressIndicator(
//             backgroundColor: Colors.grey,
//             valueColor: AlwaysStoppedAnimation<Color>(ColorsTheme.darkred),
//           ),
//         ),
//         Text(
//           "Fetching instruments\nIt may take less then a minute",
//           textAlign: TextAlign.center,
//           style: GoogleFonts.abel(color: Colors.black),
//         ),
//         Text(
//           "Until then, take a deep breath and meditate",
//           textAlign: TextAlign.center,
//           style: GoogleFonts.abel(color: Colors.black),
//         ),
//       ],
//     ),
//   );
// }