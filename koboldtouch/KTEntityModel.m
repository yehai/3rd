//
//  KTEntityModel.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTEntityModel.h"
#import "KTAction.h"

@implementation KTEntityModel

-(id) init
{
	self = [super init];
	if (self)
	{
		_scale = 1.0f;
	}
	return self;
}

-(void) dealloc
{
	[self stopAllActions];
}

-(void) runAction:(KTAction*)action
{
	if (_actions == nil)
	{
		_actions = [NSMutableArray arrayWithCapacity:1];
	}

	if (action.isRunning)
	{
		// stop it first
		NSAssert2(action.model == self, @"action (%@) is already running on a different model (%@)!", action, action.model);
		[self stopAction:action];
	}
	
	[_actions addObject:action];
	[action startWithModel:self];
}

-(void) stopAction:(KTAction*)action
{
	[action stop];
	[_actions removeObject:action];
}

-(void) stopAllActions
{
	// reverse enumerate to avoid illegally modifying array during enumeration
	for (KTAction* action in [_actions reverseObjectEnumerator])
	{
		[self stopAction:action];
	}
}


// FIXME: this needs to be moved to a post-step stepping method (willRenderFrame?)
-(void) afterStep:(KTStepInfo *)stepInfo
{
	// enumerate backwards to prevent "collection modified while enumerating" error
	for (KTAction* action in [_actions reverseObjectEnumerator])
	{
		[action update:stepInfo];
	}
}

@end
