//
//  KTDrawingPrimitives.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 18.01.13.
//
//

#import <Foundation/Foundation.h>

/** Base class for KT drawing primitives. Has the "isDrawing" flag that tells the model if this drawing primitive is currently being
 displayed by CCDrawNode. */
@interface KTDrawPrimitive : NSObject
/** Internal use only. Set when the primitive is being displayed by CCDrawNode. */
@property (nonatomic) BOOL isDrawing;
@end

/** A drawable dot with position, radius and color. Dot is drawn with the same size on Retina and non-Retina devices alike. */
@interface KTDrawDot : KTDrawPrimitive
/** Position in cocos2d coordinates. */
@property (nonatomic) CGPoint position;
/** Radius changes the size of the dot. Automatically multiplied by content scale factor on Retina devices. Defaults to 1. */
@property (nonatomic) CGFloat radius;
/** The (fill) color and transparency of the dot. Defaults to white. */
@property (nonatomic) ccColor4F color;
@end

/** A drawable line segment spanning two points (obviously) with thickness and color. Line is drawn with rounded end points, noticable with thicknesses of 2 or more.
 Line is drawn with the same thickness on Retina and non-Retina devices alike. */
@interface KTDrawLine : KTDrawPrimitive
/** One of the two end points of the line, in cocos2d coordinates. */
@property (nonatomic) CGPoint endPoint1;
/** One of the two end points of the line, in cocos2d coordinates. */
@property (nonatomic) CGPoint endPoint2;
/** Thickness changes the thickness of the line. Automatically multiplied by content scale factor on Retina devices. Defaults to 1. */
@property (nonatomic) CGFloat thickness;
/** The color and transparency of the line. */
@property (nonatomic) ccColor4F color;
@end

/** A drawable polygon spanning a number of vertices. Polygon is closed by default, ie a connection is drawn automatically between the last and first vertices,
 unless the isPolyLine flag is set in which case fillColor has no effect. Polygon is drawn with the same size and border thickness on Retina and non-Retina devices alike. */
@interface KTDrawPolygon : KTDrawPrimitive
{
	@private
	NSUInteger _numberOfPointsAllocated;
}

/** Thickness changes the thickness of the outline (border). Automatically multiplied by content scale factor on Retina devices. Defaults to 1. */
@property (nonatomic) CGFloat outlineThickness;
/** The color and transparency of the polygon's outline (border). Defaults to white. */
@property (nonatomic) ccColor4F outlineColor;
/** The color and transparency of the polygon's interior. By default the fillColor is transparent (alpha = 0) which will render as a non-filled polygon. */
@property (nonatomic) ccColor4F fillColor;
/** The color and transparency of the entire polygon. Sets both outlineColor and fillColor to the given color. Returns the fill color. */
@property (nonatomic) ccColor4F color;
/** If set the polygon is a polyline (open polygon). There is no interior area, therefore fillColor is ignored for polylines. */
@property (nonatomic) BOOL isPolyLine;

/** Returns the number of points the polygon has. */
@property (nonatomic, readonly) NSUInteger numberOfPoints;
/** Returns the vertices that make up the polygon's outline. Caution: Do not free() this buffer! */
@property (nonatomic, readonly) CGPoint* points;

/** Adds the given number of points from a point array/buffer. */
-(void) addPoints:(CGPoint*)points count:(NSUInteger)count;
/** Adds a point to the polygon. */
-(void) addPoint:(CGPoint)point;
/** Removes all points from the polygon. You can then start re-adding points. */
-(void) removeAllPoints;

/** Allocate enough memory to hold the given number of points. Speeds up adding many individual points because it avoids frequent reallocs. */
-(void) allocateMemoryForNumberOfPoints:(NSUInteger)additionalPoints;

@end