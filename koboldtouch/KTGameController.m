//
//  KKGameController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 22.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTGameController.h"
#import "KTModel.h"
#import "KTSceneViewController.h"
#import "KTStepInfo.h"
#import "KTGameModel.h"
#import "KTDebugController.h"
#import "KTArchiveController.h"

#import "CCDirector.h"
#import "CCScheduler.h"
#import "CCTransition.h"
#import "CCTransitionPageTurn.h"
#import "CCTransitionProgress.h"


@implementation KTPresentNextScene
-(id) initWithSceneViewController:(KTSceneViewController*)nextSceneViewController
				   transitionType:(KTSceneTransitionType)transitionType
			   transitionDuration:(float)transitionDuration;
{
	self = [super init];
	if (self)
	{
		_nextSceneViewController = nextSceneViewController;
		_transitionType = transitionType;
		_transitionDuration = transitionDuration;
	}
	return self;
}
@end


@implementation KTGameController

__weak static KTGameController* _gameControllerInstance = nil;
+(KTGameController*) sharedGameController
{
	return _gameControllerInstance;
}

+(id) gameControllerWithGameModel:(KTGameModel*)gameModel
{
	return [[self alloc] initWithGameModel:gameModel];
}

+(id) gameController
{
	return [[self alloc] initWithGameModel:nil];
}

-(id) initWithGameModel:(KTGameModel*)gameModel
{
	self = [super init];
	if (self)
	{
		_gameControllerInstance = self;
		
		if (gameModel == nil)
		{
			gameModel = [KTGameModel model];
		}
		[self internal_setModel:gameModel];
		[self internal_setGameController:self];
		[gameModel load];
		
		_sceneViewControllers = [NSMutableDictionary dictionaryWithCapacity:4];
		_stepInfo = [[KTStepInfo alloc] init];
		_director = [CCDirector sharedDirector];
		_pauseScenesDuringTransition = YES;

		[_director.scheduler scheduleUpdateForTarget:self priority:0 paused:NO];
		
		[self addDefaultControllers];
	}
	return self;
}

-(void) dealloc
{
	NSLog(@"dealloc: %@", self);
	[_director.scheduler unscheduleUpdateForTarget:self];
	_gameControllerInstance = nil;
}

#pragma mark Standard Controllers

-(void) addDefaultControllers
{
	[self addSubController:[KTArchiveController controller]];
	[self addSubController:[KTDebugController controller]];
}

#pragma mark Paused

-(void) setPaused:(BOOL)paused
{
	[super setPaused:paused];
	
	// synchronize with director
	if (paused)
	{
		[_director stopAnimation];
	}
	else
	{
		[_director startAnimation];
	}
}

#pragma mark SceneViewControllers

@dynamic presentedSceneViewController;
-(KTSceneViewController*) presentedSceneViewController
{
	KTController* controller = [self.subControllers objectAtIndex:0];
	if ([controller isKindOfClass:[KTSceneViewController class]])
	{
		return (KTSceneViewController*)controller;
	}
	return nil;
}

/*
-(void) addSceneViewController:(KTSceneViewController*)sceneViewController withName:(NSString*)name
{
	NSAssert1([_sceneViewControllers objectForKey:name] == nil,
			  @"A scene view controller with name '%@' already exists!", name);
	[_sceneViewControllers setObject:sceneViewController forKey:name];
}

-(KTSceneViewController*) sceneViewControllerForName:(NSString*)name
{
	return [_sceneViewControllers objectForKey:name];
}
 */

#pragma mark SceneWill/DidChange
-(void) sendSceneWillChangeToController:(KTController*)controller
{
	for (KTController* subController in controller.subControllers)
	{
		[self sendSceneWillChangeToController:subController];
	}

	[controller sceneWillChange];
}

-(void) sendSceneDidChangeToController:(KTController*)controller
{
	for (KTController* subController in controller.subControllers)
	{
		[self sendSceneDidChangeToController:subController];
	}
	
	[controller sceneDidChange];
}

#pragma mark Present/Transition Scene

-(void) internal_presentScene:(CCScene*)scene
{
	if (_director.runningScene)
	{
		[_director replaceScene:scene];
	}
	else
	{
		[_director runWithScene:scene];
	}
}

