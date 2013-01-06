//
//  KTPhysicsBody.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import <Foundation/Foundation.h>
#import "KTTypes.h"
#import "KTPhysicsController.h"
#import "KTPhysicsBodyCollisionProtocol.h"
#import "KTPhysicsBodyShape.h"

/** The type of a physics body determines its behavior. */
typedef enum : int
{
	kPhysicsBodyTypeDynamic = 0,
	kPhysicsBodyTypeKinematic,
	kPhysicsBodyTypeStatic,
} KTPhysicsBodyType;


@class KTPhysicsEntityModel;

/** Wraps the low-level implementation of a physics body and hides implementation details of the underlying physics engine.
 Exposes the common properties and methods as an ObjC interface. Performs conversions where necessary, for example
 points to meters (position) and radians to degrees (rotation). */
@interface KTPhysicsBody : NSObject <NSCoding>
{
	NSMutableArray* _shapes;
}

/** Creates a physics body with a physics controller. */
+(id) bodyWithPhysicsController:(KTPhysicsController*)physicsController;
-(id) initWithPhysicsController:(KTPhysicsController*)physicsController; // Not to be used directly!

/** The physics controller managing this physics body. */
@property (nonatomic, weak) KTPhysicsController* physicsController;
/** An optional collision delegate implementing the KTPhysicsBodyCollisionProtocol. */
@property (nonatomic, weak) id<KTPhysicsBodyCollisionProtocol> collisionDelegate;

/** The body's model object. May be nil. */
@property (nonatomic, weak) KTPhysicsEntityModel* model;

/** The current position of the entity, in game world coordinates. */
@property (nonatomic) CGPoint position;
/** The current rotation of the entity, in degrees. */
@property (nonatomic) float rotation;
/** The type of the body. Default is "dynamic". */
@property (nonatomic) KTPhysicsBodyType bodyType;
/** linear velocity (speed, expressed as a vector) */
@property (nonatomic) CGPoint linearVelocity;
@property (nonatomic) float linearDamping;
@property (nonatomic) float angularVelocity;
@property (nonatomic) float angularDamping;
@property (nonatomic) float gravityScale;
/** Allow bodies that haven't collided or moved for a preset amount of time to sleep. During sleep they will not move.
 Sleeping bodies automatically wake up when forces act on them again. */
@property (nonatomic) BOOL isSleepingAllowed;
/** A body is awake when it is moving or in contact with other bodies. It falls asleep when it's state hasn't changed
 for a preset amount of time to conserve computing power. It will wake up again when colliding or forced to move. */
@property (nonatomic) BOOL isAwake;
/** Active bodies can move and collide, inactive bodies don't. */
@property (nonatomic) BOOL isActive;
/** If true, the body won't ever rotate. */
@property (nonatomic) BOOL isFixedRotation;
/** If enabled, body uses continuous collision detection to prevent tunneling through other dynamic bodies when moving
 at high velocity (ie bullets). This flag increases processing time, only use when you notice a fast moving dynamic body
 not colliding with another dynamic body when they should have collided. */
@property (nonatomic) BOOL preventTunneling;


/** Returns first shape of the body. Convenience accessor since most bodies only have a single shape. */
@property (nonatomic, readonly) KTPhysicsBodyShape* firstShape;

/** Adds a shape to the body. */
-(void) addShape:(KTPhysicsBodyShape*)shape;

@end
