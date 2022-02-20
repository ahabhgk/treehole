import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';

abstract class FoundState {
  FoundState({this.posts});

  final List<Post>? posts;
}

class FoundLoading extends FoundState {
  FoundLoading({List<Post>? posts}) : super(posts: posts);
}

class FoundError extends FoundState {
  FoundError({
    required this.message,
    List<Post>? posts,
  }) : super(posts: posts);

  final String message;
}

class FoundLoaded extends FoundState {
  FoundLoaded({required List<Post> posts}) : super(posts: posts);
}

class FoundCubit extends Cubit<FoundState> {
  FoundCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        super(FoundLoading());

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;

  Future<void> loadFoundPosts({
    String? keyword,
    required OrderBy orderBy,
  }) async {
    final userId = _authRepo.userId();
    try {
      emit(FoundLoading(
          posts: keyword == null
              ? state.posts
              : null)); // search need clear last result
      final posts = await _postRepo.fetchFoundPosts(userId,
          orderBy: orderBy, keyword: keyword);
      emit(FoundLoaded(posts: posts));
    } on PlatformException catch (err) {
      emit(FoundError(
        message: err.message ?? 'Error load posts.',
        posts: state.posts,
      ));
    } catch (err) {
      emit(FoundError(
        message: 'Error load posts.',
        posts: state.posts,
      ));
    }
  }
}
