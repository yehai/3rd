//
//  KTPhysicsBodyShape.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTPhysicsBodyShape.h"
#import "KTBox2DBody.h"
#import "KTBox2DShape.h"

@implementation KTPhysicsBodyShape

+(id) shapeWithBody:(KTPhysicsBody*)body
{
	if ([body isKindOfClass:[KTBox2DBody class]])
	{
		return [[KTBox2DShape alloc] initWithBody:body];
	}
	
	[NSException raise:@"unsupported body class" format:@"only box2d bodies currently supported by KTPhyiscsBodyShape"];
	return nil;
}
-(id) initWithBody:(KTPhysicsBody*)body
{
	self = [super init];
	NSAssert([self superclass] == [KTPhysicsBodyShape class],
			 @"KTPhysicsBodyShape is not a concrete implementation (Box2D, Chipmunk). Do not init KTPhysicsBodyShape with alloc/initWith, use shape(With)...");

	if (self)
	{
		_density = 1.0f;
		_friction = 0.3f;
		_bounce = 0.2f;
		_radius = 0.5f;
		[body addShape:self];
	}
	return self;
}

NSString* const kCodingKeyForDensity = @"density";
NSString* const kCodingKeyForFriction = @"friction";
NSString* const kCodingKeyForBounce = @"bounce";
NSString* const kCodingKeyForRadius = @"radius";

-(id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		self.density = [aDecoder decodeFloatForKey:kCodingKeyForDensity];
		self.friction = [aDecoder decodeFloatForKey:kCodingKeyForFriction];
		self.bounce = [aDecoder decodeFloatForKey:kCodingKeyForBounce];
		self.radius = [aDecoder decodeFloatForKey:kCodingKeyForRadius];
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeFloat:self.density forKey:kCodingKeyForDensity];
	[aCoder encodeFloat:self.friction forKey:kCodingKeyForFriction];
	[aCoder encodeFloat:self.bounce forKey:kCodingKeyForBounce];
	[aCoder encodeFloat:self.radius forKey:kCodingKeyForRadius];
}

@end
