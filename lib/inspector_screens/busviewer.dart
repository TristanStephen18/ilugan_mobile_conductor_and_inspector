import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/viewbus.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class BusesScreen extends StatefulWidget {
  BusesScreen({super.key, required this.compId});

  final String compId;
  // final String busnum;

  @override
  State<BusesScreen> createState() => _BusesScreenState();
}

class _BusesScreenState extends State<BusesScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;
  List<Map<String, dynamic>> _busData = [];

  @override
  void initState() {
    super.initState();
    _fetchBusData(); // Fetch data once during initialization
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Fetch data from Firestore only once and store in `_busData`
  Future<void> _fetchBusData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.compId)
        .collection('buses')
        .get();

    setState(() {
      // Filter out documents where doc.id == widget.busnum
      _busData = snapshot.docs
          .map((doc) => doc.data())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: const Text("Buses", style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              height: 50,
              width: 50,
            ),
          ),
        ],
      ),
      body: _busData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildBusesContent(context),
    );
  }

  Widget _buildBusesContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider.builder(
                  itemCount: _busData.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/icons/choose.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 170.0,
                    enableInfiniteScroll: true,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      _carouselController.previousPage();
                    },
                  ),
                ),
                Positioned(
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.black),
                    onPressed: () {
                      _carouselController.nextPage();
                    },
                  ),
                ),
              ],
            ),
            const Gap(20),
            CustomText(
              content: _busData[_currentIndex]['bus_number'] ?? 'N/A',
              fontweight: FontWeight.bold,
              fsize: 20,
            ),
            const Gap(10),
            _buildBusDetailsContainer(context, _busData[_currentIndex]),
            const Gap(20),
            Ebuttons(
              func: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BusViewer(
                        busnum: _busData[_currentIndex]['plate_number'],
                        compId: widget.compId)));
              },
              label: 'View in Map',
              bcolor: Colors.greenAccent,
              fcolor: Colors.black,
              fontweight: FontWeight.bold,
              height: 50,
              tsize: 22,
              width: MediaQuery.of(context).size.width - 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusDetailsContainer(
      BuildContext context, Map<String, dynamic> bus) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(
              content: "Bus Details",
              fontweight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          Center(
            child: CustomText(
              content: "Plate Number: ${bus['plate_number'] ?? 'N/A'}",
            ),
          ),
          const Divider(thickness: 2, color: Colors.black),
          const Gap(8),
          CustomText(
            content: bus['conductor'] != ""
                ? "Conductor: ${bus['conductor']}"
                : "Conductor: None",
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.drive_eta),
                  CustomText(content: bus['terminalloc'] ?? 'N/A'),
                ],
              ),
              const Icon(Icons.arrow_forward, size: 30),
              Column(
                children: [
                  const Icon(Icons.location_on),
                  CustomText(content: bus['destination'] ?? 'N/A'),
                ],
              ),
            ],
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSeatInfoCard(
                title: "Seats Available",
                value: bus['available_seats'].toString(),
                backgroundColor: Colors.greenAccent,
                valueColor: Colors.white,
              ),
              Column(
                children: [
                  _buildSeatStatusCard(
                    backgroundColor: Colors.yellow,
                    title: "Reserved",
                    value: bus['reserved_seats'].toString(),
                  ),
                  const Gap(10),
                  _buildSeatStatusCard(
                    backgroundColor: Colors.green,
                    title: "Occupied",
                    value: bus['occupied_seats'].toString(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatInfoCard({
    required String title,
    required String value,
    required Color backgroundColor,
    required Color valueColor,
  }) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            content: title,
            fsize: 15,
            fontweight: FontWeight.bold,
          ),
          const Gap(10),
          CustomText(
            content: value,
            fsize: 50,
          ),
          const Gap(10),
          CustomText(
            content: "Total seats : 42",
            fsize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSeatStatusCard({
    required String title,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            content: title,
            fsize: 15,
            fontweight: FontWeight.bold,
          ),
          const Gap(5),
          CustomText(
            content: value,
            fsize: 20,
            fontweight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
