import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../upload_page/upload_page_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          'News feed',
          style: FlutterFlowTheme.bodyText1.override(
            fontFamily: 'Poppins',
            fontSize: 22,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed ...');
        },
        backgroundColor: FlutterFlowTheme.primaryColor,
        elevation: 8,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadPageWidget(),
              ),
            );
          },
          child: Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<PostsRecord>>(
          stream: queryPostsRecord(
            queryBuilder: (postsRecord) =>
                postsRecord.orderBy('created_at', descending: true),
          ),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            List<PostsRecord> listViewPostsRecordList = snapshot.data;
            // Customize what your widget looks like with no query results.
            if (snapshot.data.isEmpty) {
              // return Container();
              // For now, we'll just include some dummy data.
              listViewPostsRecordList = createDummyPostsRecord(count: 4);
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: listViewPostsRecordList.length,
              itemBuilder: (context, listViewIndex) {
                final listViewPostsRecord =
                    listViewPostsRecordList[listViewIndex];
                return StreamBuilder<PostsRecord>(
                  stream:
                      PostsRecord.getDocument(listViewPostsRecord.reference),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final cardPostsRecord = snapshot.data;
                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color(0xFFF5F5F5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: Alignment(-1, 0),
                            child: Image.network(
                              listViewPostsRecord.imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            listViewPostsRecord.title,
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Align(
                                alignment: Alignment(0, 0),
                                child: Text(
                                  listViewPostsRecord.location,
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Text(
                                listViewPostsRecord.priority,
                                style: FlutterFlowTheme.bodyText1.override(
                                  fontFamily: 'Poppins',
                                ),
                              )
                            ],
                          ),
                          Text(
                            listViewPostsRecord.description,
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
