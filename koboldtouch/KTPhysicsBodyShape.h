//
//  KTPhysicsBodyShape.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import <Foundation/Foundation.h>


/** The shape of a physics body determines its collisions and influences mass. */
typedef enum : int
{
	kPhysicsShapeTypeCircle = 0,
	kPhysicsShapeTypeSquare,
	kPhysicsShapeTypeRect,
	kPhysicsShapeTypePolygon,
} KTPhysicsShapeType;


@class KTPhysicsBody;

/** Shape information for a physics body. */
@interface KTPhysicsBodyShape : NSObject <NSCoding>

/** Returns a shape with default values, adds the shape to body. */
+(id) shapeWithBody:(KTPhysicsBody*)body;

/** The body this shape is attached to. */
@property (nonatomic, weak) KTPhysicsBody* body;

/** The shape of the body determines collisions but also mass. The default is a circle shape. */
@property (nonatomic) KTPhysicsShapeType shapeType;
/** The density of a body determines its mass. The greater the bodys shape and density, the more mass it has. Default is 1.0f. */
@property (nonatomic) float density;
/** The amount of friction of the body, ie how much it resists movement. Default is 0.3f. */
@property (nonatomic) float friction;
/** How much velocity is kept after collision (Box2D: restitution). Default is 0.2f.
 Note: values above 1.0f make the object go faster with every collision. A value of 0 makes the object stop (momentarily) at a collision. */
@property (nonatomic) float bounce;
/** Radius of the circle or square collision shapes. For square shapes, radius determines the size of the box by the inner radius
 (radius circle touching sides), not the other radius (radius circle intersects with corners). Default is 0.5f. */
@property (nonatomic) float radius;
@end
