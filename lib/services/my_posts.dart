import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';

abstract class MyPostsState {}

class MyPostsInitial extends MyPostsState {}

class MyPostsLoading extends MyPostsState {}

class MyPostsLoaded extends MyPostsState {
  MyPostsLoaded({required this.posts});

  final List<Post> posts;
}

class MyPostsLoadError extends MyPostsState {
  MyPostsLoadError({required this.message});

  final String message;
}

class MyPostsCubit extends Cubit<MyPostsState> {
  MyPostsCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        super(MyPostsInitial());

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;

  Future<void> loadMyPosts() async {
    final authorId = _authRepo.userId();
    try {
      emit(MyPostsLoading());
      final posts = await _postRepo.fetchPostsByAuthorId(authorId);
      emit(MyPostsLoaded(posts: posts));
    } on PlatformException catch (err) {
      emit(MyPostsLoadError(message: err.message ?? 'Error get user posts.'));
    } catch (err) {
      emit(MyPostsLoadError(message: 'Error get user posts.'));
    }
  }
}
