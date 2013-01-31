//
//  KTBox2DShape.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 11.10.12.
//
//

#import "KTPhysicsBodyShape.h"

/** Objective-C interface to Box2D physics shapes. Subclasses from KTPhysicsBodyShape to provide concrete implementations
 of the shape properties, forwarding them to a Box2D body object. */
@interface KTBox2DShape : KTPhysicsBodyShape

@end
