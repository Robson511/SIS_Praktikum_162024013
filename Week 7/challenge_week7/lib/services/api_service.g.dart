// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://jsonplaceholder.typicode.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<Post>> getPosts() async {
    final _options = _setStreamType<List<Post>>(
      Options(method: 'GET', headers: <String, dynamic>{})
          .compose(_dio.options, '/posts')
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    return _result.data!
        .map((dynamic i) => Post.fromJson(i as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Post> getPost(int id) async {
    final _options = _setStreamType<Post>(
      Options(method: 'GET', headers: <String, dynamic>{})
          .compose(_dio.options, '/posts/${id}')
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    return Post.fromJson(_result.data!);
  }

  @override
  Future<List<Post>> getPostsByUserId(int userId) async {
    final queryParameters = <String, dynamic>{r'userId': userId};
    final _options = _setStreamType<List<Post>>(
      Options(method: 'GET', headers: <String, dynamic>{})
          .compose(_dio.options, '/posts', queryParameters: queryParameters)
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    return _result.data!
        .map((dynamic i) => Post.fromJson(i as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Post> createPost(Post post) async {
    final _data = <String, dynamic>{};
    _data.addAll(post.toJson());
    final _options = _setStreamType<Post>(
      Options(method: 'POST', headers: <String, dynamic>{})
          .compose(_dio.options, '/posts', data: _data)
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    return Post.fromJson(_result.data!);
  }

  @override
  Future<Post> updatePost(int id, Post post) async {
    final _data = <String, dynamic>{};
    _data.addAll(post.toJson());
    final _options = _setStreamType<Post>(
      Options(method: 'PUT', headers: <String, dynamic>{})
          .compose(_dio.options, '/posts/${id}', data: _data)
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    return Post.fromJson(_result.data!);
  }

  @override
  Future<void> deletePost(int id) async {
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: <String, dynamic>{})
          .compose(_dio.options, '/posts/${id}')
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
