import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/pal.dart';
import 'package:treehole/repositories/post.dart';

class CountsState {
  CountsState({
    this.postsCount,
    this.palsCount,
    this.likesCount,
  });

  final int? postsCount;
  final int? palsCount;
  final int? likesCount;

  CountsState update({
    int? postsCount,
    int? palsCount,
    int? likesCount,
  }) {
    return CountsState(
      postsCount: postsCount,
      palsCount: palsCount,
      likesCount: likesCount,
    );
  }
}

class CountsError extends CountsState {
  CountsError({required this.message});

  final String message;
}

class CountsCubit extends Cubit<CountsState> {
  CountsCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
    required PalRepository palRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        _palRepo = palRepo,
        super(CountsState());

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;
  final PalRepository _palRepo;

  Future<void> getCounts() async {
    final id = _authRepo.userId();
    try {
      final counts = await Future.wait([
        _postRepo.fetchPostsCountByAuthorId(id),
        _palRepo.fetchPalsCountByUserId(id),
      ]);
      emit(state.update(postsCount: counts[0], palsCount: counts[1]));
    } on PlatformException catch (err) {
      emit(CountsError(message: err.message ?? 'Get counts error.'));
    } catch (err) {
      emit(CountsError(message: 'Get counts error.'));
    }
  }
}
