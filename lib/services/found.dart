import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';

abstract class FoundState {
  FoundState({this.posts, required this.keyword});

  final List<Post>? posts;
  final String keyword;

  FoundState updateKeyword(String keyword);
}

class FoundLoading extends FoundState {
  FoundLoading({List<Post>? posts, required String keyword})
      : super(posts: posts, keyword: keyword);

  @override
  FoundLoading updateKeyword(String keyword) {
    return FoundLoading(keyword: keyword, posts: posts);
  }
}

class FoundError extends FoundState {
  FoundError({
    required this.message,
    List<Post>? posts,
    required String keyword,
  }) : super(posts: posts, keyword: keyword);

  final String message;

  @override
  FoundError updateKeyword(String keyword) {
    return FoundError(
      keyword: keyword,
      posts: posts,
      message: message,
    );
  }
}

class FoundLoaded extends FoundState {
  FoundLoaded({required List<Post> posts, required String keyword})
      : super(posts: posts, keyword: keyword);

  @override
  FoundLoaded updateKeyword(String keyword) {
    return FoundLoaded(keyword: keyword, posts: posts!);
  }
}

class FoundCubit extends Cubit<FoundState> {
  FoundCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        super(FoundLoading(keyword: ''));

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;

  void setKeyword(String keyword) {
    emit(state.updateKeyword(keyword));
  }

  Future<void> searchPosts({
    required OrderBy orderBy,
  }) async {
    final userId = _authRepo.userId();
    try {
      emit(FoundLoading(posts: state.posts, keyword: state.keyword));
      final posts = await _postRepo.searchPosts(
        userId,
        orderBy: orderBy,
        keyword: state.keyword,
      );
      emit(FoundLoaded(posts: posts, keyword: state.keyword));
    } on PlatformException catch (err) {
      emit(FoundError(
        message: err.message ?? 'Error load posts.',
        keyword: state.keyword,
        posts: state.posts,
      ));
    } catch (err) {
      emit(FoundError(
        message: 'Error load posts.',
        keyword: state.keyword,
        posts: state.posts,
      ));
    }
  }

  Future<void> likePost(String postId) async {
    final userId = _authRepo.userId();
    try {
      await _postRepo.likePost(userId: userId, postId: postId);
      emit(FoundLoaded(
        keyword: state.keyword,
        posts: state.posts!
            .map((e) => Post(
                  id: e.id,
                  content: e.content,
                  createdAt: e.createdAt,
                  likeCount: e.id == postId ? e.likeCount + 1 : e.likeCount,
                  isLiked: e.id == postId ? true : e.isLiked,
                  username: e.username,
                  authorId: e.authorId,
                  avatarUrl: e.avatarUrl,
                ))
            .toList(),
      ));
    } on PlatformException catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: err.message ?? 'Error like post.',
        posts: state.posts,
      ));
    } catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: 'Error like post.',
        posts: state.posts,
      ));
    }
  }

  Future<void> unlikePost(String postId) async {
    final userId = _authRepo.userId();
    try {
      await _postRepo.unlikePost(userId: userId, postId: postId);
      emit(FoundLoaded(
        keyword: state.keyword,
        posts: state.posts!
            .map((e) => Post(
                  id: e.id,
                  content: e.content,
                  createdAt: e.createdAt,
                  likeCount: e.id == postId ? e.likeCount - 1 : e.likeCount,
                  isLiked: e.id == postId ? false : e.isLiked,
                  username: e.username,
                  authorId: e.authorId,
                  avatarUrl: e.avatarUrl,
                ))
            .toList(),
      ));
    } on PlatformException catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: err.message ?? 'Error unlike post.',
        posts: state.posts,
      ));
    } catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: 'Error unlike post.',
        posts: state.posts,
      ));
    }
  }
}
