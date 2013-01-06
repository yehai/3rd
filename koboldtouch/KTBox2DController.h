//
//  KTBox2DPhysicsController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTPhysicsController.h"

class b2World;
class KTBox2DContactListener;
@class KTBox2DBody;

/** KTPhysicsController implementation wrapping the Box2D physics engine. Contains Box2D specific extensions.
 
 \warning: To get/set Box2D specific extension properties you should avoid casting to KTBox2DController as this will
 pollute your code base with C++ code, requiring you to change file extensions to '<filename>.mm'. 
 
 Instead, use KVO/KVC:
 
 [physicsController setValue:@10 forKey:@"velocityIterations"];
 unsigned int numIter = [physicsController valueForKey:@"velocityIterations"];
 */
@interface KTBox2DController : KTPhysicsController
{
	@private
	b2World* _world;
	KTBox2DContactListener* _contactListener;
}

/** How many velocity iterations each step. Default is 8. */
@property (nonatomic) unsigned int velocityIterations;
/** How many velocity iterations each step. Default is 2. */
@property (nonatomic) unsigned int positionIterations;
/** The pixel to meter ratio. Default is 32. 
 \warning: Contrary to popular use, you don't need this anywhere in your code. The Box2D physics controller
 and related classes already perform the pixel-meter conversions for you! */
@property (nonatomic) float pixelsToMeterRatio;

-(b2World*) internal_getWorld;

-(void) performAddBody:(KTBox2DBody*)physicsBody;
-(void) performRemoveBody:(KTBox2DBody*)physicsBody;

@end
