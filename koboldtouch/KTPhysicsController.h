//
//  KTPhysicsController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTController.h"
#import "KTTypes.h"

@class KTPhysicsBody;

/** This protocol only exists so the compiler can warn about renamed methods and properties in the base class that
 are no longer implemented in the subclass. Otherwise one might think to have overridden a super class method but
 since the method was renamed, it actually never gets called. */
@protocol KTPhysicsControllerProtocol <NSObject>
// World
-(void) createWorld;
-(void) destroyWorld;
@property (nonatomic) CGPoint gravity;

// Bodies
-(void) addBody:(KTPhysicsBody*)physicsBody;
-(void) removeBody:(KTPhysicsBody*)physicsBody;
@end

/** Abstract base class for Physics Controllers defining the common interface for physics engines. */
@interface KTPhysicsController : KTController <KTPhysicsControllerProtocol>
{
@protected
	NSMutableSet* _bodiesToAdd;
	NSMutableSet* _bodiesToRemove;
}

/** Initializes physics controller with Box2D physics. */
+(id) physicsControllerWithBox2D;

/** Constrains the physics world to window borders. On iOS this is typically the same as the screen size.
 The world constraint can not be changed once set.
 \warning: Bodies can still be created outside this area, or under some circumstances "aqueezed" outside of this box if body
 experiences extreme forces or is moving at very high velocity. */
-(void) constrainWorldToWindow;

/** Creates a static container that prevents bodies from moving outside this area. The world constraint can not be changed once set. 
 \warning: Bodies can still be created outside this area, or under some circumstances "aqueezed" outside of this box if body
 experiences extreme forces or is moving at very high velocity. */
-(void) constrainWorldToRect:(CGRect)worldConstraint;

/** Returns the world constraint rectangle. It can not be changed once set. */
@property (nonatomic, readonly) CGRect worldConstraint;

/** The fixed delta time by which to forward the physics engine every frame. Default is 0.0167f (1/60). */
@property (nonatomic) float timeStep;

// internal callbacks
-(void) removeScheduledToBeRemovedBodies;
-(void) addScheduledToBeAddedBodies;

@end
