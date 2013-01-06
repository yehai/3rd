//
//  KTPhysicsController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTPhysicsController.h"
#import "KTPhysicsBody.h"
#import "KTBox2DController.h"
#import "KTBox2DBody.h"
#import "CCDirector.h"

@implementation KTPhysicsController

@synthesize gravity;

+(KTPhysicsController*) physicsControllerWithBox2D
{
	return [[KTBox2DController alloc] init];
}

-(id) init
{
	self = [super init];
	NSAssert([self superclass] == [KTPhysicsController class],
			 @"KTPhysicsController is not a concrete implementation (ie Box2D). Do not init KTPhysicsController with alloc/initWith, use physicsControllerWith...");

	if (self)
	{
		_timeStep = 1.0f / 60.0f;
	}
	return self;
}

-(void) load
{
	_bodiesToAdd = [NSMutableSet set];
	_bodiesToRemove = [NSMutableSet set];

	[self createWorld];
}

-(void) unload
{
	[self destroyWorld];
	
	_bodiesToAdd = nil;
	_bodiesToRemove = nil;
}

-(void) removeScheduledToBeRemovedBodies
{
	// without allObjects the set would raise an exception because somehow it assumes it was modified
	for (KTPhysicsBody* body in [_bodiesToRemove allObjects])
	{
		[self performRemoveBody:body];
	}
	[_bodiesToRemove removeAllObjects];
}

-(void) addScheduledToBeAddedBodies
{
	for (KTPhysicsBody* body in _bodiesToAdd)
	{
		[self performAddBody:body];
	}
	[_bodiesToAdd removeAllObjects];
}

#pragma mark Methods to be overridden in subclasses
-(void) createWorld
{
}
-(void) destroyWorld
{
}
-(void) addBody:(KTPhysicsBody*)physicsBody
{
	NSAssert(physicsBody, @"physicsBody is nil");
	[_bodiesToAdd addObject:physicsBody];
}
-(void) removeBody:(KTPhysicsBody*)physicsBody
{
	NSAssert(physicsBody, @"physicsBody is nil");
	[_bodiesToRemove addObject:physicsBody];
}
-(void) performAddBody:(KTPhysicsBody*)physicsBody
{
}
-(void) performRemoveBody:(KTPhysicsBody*)physicsBody
{
}

#pragma mark Constraints
// to be implemented in subclasses, but must call super
-(void) constrainWorldToWindow
{
	CGSize winSize = [CCDirector sharedDirector].winSize;
	[self constrainWorldToRect:CGRectMake(0, 0, winSize.width, winSize.height)];
}
-(void) constrainWorldToRect:(CGRect)worldConstraint
{
	_worldConstraint = CGRectStandardize(worldConstraint);
}

@end
