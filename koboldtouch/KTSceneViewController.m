//
//  KTSceneViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 22.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTSceneViewController.h"
#import "KTGameController.h"
#import "KTPhysicsController.h"
#import "KTModel.h"
#import "KTSceneModel.h"
#import "KTMultiTouchController.h"
#import "KTMotionController.h"

#import "CCScene.h"
#import "CCDirector.h"

@interface KTSceneViewController (Internal)
-(void) internal_viewDidDisappear;
@end


@interface KTCCScene : CCScene
@property (nonatomic) KTSceneViewController* sceneViewController;
@end

@implementation KTCCScene
/*
-(void) addChild:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag
{
	NSLog(@"scene add child: %@", node);
	[super addChild:node z:z tag:tag];
}
 */
-(void) onEnter
{
	[super onEnter];
	BOOL pause = self.sceneViewController.gameController.pauseScenesDuringTransition;
	self.sceneViewController.paused = pause;
	[self.sceneViewController internal_pauseActions:pause];
}
-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	self.sceneViewController.paused = NO;
	[self.sceneViewController internal_pauseActions:NO];
}
-(void) onExitTransitionDidStart
{
	[super onExitTransitionDidStart];
	BOOL pause = self.sceneViewController.gameController.pauseScenesDuringTransition;
	self.sceneViewController.paused = pause;
	[self.sceneViewController internal_pauseActions:pause];
}
-(void) onExit
{
	[super onExit];
	self.sceneViewController.paused = NO;
	[self.sceneViewController internal_pauseActions:NO];
}
-(void) cleanup
{
	// inform about cleanup, which for scenes only occurs when the scene has been replaced by another
	[self.sceneViewController internal_viewDidDisappear];

	[super cleanup];
}
-(void) dealloc
{
	NSLog(@"dealloc: %@", self);
}
@end



@implementation KTSceneViewController

+(id) sceneViewControllerWithSceneModel:(KTSceneModel*)sceneModel
{
	return [[self alloc] initWithSceneModel:sceneModel];
}

+(id) controller
{
	return [[self alloc] initWithSceneModel:nil];
}

-(id) init
{
	return [self initWithSceneModel:nil];
}

-(id) initWithSceneModel:(KTSceneModel*)sceneModel
{
	// must be done before [super init] to ensure default controllers are added before initWithDefaults runs
	[self addDefaultControllersAndModel:sceneModel];
	_isSceneViewController = YES;

	// while init runs, it also runs initWithDefaults which is why some things need to be set above this line
	self = [super init];
	
	if (self)
	{
		[sceneModel load];
	}
	return self;
}

-(void) raiseSceneDidNotDeallocateException
{
	if (self.rootNode != nil)
	{
		[NSException raise:@"\n\n\n============= SCENE DID NOT DEALLOCATE! =============" format:@"\nThe scene %@ of scene view controller %@ did not \
deallocate.\n1) This could indicate a potentially serious issue (retain cycle, memory leak).\n2) It could also be a design issue \
(ie singleton referencing scene) that might break the MVC design of KoboldTouch. Always allow scenes to be released when presenting a new scene! \
To persist state, use the game controller's model object.\n3) Presenting two scenes in the same frame will also cause this error (it's a cocos2d issue). \
You have to wait 1 frame before presenting another scene.\n\n", self.scene, self];
	}
}

-(void) dealloc
{
	[self raiseSceneDidNotDeallocateException];
	
	if (self.gameController.sceneViewControllerDeallocationCheck)
	{
		NSAssert2(self.gameController.sceneViewControllerDeallocationCheck == self,
				  @"presented scene controller (%@) could not de-register from game controller because another scene controller (%@) is still registered",
				  self, self.gameController.sceneViewControllerDeallocationCheck);
		self.gameController.sceneViewControllerDeallocationCheck = nil;
	}
}

#pragma mark Controller Register

-(void) addDefaultControllersAndModel:(KTSceneModel*)sceneModel
{
	[self addSubController:[KTMultiTouchController controller]];
	
#if KK_PLATFORM_IOS
	[self addSubController:[KTMotionController controller]];
#endif
	
	if (sceneModel == nil)
	{
		sceneModel = [KTSceneModel model];
	}
	[self internal_setModel:sceneModel];

	// scene must call loadView immediately so that the scene object exists
	[self createSceneNode];
}

-(void) createSceneNode
{
	KTCCScene* scene = [KTCCScene node];
	scene.sceneViewController = self;
	self.rootNode = scene;
	_scene = scene; // hold on to the scene with a strong reference
}

-(void) registerController:(KTController*)controller withName:(NSString*)name
{
	if (_subControllersByName == nil)
	{
		_subControllersByName = [NSMutableDictionary dictionaryWithCapacity:1];
	}
	
	[_subControllersByName setObject:controller forKey:name];
}

