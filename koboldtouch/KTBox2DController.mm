//
//  KTBox2DPhysicsController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "Box2D.h"

#import "KTBox2DController.h"
#import "KTBox2DBody.h"
#include "KTBox2DContactListener.h"

#define ASSERT_WORLD NSAssert1(_world, @"Box2D world is not initialized yet! Run this method *after* presenting the scene.", self)

@implementation KTBox2DController

-(id) init
{
	self = [super init];
	if (self)
	{
		_pixelsToMeterRatio = 32.0f;
		_velocityIterations = 8;
		_positionIterations = 2;
	}
	return self;
}


#pragma mark World

-(void) createWorld
{
	_world = new b2World(b2Vec2(self.gravity.x, self.gravity.y));

	_contactListener = new KTBox2DContactListener();
	_world->SetContactListener(_contactListener);

	[self createWorldBorder];
}

-(void) destroyWorld
{
	delete _world;
	_world = NULL;
	
	delete _contactListener;
	_contactListener = NULL;
}

-(void) createWorldBorder
{
	if (_world && CGRectIsEmpty(self.worldConstraint) == NO)
	{
		CGRect worldConstraint = self.worldConstraint;

		// for the world border body we'll need these values
		float widthInMeters = worldConstraint.size.width / _pixelsToMeterRatio;
		float heightInMeters = worldConstraint.size.height / _pixelsToMeterRatio;
		b2Vec2 lowerLeftCorner = b2Vec2(worldConstraint.origin.x, worldConstraint.origin.y);
		b2Vec2 lowerRightCorner = b2Vec2(worldConstraint.origin.x + widthInMeters, worldConstraint.origin.y);
		b2Vec2 upperLeftCorner = b2Vec2(worldConstraint.origin.x, worldConstraint.origin.y + heightInMeters);
		b2Vec2 upperRightCorner = b2Vec2(worldConstraint.origin.x + widthInMeters, worldConstraint.origin.y + heightInMeters);
		
		// Define the static container body, which will provide the collisions at world borders
		b2BodyDef worldBorderDef;
		worldBorderDef.position.Set(worldConstraint.origin.x, worldConstraint.origin.y);
		b2Body* worldBorderBody = _world->CreateBody(&worldBorderDef);
		
		// Create fixtures for the four borders (the border shape is re-used)
		b2EdgeShape worldBorderShape;
		worldBorderShape.Set(lowerLeftCorner, lowerRightCorner);
		worldBorderBody->CreateFixture(&worldBorderShape, 0);
		worldBorderShape.Set(lowerRightCorner, upperRightCorner);
		worldBorderBody->CreateFixture(&worldBorderShape, 0);
		worldBorderShape.Set(upperRightCorner, upperLeftCorner);
		worldBorderBody->CreateFixture(&worldBorderShape, 0);
		worldBorderShape.Set(upperLeftCorner, lowerLeftCorner);
		worldBorderBody->CreateFixture(&worldBorderShape, 0);
	}
}

-(void) constrainWorldToRect:(CGRect)worldConstraint
{
	[super constrainWorldToRect:worldConstraint];
	[self createWorldBorder];
}

-(void) setGravity:(CGPoint)gravity
{
	if (_world)
	{
		_world->SetGravity(b2Vec2(gravity.x, gravity.y));
	}
	else
	{
		[super setGravity:gravity];
	}
}
-(CGPoint) gravity
{
	if (_world)
	{
		b2Vec2 gravity = _world->GetGravity();
		return CGPointMake(gravity.x, gravity.y);
	}
	
	return [super gravity];
}

#pragma mark Bodies

-(void) performAddBody:(KTBox2DBody*)physicsBody
{
	ASSERT_WORLD;

	b2BodyDef bodyDef;
	bodyDef.position = b2Vec2(physicsBody.position.x / _pixelsToMeterRatio, physicsBody.position.y / _pixelsToMeterRatio);
	bodyDef.angle = CC_DEGREES_TO_RADIANS(physicsBody.rotation);
	
	switch (physicsBody.bodyType)
	{
		case kPhysicsBodyTypeDynamic:
			bodyDef.type = b2_dynamicBody;
			break;
		case kPhysicsBodyTypeKinematic:
			bodyDef.type = b2_kinematicBody;
			break;
		case kPhysicsBodyTypeStatic:
			bodyDef.type = b2_staticBody;
			break;
	}
	
	// using defaults for now
	bodyDef.allowSleep = physicsBody.isSleepingAllowed;
	CGPoint linearVelocity = physicsBody.linearVelocity;
	bodyDef.linearVelocity = b2Vec2(linearVelocity.x, linearVelocity.y);
	bodyDef.linearDamping = physicsBody.linearDamping;
	bodyDef.angularVelocity = physicsBody.angularVelocity;
	bodyDef.angularDamping = physicsBody.angularDamping;
	bodyDef.active = physicsBody.isActive;
	bodyDef.awake = physicsBody.isAwake;
	bodyDef.bullet = physicsBody.preventTunneling;
	bodyDef.fixedRotation = physicsBody.isFixedRotation;
	bodyDef.gravityScale = physicsBody.gravityScale;
	
	b2Body* body = _world->CreateBody(&bodyDef);
	body->SetUserData((__bridge void*)physicsBody);
	
	b2FixtureDef fixtureDef;
	fixtureDef.density = physicsBody.firstShape.density;
	fixtureDef.friction = physicsBody.firstShape.friction;
	fixtureDef.restitution = physicsBody.firstShape.bounce;
	
	switch (physicsBody.firstShape.shapeType)
	{
		case kPhysicsShapeTypeCircle:
		{
			b2CircleShape circleShape;
			circleShape.m_radius = physicsBody.firstShape.radius;
			fixtureDef.shape = &circleShape;
			break;
		}
		case kPhysicsShapeTypeSquare:
		{
			NSAssert(nil, @"square shape not implemented");
			break;
		}
		case kPhysicsShapeTypeRect:
		{
			NSAssert(nil, @"rect shape not implemented");
			break;
		}
		case kPhysicsShapeTypePolygon:
		{
			NSAssert(nil, @"polygon shape not implemented");
			break;
		}
	}
	
	b2Fixture* fixture = body->CreateFixture(&fixtureDef);
	fixture->SetUserData((__bridge void*)physicsBody);
	
	physicsBody.box2dBody = body;
}

-(void) performRemoveBody:(KTBox2DBody*)physicsBody
{
	ASSERT_WORLD;
	//NSLog(@"Removing physics body: %@", physicsBody);
	physicsBody.box2dBody->SetUserData(NULL);
	_world->DestroyBody(physicsBody.box2dBody);
	physicsBody.box2dBody = NULL;
}

#pragma mark Update

-(void) step:(KTStepInfo *)stepInfo
{
	if (_world)
	{
		_world->Step(self.timeStep, _velocityIterations, _positionIterations);
	}
	
	[self removeScheduledToBeRemovedBodies];
	[self addScheduledToBeAddedBodies];
}

-(b2World*) internal_getWorld
{
	return _world;
}
@end
