//
//  KTBox2DPhysicsDebugViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTPhysicsDebugViewController.h"
#import "CCNode.h"

class b2World;
class GLESDebugDraw;
@class KTBox2DController;

// internal use only
@interface KTBox2DDebugDrawNode : CCNode
@property (nonatomic) b2World* world;
@end

/** Box2D specific debug view controller. Wraps the GLESDebugDraw class. */
@interface KTBox2DDebugViewController : KTPhysicsDebugViewController
{
	GLESDebugDraw* _debugDraw;
}

@property (nonatomic, weak) KTBox2DController* physicsController;

-(id) initWithPhysicsController:(KTBox2DController*)physicsController;

@end
