//
//  KTBox2DShape.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 11.10.12.
//
//

#import "KTBox2DShape.h"
#import "KTBox2DBody.h"
#import "Box2D.h"

@implementation KTBox2DShape

-(void) setDensity:(float)density
{
	[super setDensity:density];
	b2Body* box2dBody = ((KTBox2DBody*)self.body).box2dBody;
	if (box2dBody)
	{
		box2dBody->GetFixtureList()->SetDensity(density);
	}
}

-(void) setFriction:(float)friction
{
	[super setFriction:friction];
	b2Body* box2dBody = ((KTBox2DBody*)self.body).box2dBody;
	if (box2dBody)
	{
		box2dBody->GetFixtureList()->SetFriction(friction);
	}
}

-(void) setBounce:(float)bounce
{
	[super setBounce:bounce];
	b2Body* box2dBody = ((KTBox2DBody*)self.body).box2dBody;
	if (box2dBody)
	{
		box2dBody->GetFixtureList()->SetRestitution(bounce);
	}
}

@end
