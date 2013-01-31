//
//  KTMoveAction.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 16.01.13.
//
//

#import "KTMoveAction.h"

@implementation KTMoveAction

#pragma mark init with duration

-(id) initWithDuration:(float)duration destination:(CGPoint)destination
{
	self = [super initWithDuration:duration];
	if (self)
	{
		_destination = destination;
	}
	return self;
}
+(id) actionWithDuration:(float)duration destination:(CGPoint)destination
{
	return [[self alloc] initWithDuration:duration destination:destination];
}

-(id) initWithDuration:(float)duration offset:(CGPoint)offset
{
	self = [super initWithDuration:duration];
	if (self)
	{
		_destination = offset;
		_destinationIsOffset = YES;
	}
	return self;
}
+(id) actionWithDuration:(float)duration offset:(CGPoint)offset
{
	return [[self alloc] initWithDuration:duration offset:offset];
}

#pragma mark init with speed

-(id) initWithSpeed:(float)speed destination:(CGPoint)destination
{
	self = [super initWithDuration:0.0f];
	if (self)
	{
		_speed = speed;
		_destination = destination;
	}
	return self;
}
+(id) actionWithSpeed:(float)speed destination:(CGPoint)destination
{
	return [[self alloc] initWithSpeed:speed destination:destination];
}

-(id) initWithSpeed:(float)speed offset:(CGPoint)offset
{
	self = [super initWithDuration:0.0f];
	if (self)
	{
		_speed = speed;
		_destination = offset;
		_destinationIsOffset = YES;
	}
	return self;
}
+(id) actionWithSpeed:(float)speed offset:(CGPoint)offset
{
	return [[self alloc] initWithSpeed:speed offset:offset];
}

#pragma mark setup & update

-(void) reset
{
	_startPosition = _model.position;
	if (_destinationIsOffset)
	{
		_destination = ccpAdd(_startPosition, _destination);
	}
	
	_deltaPosition = ccpSub(_destination, _startPosition);
	
	// if speed is used, update duration based on distance to destination
	if (_speed > 0.0f)
	{
		_duration = ccpDistance(_startPosition, _destination) / (_speed / [CCDirector sharedDirector].animationInterval);
	}
}

-(void) updateWithDeltaTime:(float)deltaTime
{
	_model.position = CGPointMake(_startPosition.x + _deltaPosition.x * deltaTime,
								  _startPosition.y + _deltaPosition.y * deltaTime);
}

@end
