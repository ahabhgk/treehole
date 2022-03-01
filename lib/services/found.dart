import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';

abstract class FoundState {
  FoundState({
    this.posts,
    required this.keyword,
    required this.page,
  });

  final List<Post>? posts;
  final String keyword;
  final int page;
}

class FoundLoading extends FoundState {
  FoundLoading({
    List<Post>? posts,
    required String keyword,
    required int page,
  }) : super(posts: posts, keyword: keyword, page: page);
}

class FoundError extends FoundState {
  FoundError({
    required this.message,
    List<Post>? posts,
    required String keyword,
    required int page,
  }) : super(posts: posts, keyword: keyword, page: page);

  final String message;
}

class FoundLoaded extends FoundState {
  FoundLoaded({
    required List<Post> posts,
    required String keyword,
    required int page,
  }) : super(posts: posts, keyword: keyword, page: page);
}

class FoundCubit extends Cubit<FoundState> {
  FoundCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        super(FoundLoading(keyword: '', page: 0));

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;

  Future<void> searchPosts(String? keyword) async {
    final userId = _authRepo.userId();
    try {
      emit(FoundLoading(
        posts: state.posts,
        keyword: state.keyword,
        page: state.page,
      ));
      final posts = await _postRepo.searchPosts(
        userId,
        orderBy: OrderBy.hot,
        keyword: keyword ?? state.keyword,
        page: 0,
      );
      emit(FoundLoaded(
        posts: posts,
        keyword: keyword ?? state.keyword,
        page: 0,
      ));
    } on PlatformException catch (err) {
      emit(FoundError(
        message: err.message ?? 'Error load posts.',
        keyword: state.keyword,
        posts: state.posts,
        page: state.page,
      ));
    } catch (err) {
      emit(FoundError(
        message: 'Error load posts.',
        keyword: state.keyword,
        posts: state.posts,
        page: state.page,
      ));
    }
  }

  Future<void> searchMorePosts() async {
    if (state is FoundLoaded) {
      final userId = _authRepo.userId();
      try {
        emit(FoundLoading(
          posts: state.posts,
          keyword: state.keyword,
          page: state.page,
        ));
        final morePosts = await _postRepo.searchPosts(
          userId,
          orderBy: OrderBy.hot,
          keyword: state.keyword,
          page: state.page + 1,
        );
        final posts = state.posts!..addAll(morePosts);
        final page = morePosts.isEmpty ? state.page : state.page + 1;
        emit(FoundLoaded(
          posts: posts,
          keyword: state.keyword,
          page: page,
        ));
      } on PlatformException catch (err) {
        emit(FoundError(
          message: err.message ?? 'Error load posts.',
          keyword: state.keyword,
          posts: state.posts,
          page: state.page,
        ));
      } catch (err) {
        emit(FoundError(
          message: 'Error load posts.',
          keyword: state.keyword,
          posts: state.posts,
          page: state.page,
        ));
      }
    }
  }

  Future<void> likePost(String postId) async {
    final userId = _authRepo.userId();
    try {
      await _postRepo.likePost(userId: userId, postId: postId);
      emit(FoundLoaded(
        page: state.page,
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
                  permission: e.permission,
                ))
            .toList(),
      ));
    } on PlatformException catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: err.message ?? 'Error like post.',
        posts: state.posts,
        page: state.page,
      ));
    } catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: 'Error like post.',
        posts: state.posts,
        page: state.page,
      ));
    }
  }

  Future<void> unlikePost(String postId) async {
    final userId = _authRepo.userId();
    try {
      await _postRepo.unlikePost(userId: userId, postId: postId);
      emit(FoundLoaded(
        page: state.page,
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
                  permission: e.permission,
                ))
            .toList(),
      ));
    } on PlatformException catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: err.message ?? 'Error unlike post.',
        posts: state.posts,
        page: state.page,
      ));
    } catch (err) {
      emit(FoundError(
        keyword: state.keyword,
        message: 'Error unlike post.',
        posts: state.posts,
        page: state.page,
      ));
    }
  }
}