-(void) removeRegisteredController:(KTController*)controller
{
	NSArray* controllerKeys = [_subControllersByName allKeysForObject:controller];
	for (NSString* key in controllerKeys)
	{
		[_subControllersByName removeObjectForKey:key];
	}
}

-(void) removeRegisteredControllerByName:(NSString*)name
{
	[_subControllersByName removeObjectForKey:name];
}

-(id) registeredControllerByName:(NSString*)name
{
	return [_subControllersByName objectForKey:name];
}

-(KTController*) registeredControllerByClass:(Class)controllerClass
{
	for (KTController* controller in [_subControllersByName allValues])
	{
		if (controllerClass == [controller class])
		{
			return controller;
		}
	}
	
	return nil;
}

#pragma mark Load View

-(void) internal_viewWillDisappear
{
	[self sendViewWillDisappearToViewController:self];
}

-(void) internal_viewDidDisappear
{
	self.rootNode = nil;
	_scene = nil;

	[self sendViewDidDisappearToViewController:self];
	[self sendUnloadToControllersAndModels:self];

	_subControllersByName = nil;
	
	self.gameController.sceneViewControllerDeallocationCheck = self;
}

#pragma mark Setup/Cleanup

-(void) sendLoadToControllersAndModels:(KTController*)controller
{
	// only create model if not assigned already (ie via loading an archive)
	if (controller.model == nil && controller.createModelBlock != nil)
	{
		KTModel* model = controller.createModelBlock();
		NSAssert2([model isKindOfClass:[KTModel class]],
				  @"createModelBlock of controller (%@) did not return a valid KTModel object (%@)", controller, model);
		[controller internal_setModel:model];
	}

	if (controller.model)
	{
		[controller.model internal_setController:controller];
		[controller.model load];
	}

	[controller load];

	for (KTController* subController in controller.subControllers)
	{
		[self sendLoadToControllersAndModels:subController];
	}
}

-(void) sendUnloadToControllersAndModels:(KTController*)controller
{
	// deliberately sending message from the bottom of the node hierarchy upwards, with scene controller last
	for (KTController* subController in [controller.subControllers reverseObjectEnumerator])
	{
		[self sendUnloadToControllersAndModels:subController];
	}

	[controller unload];
	[controller.model unload];
}

-(void) sendViewWillLoadToViewController:(KTViewController*)viewController
{
	if ([viewController isKindOfClass:[KTViewController class]])
	{
		[viewController viewWillLoad];
		
		for (KTViewController* subViewController in viewController.subControllers)
		{
			[self sendViewWillLoadToViewController:subViewController];
		}
	}
}

-(void) sendLoadViewToViewController:(KTViewController*)viewController
{
	for (KTViewController* subViewController in viewController.subControllers)
	{
		if ([subViewController isKindOfClass:[KTViewController class]])
		{
			NSLog(@"loadView: %@", subViewController);
			[subViewController loadView];
			[subViewController internal_runLoadViewBlock];
			[viewController addSubView:subViewController.rootNode];
			
			[self sendLoadViewToViewController:subViewController];
		}
	}
}

-(void) sendViewDidLoadToViewController:(KTViewController*)viewController
{
	if ([viewController isKindOfClass:[KTViewController class]])
	{
		[viewController viewDidLoad];
		
		for (KTViewController* subViewController in viewController.subControllers)
		{
			[self sendViewDidLoadToViewController:subViewController];
		}
	}
}

-(void) sendViewWillDisappearToViewController:(KTViewController*)viewController
{
	if ([viewController isKindOfClass:[KTViewController class]])
	{
		// deliberately sending message from the bottom of the node hierarchy upwards, with scene controller last
		for (KTViewController* subViewController in [viewController.subControllers reverseObjectEnumerator])
		{
			[self sendViewWillDisappearToViewController:subViewController];
		}
		
		[viewController viewWillDisappear];
	}
}

-(void) sendViewDidDisappearToViewController:(KTViewController*)viewController
{
	if ([viewController isKindOfClass:[KTViewController class]])
	{
		// deliberately sending message from the bottom of the node hierarchy upwards, with scene controller last
		for (KTViewController* subViewController in [viewController.subControllers reverseObjectEnumerator])
		{
			[self sendViewDidDisappearToViewController:subViewController];
		}
		
		[viewController viewDidDisappear];
	}
}

#pragma mark dynamic properties

@dynamic physicsController;
-(KTPhysicsController*)physicsController
{
	return (KTPhysicsController*)[self subControllerByClass:[KTPhysicsController class]];
}
-(KTMultiTouchController*) multiTouchController
{
	return (KTMultiTouchController*)[self subControllerByClass:[KTMultiTouchController class]];
}
-(KTMotionController*) motionController
{
	return (KTMotionController*)[self subControllerByClass:[KTMotionController class]];
}

@end