// this method ensures that scene view controller is always the first controller of game controller's subcontrollers
-(void) internal_replacePresentedSceneViewController:(KTSceneViewController*)oldSceneViewController
									  withController:(KTSceneViewController*)newSceneViewController
{
	[self sendSceneWillChangeToController:self];

	[self removeSubController:oldSceneViewController];
	[self internal_addSubController:newSceneViewController insertAsFirstController:YES];
	
	[self sendSceneDidChangeToController:self];
}

-(void) internal_presentNextScene
{
	NSAssert(_presentNextScene, @"_presentNextScene is nil");
	NSAssert(_presentNextScene.nextSceneViewController, @"_presentNextScene.nextSceneViewController is nil!");
	NSAssert1(_previousSceneViewController == nil, @"_previousSceneViewController is not nil (%@)", _previousSceneViewController);

	KTSceneViewController* sceneViewController = _presentNextScene.nextSceneViewController;
	
	// can not present the same scene view controller again (just like in cocos2d)
	NSAssert1(self.presentedSceneViewController != sceneViewController,
			  @"can't present currently presented scene view controller (%@) again!", sceneViewController);
	
	[self internal_setSceneViewController:sceneViewController];
	[sceneViewController internal_setParentController:self];
	[sceneViewController internal_setSceneViewController:sceneViewController];
	[sceneViewController internal_setGameController:self];
	
	_previousSceneViewController = self.presentedSceneViewController;
	[_previousSceneViewController internal_viewWillDisappear];
	[self internal_replacePresentedSceneViewController:_previousSceneViewController
										withController:sceneViewController];
	
	CCTransitionScene* transition = [self transitionSceneWithScene:sceneViewController.scene
													transitionType:_presentNextScene.transitionType
														  duration:_presentNextScene.transitionDuration];

	// let go before replacing scene, otherwise scene may be attempted to change again in next update
	_presentNextScene = nil;
	
	if (transition)
	{
		[self internal_presentScene:transition];
		_previousSceneViewController.paused = _pauseScenesDuringTransition;
		sceneViewController.paused = _pauseScenesDuringTransition;
	}
	else
	{
		[self internal_presentScene:sceneViewController.scene];
	}
}

-(void) presentSceneViewController:(KTSceneViewController*)sceneViewController
{
	[self presentSceneViewController:sceneViewController transitionType:KTSceneTransitionTypeNone transitionDuration:0.0f];
}

-(void) presentSceneViewController:(KTSceneViewController*)sceneViewController
					transitionType:(KTSceneTransitionType)transitionType
				transitionDuration:(float)transitionDuration
{
	if (sceneViewController)
	{
		if (_previousSceneViewController == nil)
		{
			NSAssert(_presentNextScene == nil,
					 @"can't present scene view controller (%@), game controller already preparing to present a scene (%@) this frame!",
					 sceneViewController, _presentNextScene);
			_presentNextScene = [[KTPresentNextScene alloc] initWithSceneViewController:sceneViewController transitionType:transitionType transitionDuration:transitionDuration];
			
			// if no scene is running we can present the scene right away
			if (self.presentedSceneViewController == nil)
			{
				[self internal_presentNextScene];
			}
		}
		else
		{
			NSLog(@"WARNING: can't present sceneViewController (%@)! Reason: scene transition currently in progress", sceneViewController);
		}
	}
}

