//
//  KTController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 24.09.12.
//
//

#import "KTController.h"
#import "KTGameController.h"
#import "KTViewController.h"
#import "KTModel.h"

static Class kKTViewControllerClass = nil;
static BOOL _deferSubControllerAddAndRemove = NO;

@implementation KTController

@synthesize subControllers = _subControllers;

+(id) controller
{
	return [[self alloc] init];
}

-(id) init
{
	if (kKTViewControllerClass == nil)
	{
		kKTViewControllerClass = [KTViewController class];
	}

	self.tag = kInvalidControllerTag;
	
	// the game controller reference should be set even before initWithDefaults
	[self internal_setGameController:[KTGameController sharedGameController]];

	self = [super init];
	return self;
}

#pragma mark Overrides

-(void) sceneWillChange
{
}
-(void) sceneDidChange
{
}

#pragma mark Paused

-(void) setPaused:(BOOL)paused
{
	[super setPaused:paused];
	
	// synchronize model/controller pause
	if (_model.paused != paused)
	{
		_model.paused = paused;
	}
	
	// synchronize subcontrollers
	for (KTController* subController in _subControllers)
	{
		subController.paused = paused;
	}
}

#pragma mark Model
-(void) setModel:(KTModel*)model
{
	NSAssert1(model.controller == nil,
			  @"model already has a controller (%@) - you can't use the same model with multiple controllers!",
			  model.controller);

	_model = model;
	[_model internal_setController:self];
}

#pragma mark SubControllers

-(void) initializeSubControllerCollection
{
	_subControllers = [NSMutableArray arrayWithCapacity:1];
}

-(void) addSubController:(KTController*)controller
{
	[self internal_addSubController:controller insertAsFirstController:NO];
}

-(void) internal_addSubController:(KTController*)controller insertAsFirstController:(BOOL)insertAsFirstController
{
	if (_subControllers == nil)
	{
		[self initializeSubControllerCollection];
	}
	
	if (_subControllers)
	{
		NSAssert(controller, @"can't add subController - the controller you tried to add is nil");
		NSAssert1([_subControllers containsObject:controller] == NO, @"can't add subController %@ - controller already added", controller);
		
		if (_deferSubControllerAddAndRemove)
		{
			NSAssert(insertAsFirstController == NO, @"Can't 'insert as first controller' during a step method! Controller to be inserted is: %@", controller);
			[self deferAddOfController:controller];
		}
		else
		{
			if (insertAsFirstController)
			{
				[_subControllers insertObject:controller atIndex:0];
			}
			else
			{
				[_subControllers addObject:controller];
			}
		}

		// for view controllers added after the scene was presented, call loadView manually here
		BOOL sendLoadView = [controller isKindOfClass:kKTViewControllerClass];
		
		[self internal_setControllerReferencesOnController:controller
										  parentController:self
									   sceneViewController:self.sceneViewController
											gameController:self.gameController];

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
		
		if (sendLoadView)
		{
			KTViewController* viewController = (KTViewController*)controller;
			[viewController viewWillLoad];
			[viewController loadView];
			[viewController internal_runLoadViewBlock];
			[viewController viewDidLoad];
		}
	}
}

/*
-(void) replaceSubController:(KTController*)existingController withController:(KTController*)newController
{
	NSAssert(newController, @"can't replace, new controller is nil!");

	if (_subControllers == nil)
	{
		[self initializeSubControllerCollection];
	}
	
	if (_subControllers)
	{
		if (existingController)
		{
			NSUInteger index = [_subControllers indexOfObject:existingController];
			if (index != NSNotFound)
			{
				[_subControllers replaceObjectAtIndex:index withObject:newController];
				
				// only set controller references if controller was added to an already presented scene, or if controller is added to game controller
				if (self.sceneViewController || self == (KTController*)self.gameController)
				{
					[self internal_setControllerReferencesOnController:existingController
													  parentController:nil
												   sceneViewController:nil
														gameController:self.gameController];
					[self internal_setControllerReferencesOnController:newController
													  parentController:self
												   sceneViewController:self.sceneViewController
														gameController:self.gameController];
				}
			}
			else
			{
				[self addSubController:newController];
			}
		}
		else
		{
			[self addSubController:newController];
		}
	}
}
*/

