//
//  KTAction.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 16.01.13.
//
//

#import "KTAction.h"
#import "KTStepInfo.h"

@implementation KTAction

-(id) initWithDuration:(float)duration
{
	self = [super init];
	if (self)
	{
		_duration = duration;
		if (_duration == 0)
		{
			_duration = FLT_EPSILON;
		}
	}
	return self;
}

/*
-(void) dealloc
{
	NSLog(@"KTAction dealloc %@", self);
}
*/

-(void) startWithModel:(KTEntityModel *)model
{
	_isRunning = YES;
	_elapsedTime = 0.0f;
	_model = model;
	[self reset];
}

-(void) stop
{
	_isRunning = NO;
	_model = nil;
}

-(void) update:(KTStepInfo*)stepInfo
{
	float deltaTime = stepInfo.deltaTime;
	_elapsedTime += deltaTime;
	
	[self updateWithDeltaTime:MIN(1.0f, _elapsedTime / _duration)];
	
	if (_elapsedTime >= _duration)
	{
		[_model stopAction:self];
	}
}

// to be overridden by subclasses
-(void) reset
{
}

// to be overriden by subclasses
-(void) updateWithDeltaTime:(float)deltaTime
{
}

@end
