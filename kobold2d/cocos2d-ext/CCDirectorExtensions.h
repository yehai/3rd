/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import <Availability.h>
#import "cocos2d.h"

typedef enum
{
	KKTargetPlatformUnknown = 0,
	KKTargetPlatformIOS,
	KKTargetPlatformMac,
} KKTargetPlatform;

/** extends CCDirector */
@interface CCDirector (KoboldExtensions)

/** Gives you the window center position (in points), ie half of the screen size */
@property (nonatomic, readonly) CGPoint windowCenter;
/** Gives you the window center position (in pixels), ie half of the screen size */
@property (nonatomic, readonly) CGPoint windowCenterInPixels;
/** Gives you the window size as a CGRect (in points) spanning from 0, 0 to screenWidth, screenHeight */
@property (nonatomic, readonly) CGRect windowRect;
/** Gives you the window size as a CGRect (in pixels) spanning from 0, 0 to screenWidth, screenHeight */
@property (nonatomic, readonly) CGRect windowRectInPixels;
/** Gives you the window size as a CGSize struct (in points) */
@property (nonatomic, readonly) CGSize windowSize;
/** Gives you the window size as a CGSize struct (in pixels) */
@property (nonatomic, readonly) CGSize windowSizeInPixels;
/** Gives you the window size as a CGPoint struct (in points) */
@property (nonatomic, readonly) CGPoint windowSizeAsPoint;
/** Gives you the window size as a CGPoint struct (in pixels) */
@property (nonatomic, readonly) CGPoint windowSizeAsPointInPixels;
/** Checks if the scene stack is still empty, which means runWithScene hasn't been called yet. */
@property (nonatomic, readonly) BOOL isSceneStackEmpty;
/** Tells you if the app is currently running on iOS. */
@property (nonatomic, readonly) BOOL currentPlatformIsIOS;
/** Tells you if the app is currently running on Mac. */
@property (nonatomic, readonly) BOOL currentPlatformIsMac;
/** Tells you if the app is currently running in the iPhone/iPad Simulator. */
@property (nonatomic, readonly) BOOL currentDeviceIsSimulator;
/** Tells you if the app is currently running on the iPad rather than iPhone or iPod Touch. */
@property (nonatomic, readonly) BOOL currentDeviceIsIPad;
/** Returns the number of frames drawn since the start of the app. You can use this to check if certain events occured
 in the same frame, to ensure that something happens exactly n frames from now regardless of framerate, or to implement
 a custom framerate display. The frameCount variable is never reset at runtime, only when the app is restarted. 
 An overflow occurs if the app remains running for over 828 days of continuous operation, assuming a steady 60 frames per second. */
@property (nonatomic, readonly) NSUInteger frameCount;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
/** Tells you whether Retina Display is currently enabled. It does not tell you if the device you're running has a Retina display. 
 it could be a Retina device but Retina display may simply not be enabled. */
-(BOOL) isRetinaDisplayEnabled;

/** Gives you the inverse of the scale factor: 1.0f / contentScaleFactor */
-(float) contentScaleFactorInverse;
/** Gives you the scale factor halved: contentScaleFactor * 0.5f */
-(float) contentScaleFactorHalved;
#endif

@end

@interface CCDirector (SwizzledMethods)
-(void) mainLoopReplacement;
-(void) mainLoopReplacement:(id)sender;
-(void) replaceSceneReplacement:(CCScene*)scene;
-(void) runWithSceneReplacement:(CCScene*)scene;
-(void) pushSceneReplacement:(CCScene*)scene;
-(void) popSceneReplacement;
@end

#ifdef KK_PLATFORM_IOS
@interface CCDirectorDisplayLink (KoboldExtensions)
-(CADisplayLink*) displayLink;
@end
#endif
