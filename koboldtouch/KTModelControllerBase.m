//
//  KTModelControllerBase.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTModelControllerBase.h"

@implementation KTModelControllerBase

-(id) init
{
	self = [super init];
	if (self)
	{
		[self setImplementsStepFlags];
		[self initWithDefaults];
	}
	return self;
}

-(void) dealloc
{
	//NSLog(@"MCB dealloc: %@", self);
}

#pragma mark Overrides
-(void) initWithDefaults
{
}
-(void) load
{
}
-(void) unload
{
	//NSLog(@"MCB unload: %@", self);
}

#pragma mark Internal

-(void) setImplementsStepFlags
{
	_beforeStepSelector = ([self respondsToSelector:@selector(beforeStep:)] ? @selector(beforeStep:) : nil);
	_stepSelector = ([self respondsToSelector:@selector(step:)] ? @selector(step:) : nil);
	_afterStepSelector = ([self respondsToSelector:@selector(afterStep:)] ? @selector(afterStep:) : nil);
}

-(BOOL) internal_implementsStepSelector:(SEL)stepSelector
{
	return ((stepSelector == _stepSelector) || (stepSelector == _beforeStepSelector) || (stepSelector == _afterStepSelector));
}


@end