-(CCTransitionScene*) transitionSceneWithScene:(CCScene*)scene
								transitionType:(KTSceneTransitionType)transitionType
									  duration:(float)duration
{
	NSAssert(scene, @"destination scene is nil");
	
	// switch over scene transitions here via transitionType
	CCTransitionScene* transition = nil;
	
	switch (transitionType)
	{
		case KTSceneTransitionTypeNone:
			break;
		case KTSceneTransitionTypeFade:
			transition = [CCTransitionFade transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeCrossFade:
			transition = [CCTransitionCrossFade transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeFadeFromBottomLeft:
			transition = [CCTransitionFadeTR transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeFadeFromTopRight:
			transition = [CCTransitionFadeBL transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeFadeUpwards:
			transition = [CCTransitionFadeUp transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeFadeDownwards:
			transition = [CCTransitionFadeDown transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeJumpAndZoom:
			transition = [CCTransitionJumpZoom transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeMoveInFromLeft:
			transition = [CCTransitionMoveInL transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeMoveInFromRight:
			transition = [CCTransitionMoveInR transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeMoveInFromTop:
			transition = [CCTransitionMoveInT transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeMoveInFromBottom:
			transition = [CCTransitionMoveInB transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypePageTurnFromLeft:
			transition = [CCTransitionPageTurn transitionWithDuration:duration scene:scene backwards:YES];
			break;
		case KTSceneTransitionTypePageTurnFromRight:
			transition = [CCTransitionPageTurn transitionWithDuration:duration scene:scene backwards:NO];
			break;
		case KTSceneTransitionTypeProgressRadialClockwise:
			transition = [CCTransitionProgressRadialCW transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeProgressRadialCounterClockwise:
			transition = [CCTransitionProgressRadialCCW transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeProgressHorizontal:
			transition = [CCTransitionProgressHorizontal transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeProgressVertical:
			transition = [CCTransitionProgressVertical transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeProgressInOut:
			transition = [CCTransitionProgressInOut transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeProgressOutIn:
			transition = [CCTransitionProgressOutIn transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeRotateAndZoom:
			transition = [CCTransitionRotoZoom transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeFlipAngularFromBottomLeft:
			transition = [CCTransitionFlipAngular transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationRightOver];
			break;
		case KTSceneTransitionTypeFlipAngularFromTopRight:
			transition = [CCTransitionFlipAngular transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationLeftOver];
			break;
		case KTSceneTransitionTypeZoomAndFlipAngularFromBottomLeft:
			transition = [CCTransitionZoomFlipAngular transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationRightOver];
			break;
		case KTSceneTransitionTypeZoomAndFlipAngularFromTopRight:
			transition = [CCTransitionZoomFlipAngular transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationLeftOver];
			break;
		case KTSceneTransitionTypeFlipHorizontalFromLeft:
			transition = [CCTransitionFlipX transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationLeftOver];
			break;
		case KTSceneTransitionTypeFlipHorizontalFromRight:
			transition = [CCTransitionFlipX transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationRightOver];
			break;
		case KTSceneTransitionTypeFlipVerticalFromTop:
			transition = [CCTransitionFlipY transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationUpOver];
			break;
		case KTSceneTransitionTypeFlipVerticalFromBottom:
			transition = [CCTransitionFlipY transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationDownOver];
			break;
		case KTSceneTransitionTypeZoomAndFlipHorizontalFromLeft:
			transition = [CCTransitionZoomFlipX transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationLeftOver];
			break;
		case KTSceneTransitionTypeZoomAndFlipHorizontalFromRight:
			transition = [CCTransitionZoomFlipX transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationRightOver];
			break;
		case KTSceneTransitionTypeZoomAndFlipVerticalFromTop:
			transition = [CCTransitionZoomFlipY transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationUpOver];
			break;
		case KTSceneTransitionTypeZoomAndFlipVerticalFromBottom:
			transition = [CCTransitionZoomFlipY transitionWithDuration:duration scene:scene orientation:kCCTransitionOrientationDownOver];
			break;
		case KTSceneTransitionTypeShrinkAndGrow:
			transition = [CCTransitionShrinkGrow transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeSlideInFromLeft:
			transition = [CCTransitionSlideInL transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeSlideInFromRight:
			transition = [CCTransitionSlideInR transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeSlideInFromTop:
			transition = [CCTransitionSlideInT transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeSlideInFromBottom:
			transition = [CCTransitionSlideInB transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeSplitColumns:
			transition = [CCTransitionSplitCols transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeSplitRows:
			transition = [CCTransitionSplitRows transitionWithDuration:duration scene:scene];
			break;
		case KTSceneTransitionTypeTurnOffTiles:
			transition = [CCTransitionTurnOffTiles transitionWithDuration:duration scene:scene];
			break;
			
		default:
			[NSException raise:@"unhandled transition type" format:@"the transition type %i is not handled in switch statement", transitionType];
			break;
	}
	
	return transition;
}

#pragma mark Update/Step

-(void) performModelStepSelector:(SEL)stepSelector onController:(KTController*)controller
{
	if (controller.paused == NO)
	{
		KTModel* model = controller.model;
		if (model.nextStep <= _currentStep && [model internal_implementsStepSelector:stepSelector])
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[model performSelector:stepSelector withObject:_stepInfo];
#pragma clang diagnostic pop
		}
		
		NSArray* subControllers = controller.subControllers;
		for (KTController* subController in subControllers)
		{
			[self performModelStepSelector:stepSelector onController:subController];
		}
	}
}

-(void) performControllerStepSelector:(SEL)stepSelector onController:(KTController*)controller
{
	if (controller.paused == NO)
	{
		if (controller.nextStep <= _currentStep && [controller internal_implementsStepSelector:stepSelector])
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[controller performSelector:stepSelector withObject:_stepInfo];
#pragma clang diagnostic pop
		}
		
		NSArray* subControllers = controller.subControllers;
		for (KTController* subController in subControllers)
		{
			[self performControllerStepSelector:stepSelector onController:subController];
		}
	}
}


-(void) performStepSelector:(SEL)stepSelector onController:(KTController*)controller
{
	[self performModelStepSelector:stepSelector onController:controller];
	[self performControllerStepSelector:stepSelector onController:controller];
}

-(void) update:(float)deltaTime
{
	// Trigger recursive updates of all controllers and their models.
	// Note: by design the scene view controller receives each step message before the game controller's subcontrollers,
	// because the scene view controller always is at index 0 of the subControllers list
	[_stepInfo internal_setStepDeltaTime:deltaTime currentStep:_currentStep];
	[self performStepSelector:@selector(beforeStep:) onController:self];
	[self performStepSelector:@selector(step:) onController:self];
	[self performStepSelector:@selector(afterStep:) onController:self];
	
	// also update previous (currently transitioning away) scene controller if not paused
	if (_previousSceneViewController && _previousSceneViewController.paused == NO)
	{
		[self performStepSelector:@selector(beforeStep:) onController:_previousSceneViewController];
		[self performStepSelector:@selector(step:) onController:_previousSceneViewController];
		[self performStepSelector:@selector(afterStep:) onController:_previousSceneViewController];
	}

	if (_presentNextScene != nil)
	{
		[self internal_presentNextScene];
	}

	if (_sceneViewControllerDeallocationCheck)
	{
		NSLog(@" >>> POSSIBLE RETAIN CYCLE DETECTED!!! <<<  Previous sceneViewController (%@) did not deallocate! Object graph:\n%@",
			  _sceneViewControllerDeallocationCheck, [self.debugController objectGraph]);
	}

	_currentStep++;
}

@dynamic appSupportDirectory;
-(NSString*) appSupportDirectory
{
	if (_appSupportDirectory == nil)
	{
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString* appSupportPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
		NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
		NSAssert(appSupportPath, @"app support path is nil!");
		NSAssert(bundleName, @"bundle name (CFBundleName) is nil!");

		_appSupportDirectory = [NSString stringWithFormat:@"%@/%@", appSupportPath, bundleName];
		NSLog(@"app support directory: '%@'", _appSupportDirectory);
		
		// make sure the directory exists and is writable
		NSFileManager* fileManager = [NSFileManager defaultManager];
		BOOL isDir = YES;
		BOOL pathExists = [fileManager fileExistsAtPath:_appSupportDirectory isDirectory:&isDir];

		if (pathExists == NO)
		{
			// create it
			NSError* error = nil;
			if ([fileManager createDirectoryAtPath:_appSupportDirectory withIntermediateDirectories:YES attributes:nil error:&error] == NO)
			{
				[NSException raise:@"could not create app support directory!" format:@"Reason: %@", error];
			}
		}
		else if (isDir == NO)
		{
			// if it exists, it has to be a directory!
			[NSException raise:@"app support directory is a file!" format:@"app support directory is a file: '%@'", _appSupportDirectory];
		}
	}
	
	return _appSupportDirectory;
}

@dynamic isSceneTransitionScheduled;
-(BOOL) isSceneTransitionScheduled
{
	return (_presentNextScene != nil);
}

#pragma mark Quick-Access Controller Properties

-(KTDebugController*) debugController
{
	return (KTDebugController*)[self subControllerByClass:[KTDebugController class]];
}
-(KTArchiveController*) archiveController
{
	return (KTArchiveController*)[self subControllerByClass:[KTArchiveController class]];
}
@end
