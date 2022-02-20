import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
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
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        super(FeedLoading());

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;

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
}
