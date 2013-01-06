//
//  KTPhysicsEntityModel.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTEntityModel.h"
#import "KTPhysicsController.h"
#import "KTPhysicsBodyCollisionProtocol.h"
#import "KTPhysicsBody.h"

/** A model that owns a physics body, and whose basic properties (position, rotation) are animated by the physics body.
 Requires a KTPhysicsController as subcontroller on the scene view controller. */
@interface KTPhysicsEntityModel : KTEntityModel <KTPhysicsBodyCollisionProtocol>
{
}

/** Creates a physics entity model with a physics controller */
+(id) physicsEntityModelWithPhysicsController:(KTPhysicsController*)physicsController;
/** Creates a physics entity model with a physics controller */
-(id) initWithPhysicsController:(KTPhysicsController*)physicsController;

/** The physics controller used by this model. */
@property (nonatomic, weak) KTPhysicsController* physicsController;

/** The physics body used by this model. */
@property (nonatomic) KTPhysicsBody* physicsBody;

@end
