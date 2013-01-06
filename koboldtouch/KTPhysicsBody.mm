//
//  KTPhysicsBody.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTPhysicsBody.h"

#import "KTBox2DBody.h"
#import "KTBox2DController.h"
#import "KTPhysicsEntityModel.h"
#import "NSCoder+KTCoderCategory.h"

@implementation KTPhysicsBody

+(id) bodyWithPhysicsController:(KTPhysicsController*)physicsController
{
	if ([physicsController isKindOfClass:[KTBox2DController class]])
	{
		return [[KTBox2DBody alloc] initWithPhysicsController:physicsController];
	}
	else
	{
		NSAssert1(nil, @"unsupported physicsController class: %@", NSStringFromClass([physicsController class]));
	}
	return nil;
}
-(id) initWithPhysicsController:(KTPhysicsController*)physicsController
{
	self = [super init];
	NSAssert([self superclass] == [KTPhysicsBody class],
			 @"KTPhysicsBody is not a concrete implementation (Box2D, Chipmunk). Do not init KTPhysicsBody with alloc/initWith, use bodyWith...");
	
	if (self)
	{
		NSAssert(physicsController, @"physicsController is nil! KTPhysicsBody requires a physics controller reference.");
		_physicsController = physicsController;
		self.gravityScale = 1.0f;
		self.isSleepingAllowed = YES;
		self.isAwake = YES;
		self.isActive = YES;
	}
	return self;
}

NSString* const kCodingKeyForPosition = @"position";
NSString* const kCodingKeyForRotation = @"rotation";
NSString* const kCodingKeyForBodyType = @"bodyType";
NSString* const kCodingKeyForLinearVelocity = @"linearVelocity";
NSString* const kCodingKeyForLinearDamping = @"linearDamping";
NSString* const kCodingKeyForAngularVelocity = @"angularVelocity";
NSString* const kCodingKeyForAngularDamping = @"angularDamping";
NSString* const kCodingKeyForGravityScale = @"gravityScale";
NSString* const kCodingKeyForSleepingAllowed = @"isSleepingAllowed";
NSString* const kCodingKeyForAwake = @"isAwake";
NSString* const kCodingKeyForActive = @"isActive";
NSString* const kCodingKeyForFixedRotation = @"isFixedRotation";
NSString* const kCodingKeyForPreventTunneling = @"preventTunneling";
NSString* const kCodingKeyForShapes = @"shapes";

-(id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		self.position = [aDecoder decodeCGPointForKey:kCodingKeyForPosition];
		self.rotation = [aDecoder decodeFloatForKey:kCodingKeyForRotation];
		self.bodyType = (KTPhysicsBodyType)[aDecoder decodeIntForKey:kCodingKeyForBodyType];
		self.linearVelocity = [aDecoder decodeCGPointForKey:kCodingKeyForLinearVelocity];
		self.linearDamping = [aDecoder decodeFloatForKey:kCodingKeyForLinearDamping];
		self.angularVelocity = [aDecoder decodeFloatForKey:kCodingKeyForAngularVelocity];
		self.angularDamping = [aDecoder decodeFloatForKey:kCodingKeyForAngularDamping];
		self.gravityScale = [aDecoder decodeFloatForKey:kCodingKeyForGravityScale];
		self.isSleepingAllowed = [aDecoder decodeBoolForKey:kCodingKeyForSleepingAllowed];
		self.isAwake = [aDecoder decodeBoolForKey:kCodingKeyForAwake];
		self.isActive = [aDecoder decodeBoolForKey:kCodingKeyForActive];
		self.isFixedRotation = [aDecoder decodeBoolForKey:kCodingKeyForFixedRotation];
		self.preventTunneling = [aDecoder decodeBoolForKey:kCodingKeyForPreventTunneling];
		_shapes = [aDecoder decodeObjectForKey:kCodingKeyForShapes];
		_firstShape = (_shapes.count > 0) ? [_shapes objectAtIndex:0] : nil;
		for (KTPhysicsBodyShape* shape in _shapes)
		{
			shape.body = self;
		}
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeCGPoint:self.position forKey:kCodingKeyForPosition];
	[aCoder encodeFloat:self.rotation forKey:kCodingKeyForRotation];
	[aCoder encodeInt:self.bodyType forKey:kCodingKeyForBodyType];
	[aCoder encodeCGPoint:self.linearVelocity forKey:kCodingKeyForLinearVelocity];
	[aCoder encodeFloat:self.linearDamping forKey:kCodingKeyForLinearDamping];
	[aCoder encodeFloat:self.angularVelocity forKey:kCodingKeyForAngularVelocity];
	[aCoder encodeFloat:self.angularDamping forKey:kCodingKeyForAngularDamping];
	[aCoder encodeFloat:self.gravityScale forKey:kCodingKeyForGravityScale];
	[aCoder encodeBool:self.isSleepingAllowed forKey:kCodingKeyForSleepingAllowed];
	[aCoder encodeBool:self.isAwake forKey:kCodingKeyForAwake];
	[aCoder encodeBool:self.isActive forKey:kCodingKeyForActive];
	[aCoder encodeBool:self.isFixedRotation forKey:kCodingKeyForFixedRotation];
	[aCoder encodeBool:self.preventTunneling forKey:kCodingKeyForPreventTunneling];
	[aCoder encodeObject:_shapes forKey:kCodingKeyForShapes];
}

-(void) addShape:(KTPhysicsBodyShape*)shape
{
	shape.body = self;

	if (_shapes == nil)
	{
		_shapes = [NSMutableArray array];
		_firstShape = shape;
	}
	
	[_shapes addObject:shape];
}

@end
