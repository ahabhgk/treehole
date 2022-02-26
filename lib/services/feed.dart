import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';

abstract class FeedState {
  FeedState({this.posts, required this.page});

  final List<Post>? posts;
  final int page;
}

class FeedLoading extends FeedState {
  FeedLoading({
    List<Post>? posts,
    required page,
  }) : super(posts: posts, page: page);
}

class FeedError extends FeedState {
  FeedError({
    required this.message,
    List<Post>? posts,
    required page,
  }) : super(posts: posts, page: page);

  final String message;
}

class FeedLoaded extends FeedState {
  FeedLoaded({
    required List<Post> posts,
    required page,
  }) : super(posts: posts, page: page);
}

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        super(FeedLoading(page: 0));

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;

  Future<void> loadFeeds() async {
    final userId = _authRepo.userId();
    try {
      emit(FeedLoading(posts: state.posts, page: state.page));
      final posts = await _postRepo.fetchFeedPosts(userId, 0);
      emit(FeedLoaded(posts: posts, page: 0));
    } on PlatformException catch (err) {
      emit(FeedError(
        message: err.message ?? 'Error get user posts.',
        posts: state.posts,
        page: state.page,
      ));
    } catch (err) {
      emit(FeedError(
        message: 'Error get user posts.',
        posts: state.posts,
        page: state.page,
      ));
    }
  }

  Future<void> loadMoreFeeds() async {
    if (state is FeedLoaded) {
      final userId = _authRepo.userId();
      try {
        emit(FeedLoading(posts: state.posts, page: state.page));
        final morePosts =
            await _postRepo.fetchFeedPosts(userId, state.page + 1);
        final posts = state.posts!..addAll(morePosts);
        final page = morePosts.isEmpty ? state.page : state.page + 1;
        emit(FeedLoaded(posts: posts, page: page));
      } on PlatformException catch (err) {
        emit(FeedError(
          message: err.message ?? 'Error get user posts.',
          posts: state.posts,
          page: state.page,
        ));
      } catch (err) {
        emit(FeedError(
          message: 'Error get user posts.',
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
      emit(FeedLoaded(
        page: state.page,
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
      emit(FeedError(
        message: err.message ?? 'Error like post.',
        posts: state.posts,
        page: state.page,
      ));
    } catch (err) {
      emit(FeedError(
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
      emit(FeedLoaded(
        page: state.page,
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
      emit(FeedError(
        message: err.message ?? 'Error unlike post.',
        posts: state.posts,
        page: state.page,
      ));
    } catch (err) {
      emit(FeedError(
        message: 'Error unlike post.',
        posts: state.posts,
        page: state.page,
      ));
    }
  }
}
