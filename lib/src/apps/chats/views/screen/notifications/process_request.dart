import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mukai/brick/models/cooperative-member-request.model.dart';
import 'package:mukai/src/controllers/cooperative-member-requests.controller.dart';
import 'package:mukai/theme/theme.dart';

class ProcessRequest extends StatefulWidget {
  final CooperativeMemberRequest request;
  const ProcessRequest({super.key, required this.request});

  @override
  State<ProcessRequest> createState() => _ProcessRequestState();
}

class _ProcessRequestState extends State<ProcessRequest> {
  int selectedTab = 0;
  final CooperativeMemberRequestController requestController =
      CooperativeMemberRequestController();
  bool _isLoading = false;
  Map<String, dynamic>? requestDetails;

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final data =
        await requestController.viewRequestDetails(widget.request.memberId!);
    log('ProcessRequest data: ${JsonEncoder.withIndent(' ').convert(data)}');
    setState(() {
      requestDetails = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void accept(CooperativeMemberRequest request) async {
    await requestController.resolveRequest(request.memberId!);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void decline() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 10;
    final height = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 85.0,
        title: Text(
          'Process Request',
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : requestDetails != null
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: width, vertical: height),
                  child: Column(
                    children: [
                      _buildPendingRequestInfo(requestDetails!),
                      SizedBox(height: 15),
                      _buildActionButtons(widget.request)
                    ],
                  ))
              : Center(
                  child: Text('No requests'),
                ),
    );
  }

  Widget _buildPendingRequestInfo(Map<String, dynamic> request) {
    return Center(
      child: Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(request['request_type'] ?? 'No message'),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('First name',
                                style: TextStyle(color: Colors.grey)),
                            Text('Last name',
                                style: TextStyle(color: Colors.grey)),
                            // Text('Request type',
                            //     style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(request['profiles']['first_name'] ?? 'No first name'),
                            Text(request['profiles']['first_name'] ?? 'No last name'),
                            // Text(request['profiles'] ?? 'No request type'),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ]))),
    );
  }

  Widget _buildActionButtons(CooperativeMemberRequest request) {
    final width = MediaQuery.of(context).size.width / 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => accept(request),
          child: Text('Accept'),
        ),
        SizedBox(width: width),
        GestureDetector(
          onTap: () => decline(),
          child: Text('Decline'),
        )
      ],
    );
  }
}
