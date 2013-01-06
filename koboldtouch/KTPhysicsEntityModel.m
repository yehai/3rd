//
//  KTPhysicsEntityModel.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTPhysicsEntityModel.h"
#import "KTPhysicsController.h"
#import "KTPhysicsBody.h"
#import "KTSceneViewController.h"

NSString* const kCodingKeyForPhysicsBody = @"_physicsBody";

@implementation KTPhysicsEntityModel

+(id) physicsEntityModelWithPhysicsController:(KTPhysicsController *)physicsController
{
	return [[self alloc] initWithPhysicsController:physicsController];
}

-(id) initWithPhysicsController:(KTPhysicsController*)physicsController
{
	self = [super init];
	if (self)
	{
		_physicsController = physicsController;
		NSAssert(_physicsController, @"a physicsController is required on the sceneViewController for KTPhysicsEntityModel");
	}
	return self;
}


-(void) archiveWithCoder:(NSKeyedArchiver *)aCoder
{
	[aCoder encodeObject:_physicsBody forKey:kCodingKeyForPhysicsBody];
}

-(void) initWithArchive:(NSKeyedUnarchiver *)aDecoder archiveVersion:(int)archiveVersion
{
	_physicsBody = [aDecoder decodeObjectForKey:kCodingKeyForPhysicsBody];
}

-(void) load
{
	// create physics body unless it was restored from archive
	if (_physicsBody == nil)
	{
		_physicsBody = [KTPhysicsBody bodyWithPhysicsController:_physicsController];
		_physicsBody.model = self;
		
		KTPhysicsBodyShape* shape = [KTPhysicsBodyShape shapeWithBody:_physicsBody];

		// set default values
		_physicsBody.position = self.position;
		_physicsBody.rotation = self.rotation;
		shape.bounce = 0.6f;
	}

	_physicsBody.physicsController = _physicsController;
	_physicsBody.collisionDelegate = self;
	[_physicsController addBody:_physicsBody];
}

-(void) unload
{
	[_physicsController removeBody:_physicsBody];
	_physicsBody = nil;
}

#pragma mark Collision
-(void) contactWithOtherBody:(KTPhysicsBody*)otherBody phase:(KTPhysicsContactPhase)phase;
{
	//NSLog(@"contact: %@ <-> %@", _physicsBody, otherBody);
}

#pragma mark Property overrides
-(void) setPosition:(CGPoint)position
{
	_physicsBody.position = position;
}
-(CGPoint) position
{
	return _physicsBody.position;
}

-(void) setRotation:(float)rotation
{
	_physicsBody.rotation = CC_DEGREES_TO_RADIANS(rotation * -1.0f);
}
-(float) rotation
{
	return CC_RADIANS_TO_DEGREES(_physicsBody.rotation * -1.0f);
}


@end
