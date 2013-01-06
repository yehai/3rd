//
//  KTBox2DPhysicsBody.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "Box2D.h"
#import "KTPhysicsBody.h"
#import "KTBox2DController.h"

/** An Objective-C interface for a Box2D body (b2Body class). The body's properties are first used to create the b2Body
 with the KTBox2DBody's initial values. After the body was created the properties return and set the body's actual values.
 */
@interface KTBox2DBody : KTPhysicsBody

/** The actual b2Body. May be nil. */
@property (nonatomic) b2Body* box2dBody;

@end
