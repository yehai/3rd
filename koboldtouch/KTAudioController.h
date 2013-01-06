//
//  KTAudioController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 24.09.12.
//
//

#import "KTController.h"

/* protocol
	audioDidPause
	audioDidResume
	musicDidFinishPlaying:(KTAudioMusic*)music;
	musicDidStartPlaying:(KTAudioMusic*)music;
 */

@interface KTAudioSource : NSObject
@property (nonatomic) NSString* file;
@property (nonatomic) NSTimeInterval length;
@property (nonatomic) BOOL loop;
@end

@interface KTAudioEffect : KTAudioSource
@property (nonatomic) int preferredChannel;
@property (nonatomic) float pitch;
@property (nonatomic) float pan;
@property (nonatomic) float gain;
@end

@interface KTAudioMusic : KTAudioSource
@end

@interface KTAudioChannel : NSObject
@property (nonatomic) float volume;
@property (nonatomic) BOOL muted;
@end

/** Stub: this will be the base audio controller, defining the audio API.
 Methods like preload, unload, play, pause, stop, resume, effect, music with predefined parameters all audio
 controllers must support, regardless of whether they use CocosDenshion, ObjectAL or a different sound engine. */
@interface KTAudioController : KTController

@property (nonatomic) NSArray* channels;
@property (nonatomic) float masterVolume;
@property (nonatomic) float musicVolume;
@property (nonatomic) float effectVolume;
@property (nonatomic) BOOL audioMuted;
@property (nonatomic) BOOL otherAudioPlaying;
@property (nonatomic, readonly) BOOL deviceMuted;
// fade, pan, pitch, gain interpolation
// loop count

/*
 -(void) preloadMusic:(KTAudioMusic*)music;
-(void) playMusic:(KTAudioMusic*)music;
-(void) queueMusic:(KTAudioMusic*)music;
-(void) playMusicQueue;
-(void) playNextMusicInQueue;
-(void) stopMusic;
-(void) pauseMusic;
// TODO: restart music (rewind)

-(void) preloadEffect:(KTAudioEffect*)effect;
-(void) playEffect:(KTAudioEffect*)effect;
*/
// TODO: setup channels: number, mixing or replacing, play effect on free channel, effect priority (cancel existing)

@end
