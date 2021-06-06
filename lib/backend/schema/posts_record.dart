import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema_util.dart';
import 'serializers.dart';

part 'posts_record.g.dart';

abstract class PostsRecord implements Built<PostsRecord, PostsRecordBuilder> {
  static Serializer<PostsRecord> get serializer => _$postsRecordSerializer;

  @nullable
  String get title;

  @nullable
  String get description;

  @nullable
  String get location;

  @nullable
  String get priority;

  @nullable
  DocumentReference get user;

  @nullable
  @BuiltValueField(wireName: 'image_url')
  String get imageUrl;

  @nullable
  @BuiltValueField(wireName: 'created_at')
  Timestamp get createdAt;

  @nullable
  @BuiltValueField(wireName: 'is_validated')
  int get isValidated;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(PostsRecordBuilder builder) => builder
    ..title = ''
    ..description = ''
    ..location = ''
    ..priority = ''
    ..imageUrl = ''
    ..isValidated = 0;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('posts');

  static Stream<PostsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  PostsRecord._();
  factory PostsRecord([void Function(PostsRecordBuilder) updates]) =
      _$PostsRecord;
}

Map<String, dynamic> createPostsRecordData({
  String title,
  String description,
  String location,
  String priority,
  DocumentReference user,
  String imageUrl,
  Timestamp createdAt,
  int isValidated,
}) =>
    serializers.serializeWith(
        PostsRecord.serializer,
        PostsRecord((p) => p
          ..title = title
          ..description = description
          ..location = location
          ..priority = priority
          ..user = user
          ..imageUrl = imageUrl
          ..createdAt = createdAt
          ..isValidated = isValidated));

PostsRecord get dummyPostsRecord {
  final builder = PostsRecordBuilder()
    ..title = dummyString
    ..description = dummyString
    ..location = dummyString
    ..priority = dummyString
    ..imageUrl = dummyImagePath
    ..createdAt = dummyTimestamp
    ..isValidated = dummyInteger;
  return builder.build();
}

List<PostsRecord> createDummyPostsRecord({int count}) =>
    List.generate(count, (_) => dummyPostsRecord);