-(void) removeSubController:(KTController*)controller
{
	if (_subControllers && controller)
	{
		[controller unload];
		[controller.model unload];
		
		[self internal_setControllerReferencesOnController:controller
										  parentController:nil
									   sceneViewController:nil
											gameController:self.gameController];
		
		if (_deferSubControllerAddAndRemove)
		{
			[self deferRemoveOfController:controller];
		}
		else
		{
			[_subControllers removeObject:controller];
		}
	}
}

-(void) removeAllSubControllers
{
	while (_subControllers.count > 0)
	{
		KTController* controller = [_subControllers lastObject];
		[self removeSubController:controller];
	}
}

-(KTController*) subControllerByClass:(Class)controllerClass
{
	for (KTController* controller in _subControllers)
	{
		if ([controller isKindOfClass:controllerClass])
		{
			return controller;
		}
	}
	
	return nil;
}

-(KTController*) subControllerByName:(NSString*)controllerName
{
	for (KTController* controller in _subControllers)
	{
		if ([controller.name isEqualToString:controllerName])
		{
			return controller;
		}
	}
	
	return nil;
}

-(KTController*) subControllerByTag:(NSInteger)controllerTag
{
	for (KTController* controller in _subControllers)
	{
		if (controller.tag == controllerTag)
		{
			return controller;
		}
	}
	
	return nil;
}

-(void) remove
{
	[self.parentController removeSubController:self];
}

#pragma mark Adding/Removing Scheduled SubControllers

-(void) deferRemoveOfController:(KTController*)controller
{
	if (_toBeRemovedSubControllers == nil)
	{
		_toBeRemovedSubControllers = [NSMutableArray arrayWithCapacity:1];
	}
	
	[_toBeRemovedSubControllers addObject:controller];
}

-(void) deferAddOfController:(KTController*)controller
{
	if (_toBeAddedSubControllers == nil)
	{
		_toBeAddedSubControllers = [NSMutableArray arrayWithObject:controller];
	}
	
	[_toBeAddedSubControllers addObject:controller];
}

-(void) performAddAndRemoveDeferredSubControllersForController:(KTController*)controller
{
	NSMutableArray* subControllers = controller.subControllers;
	NSMutableArray* toBeAddedSubControllers = controller.toBeAddedSubControllers;
	NSMutableArray* toBeRemovedSubControllers = controller.toBeRemovedSubControllers;

	if (toBeAddedSubControllers.count > 0)
	{
		[subControllers addObjectsFromArray:toBeAddedSubControllers];
		[toBeAddedSubControllers removeAllObjects];
	}

	if (toBeRemovedSubControllers.count > 0)
	{
		[subControllers removeObjectsInArray:toBeRemovedSubControllers];
		[toBeRemovedSubControllers removeAllObjects];
	}

	for (KTController* subController in subControllers)
	{
		[self performAddAndRemoveDeferredSubControllersForController:subController];
	}
}

-(void) internal_beginDeferSubControllerAddAndRemove
{
	_deferSubControllerAddAndRemove = YES;
}

-(void) internal_endDeferSubControllerAddAndRemove
{
	_deferSubControllerAddAndRemove = NO;
}


#pragma mark Internal

-(void) internal_setControllerReferencesOnController:(KTController*)controller
									parentController:(KTController*)parentController
								 sceneViewController:(KTSceneViewController*)sceneViewController
									  gameController:(KTGameController*)gameController
{
	[controller internal_setParentController:parentController];
	[controller internal_setSceneViewController:sceneViewController];
	[controller internal_setGameController:gameController];
	
	for (KTController* subController in controller.subControllers)
	{
		[self internal_setControllerReferencesOnController:subController
										  parentController:controller
									   sceneViewController:sceneViewController
											gameController:gameController];
	}
}

-(void) internal_setGameController:(KTGameController*)gameController
{
	_gameController = gameController;
}

-(void) internal_setSceneViewController:(KTSceneViewController *)sceneViewController
{
	_sceneViewController = sceneViewController;
}

-(void) internal_setParentController:(KTController*)parentController
{
	_parentController = parentController;
}

-(void) internal_setModel:(KTModel*)model
{
	_model = model;
}

@end
