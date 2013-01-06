//
//  KTPhysicsBodyCollisionProtocol.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#ifndef Kobold2D_Libraries_KTPhysicsBodyCollisionProtocol_h
#define Kobold2D_Libraries_KTPhysicsBodyCollisionProtocol_h

/** @file KTTPhysicsBodyCollisionProtocol.h */

@class KTPhysicsBody;

/** Contact phases for collision callbacks. */
typedef enum
{
	kPhysicsContactPhaseBegan,
	kPhysicsContactPhaseEnded,
} KTPhysicsContactPhase;

/** Defines collision callback methods to be implemented by a model object. */
@protocol KTPhysicsBodyCollisionProtocol <NSObject>
@required
/** Informs about a contact with another body. The otherBody is in contact with the model's body. */
-(void) contactWithOtherBody:(KTPhysicsBody*)otherBody phase:(KTPhysicsContactPhase)phase;;
@optional
// TODO: pre & post solve
@end

#endif
