//
//  KKGameController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 22.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTSceneTransitionTypes.h"
#import "KTController.h"

@class KTSceneViewController;
@class KTDebugController;
@class KTArchiveController;
@class KTMultiTouchController;
@class KTMotionController;
@class KTGameModel;
@class KTStepInfo;
@class CCDirector;
@class CCScene;
@class CCTransitionScene;

// internal use, stores information needed for changing a scene until the current scene's step has ended
@interface KTPresentNextScene : NSObject
-(id) initWithSceneViewController:(KTSceneViewController*)nextSceneViewController
				   transitionType:(KTSceneTransitionType)transitionType
			   transitionDuration:(float)transitionDuration;
@property (nonatomic, readonly) KTSceneViewController* nextSceneViewController;
@property (nonatomic, readonly) KTSceneTransitionType transitionType;
@property (nonatomic, readonly) float transitionDuration;
@end

/** The game controller manages all global aspects of your game: scenes, global data, audio, game center, preferences
 and every other controller or model that is commonly used or needed by all scenes of your game.
 
 In a Kobold Touch app, the game controller is the only class that can initiate a scene change/transition. 
 You must NOT use the CCDirector scene change methods (replaceScene, pushScene, popScene).
 
 Tip: if you pause/resume the game controller, it will stop the CADisplayLink from updating cocos2d. Pausing the
 game controller should only be performed if you enter a fullscreen UIKit view.
 */
@interface KTGameController : KTController
{
@protected
	NSMutableDictionary* _sceneViewControllers;
@private
	NSString* _appSupportDirectory;
	KTPresentNextScene* _presentNextScene;
	__weak KTSceneViewController* _previousSceneViewController;
	KTStepInfo* _stepInfo;
	CCDirector* _director;
}

/** The current step counter. This is the number of steps that have been executed since the app started. */
@property (nonatomic) NSUInteger currentStep;

/** Returns the path to the application support directory. This is where you should store any application specific data, like savegames. */
@property (nonatomic, readonly) NSString* appSupportDirectory;

/** When presenting a new scene with a transition, both scenes are paused by default (ie not animating). By setting this property
 to NO you can have both scenes continue to animate while the transition occurs. Experimental. Defaults to YES (behaves like cocos2d). */
@property (nonatomic) BOOL pauseScenesDuringTransition;

/** Is YES if a scene transition is scheduled to occur at the end of the frame. Check this to avoid accidentally presenting two or more
 scene view controllers in the same frame. */
@property (nonatomic, readonly) BOOL isSceneTransitionScheduled;

/** A dictionary that contains all registered scene controllers. */
//@property (nonatomic, readonly) NSDictionary* sceneViewControllers;

/** This is the currently presented (running) scene view controller, whose scene is currently displayed. 
 Is nil until the first scene view controller has been presented. */
@property (nonatomic, readonly) KTSceneViewController* presentedSceneViewController;

/** Returns the debug controller instance. May be nil, specifically in release builds. */
@property (nonatomic, readonly, weak) KTDebugController* debugController;
/** Returns the save/load controller instance. */
@property (nonatomic, readonly, weak) KTArchiveController* archiveController;

/** Returns a new instance of KTGameController with default game model. */
+(id) gameController;
/** Returns a new instance of KTGameController with a game model. */
+(id) gameControllerWithGameModel:(KTGameModel*)gameModel;
/** Returns a new instance of KTGameController with a game model. */
-(id) initWithGameModel:(KTGameModel*)gameModel;

/** Returns the single instance of game controller. Game Controller must be initialized before calling this method, this method is NOT a singleton initializer. */
+(KTGameController*) sharedGameController;

/** Presents the given scene view controller. This replaces the currently presented scene view controller with
 the new one. Internally it will run the cocos2d scene or replace the currently running scene. No transition is used. */
-(void) presentSceneViewController:(KTSceneViewController*)sceneViewController;

/** Presents the given scene view controller with a transition. You specify the type of transition (uses the corresponding
 CCTransitionScene class) and duration of the transition. */
-(void) presentSceneViewController:(KTSceneViewController*)sceneViewController
					transitionType:(KTSceneTransitionType)transitionType
				transitionDuration:(float)transitionDuration;

// test retain cycle detection
@property (nonatomic, weak) KTSceneViewController* sceneViewControllerDeallocationCheck;

@end
