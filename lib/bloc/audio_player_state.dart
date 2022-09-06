// part of 'audio_player_bloc.dart';

// abstract class AudioPlayerState extends Equatable {
//   const AudioPlayerState();

//   @override
//   List<Object> get props => [];
// }

// class AudioPlayerLoading extends AudioPlayerState {
//   const AudioPlayerLoading();
//   @override
//   List<Object> get props => [];
// }

// class AudioPlayerInitial extends AudioPlayerState {
//   const AudioPlayerInitial();
//   @override
//   List<Object> get props => [];
// }

// class AudioPlayerReady extends AudioPlayerState {
//   final List<AudioPlayerModel> entityList;
//   const AudioPlayerReady(this.entityList);

//   @override
//   List<Object> get props => [entityList];
// }

// class AudioPlayerPlaying extends AudioPlayerState {
//   final List<AudioPlayerModel> entityList;
//   final AudioPlayerModel playingEntity;

//   const AudioPlayerPlaying(this.entityList, this.playingEntity);

//   @override
//   List<Object> get props => [entityList, playingEntity];
// }

// class AudioPlayerPaused extends AudioPlayerState {
//   final List<AudioPlayerModel> entityList;
//   final AudioPlayerModel pausedEntity;

//   const AudioPlayerPaused(this.entityList, this.pausedEntity);

//   @override
//   List<Object> get props => [pausedEntity];
// }

// class AudioPlayerFailure extends AudioPlayerState {
//   final String error;
//   const AudioPlayerFailure(this.error);

//   @override
//   List<Object> get props => [error];
// }
