//
//  KTBox2DPhysicsDebugViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTBox2DDebugViewController.h"
#import "KTBox2DController.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "matrix.h" // kmGL* methods (kazmath)

@implementation KTBox2DDebugDrawNode
-(void)draw
{
	if (_world)
	{
		ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
		kmGLPushMatrix();
		_world->DrawDebugData();
		kmGLPopMatrix();
	}
}
@end

@implementation KTBox2DDebugViewController

-(id) initWithPhysicsController:(KTBox2DController*)physicsController
{
	self = [super init];
	if (self)
	{
		_physicsController = physicsController;
	}
	return self;
}

-(void) loadView
{
	_debugDraw = new GLESDebugDraw(_physicsController.pixelsToMeterRatio);

	unsigned int debugDrawFlags = 0;
	debugDrawFlags += b2Draw::e_shapeBit;
	debugDrawFlags += b2Draw::e_jointBit;
	//debugDrawFlags += b2Draw::e_aabbBit;
	//debugDrawFlags += b2Draw::e_pairBit;
	//debugDrawFlags += b2Draw::e_centerOfMassBit;
	_debugDraw->SetFlags(debugDrawFlags);

	b2World* world = [_physicsController internal_getWorld];
	NSAssert1(world, @"Box2D world is NULL! PhysicsController: %@", _physicsController);
	world->SetDebugDraw(_debugDraw);

	KTBox2DDebugDrawNode* debugDrawNode = [KTBox2DDebugDrawNode node];
	debugDrawNode.world = world;

	self.rootNode = debugDrawNode;
}

-(void) viewWillDisappear
{
	KTBox2DDebugDrawNode* debugDrawNode = (KTBox2DDebugDrawNode*)self.rootNode;
	debugDrawNode.world = NULL;
	
	b2World* world = [_physicsController internal_getWorld];
	world->SetDebugDraw(NULL);
	
	delete _debugDraw;
	_debugDraw = NULL;
}

@end
