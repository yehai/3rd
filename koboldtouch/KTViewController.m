//
//  KTViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 22.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"
#import "KTSceneViewController.h"
#import "KTEntityModel.h"

#import "CCNode.h"

@implementation KTViewController

#pragma mark Property Overrides
-(void) setRootNode:(CCNode *)rootNode
{
	if (rootNode)
	{
		NSAssert2(_rootNode == nil,
				 @"rootNode is already set to %@, tried to replace with %@! Once set, rootNode can only be set to nil before being re-set to prevent accidental replacement.",
				 _rootNode, rootNode);
		
		if (self.isSceneViewController == NO)
		{
			// add the new view node
			[(KTViewController*)self.parentController addSubView:rootNode];
		}
	}
	else if (self.isSceneViewController == NO)
	{
		// new view node is nil, remove the one currently in view
		[(KTViewController*)self.parentController removeSubView:_rootNode];
	}
	
	_rootNode = rootNode;
}
/*
-(CCNode*) rootNode
{
	NSLog(@"rootNode: %@ (children: %u)", _rootNode, _rootNode.children.count);
	return _rootNode;
}
*/

#pragma mark Pause
-(void) setPaused:(BOOL)paused
{
	[super setPaused:paused];
	if (self.paused)
	{
		[self.rootNode pauseSchedulerAndActions];
	}
	else
	{
		[self.rootNode resumeSchedulerAndActions];
	}
}

#pragma mark Step

-(void) updateViewFromEntityModel
{
	if (_entityModel)
	{
		CCNode* node = self.rootNode;
		node.position = _entityModel.position;
		node.rotation = _entityModel.rotation;
		node.scale = _entityModel.scale;
	}
}

-(void) afterStep:(KTStepInfo *)stepInfo
{
	[self updateViewFromEntityModel];
}

#pragma mark Load View

-(void) viewWillLoad
{
}
-(void) viewDidLoad
{
}
-(void) viewWillDisappear
{
}
-(void) viewDidDisappear
{
}

-(void) loadView
{
	if (_rootNode == nil)
	{
		self.rootNode = [CCNode node];
	}
}

-(void) addSubView:(CCNode*)viewNode
{
	NSAssert1(viewNode, @"viewNode is nil - this indicates a subViewController of viewController (%@) isn't actually managing a view! Perhaps you implemented -(void) loadView without creating and assigning a node to self.rootNode ?", self);
	NSAssert1(self.rootNode, @"can't add view, rootNode of parent view controller (%@) is nil!", self);
	NSAssert1(self.rootNode != viewNode, @"can't add view, rootNode and viewNode are the same! (%@)", viewNode);

	if (viewNode)
	{
		[self.rootNode addChild:viewNode];
	}
}

-(void) removeSubView:(CCNode*)viewNode
{
	if (viewNode)
	{
		[self.rootNode removeChild:viewNode cleanup:YES];
	}
}

#pragma Add/Remove Controller Overrides

/*
-(void) addSubController:(KTController*)controller
{
	[super addSubController:controller];
}
*/

/*
-(void) replaceSubController:(KTViewController*)existingController withController:(KTViewController*)newController
{
	NSAssert1([newController isKindOfClass:[KTViewController class]],
			  @"adding controller (%@) that is not a KTViewController (or subclass) is prohibited!", newController);
	[super replaceSubController:existingController withController:newController];
	[existingController internal_setSceneViewController:nil];
	[newController internal_setSceneViewController:self.sceneViewController];
}
*/

-(void) removeSubController:(KTViewController*)controller
{
	[super removeSubController:controller];
	[controller internal_setSceneViewController:nil];
}

-(void) removeAllSubControllers
{
	for (KTViewController* controller in self.subControllers)
	{
		[controller internal_setSceneViewController:nil];
	}
	
	[super removeAllSubControllers];
}

-(void) remove
{
	self.rootNode = nil;
	[super remove];
}

#pragma mark Internal use only

-(void) internal_setModel:(KTModel*)model
{
	[super internal_setModel:model];
	
	if (model == nil || [model isKindOfClass:[KTEntityModel class]])
	{
		_entityModel = (KTEntityModel*)model;
	}
}

-(void) internal_runLoadViewBlock
{
	if (_loadViewBlock)
	{
		_loadViewBlock(_rootNode);
	}
}

-(void) internal_pauseActionsOnNode:(CCNode*)node pause:(BOOL)pause
{
	if (pause)
	{
		[node pauseSchedulerAndActions];
	}
	else
	{
		[node resumeSchedulerAndActions];
	}
	
	for (CCNode* child in node.children)
	{
		[self internal_pauseActionsOnNode:child pause:pause];
	}
}
-(void) internal_pauseActions:(BOOL)pause
{
	[self internal_pauseActionsOnNode:self.rootNode pause:pause];
}

@end
