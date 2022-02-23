import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/like.dart';
import 'package:treehole/repositories/post.dart';

abstract class FeedState {
  FeedState({this.posts});

  final List<Post>? posts;
}

class FeedLoading extends FeedState {
  FeedLoading({List<Post>? posts}) : super(posts: posts);
}

class FeedError extends FeedState {
  FeedError({
    required this.message,
    List<Post>? posts,
  }) : super(posts: posts);

  final String message;
}

class FeedLoaded extends FeedState {
  FeedLoaded({required List<Post> posts}) : super(posts: posts);
}

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
    required LikeRepository likeRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        _likeRepo = likeRepo,
        super(FeedLoading());

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;
  final LikeRepository _likeRepo;

  Future<void> loadFeeds() async {
    final userId = _authRepo.userId();
    try {
      emit(FeedLoading(posts: state.posts));
      final posts = await _postRepo.fetchFeedPosts(userId);
      emit(FeedLoaded(posts: posts));
    } on PlatformException catch (err) {
      emit(FeedError(
        message: err.message ?? 'Error get user posts.',
        posts: state.posts,
      ));
    } catch (err) {
      emit(FeedError(
        message: 'Error get user posts.',
        posts: state.posts,
      ));
    }
  }

  Future<void> likePost(String postId) async {
    final userId = _authRepo.userId();
    try {
      await _likeRepo.likePost(userId: userId, postId: postId);
      emit(FeedLoaded(
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
      ));
    } catch (err) {
      emit(FeedError(
        message: 'Error like post.',
        posts: state.posts,
      ));
    }
  }

  Future<void> unlikePost(String postId) async {
    final userId = _authRepo.userId();
    try {
      await _likeRepo.unlikePost(userId: userId, postId: postId);
      emit(FeedLoaded(
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
      ));
    } catch (err) {
      emit(FeedError(
        message: 'Error unlike post.',
        posts: state.posts,
      ));
    }
  }
}
