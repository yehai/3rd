//
//  KTTilemapObject.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import <Foundation/Foundation.h>

@class KTTilemapProperties;
@class KTTilemapPolyObject;
@class KTTilemapRectangleObject;

/** The type of Tiled object: either a rectangle, polyline or closed polygon. */
typedef enum : unsigned char
{
	KTTilemapObjectTypeUnset = 0,
	KTTilemapObjectTypeRectangle, /**< Object is a rectangle. It has no points, just position and size. */
	KTTilemapObjectTypePolygon, /**< Object is a closed polygon made up of points. It has no size and position is its first point. */
	KTTilemapObjectTypePolyLine, /**< Object is a polyline made up of points. It has no size and position is its first point. */
	KTTilemapObjectTypeTile, /**< Object is a tile. It has no points, but gid is set. */
} KTTilemapObjectType;

/** TMX "Object" - either a rectangle, open polygon (polyline) or closed polygon. Common object base class. Use the concrete
 subclasses KTTilemapPolyObject, KTTilemapRectangleObject or KTTilemapTileObject if you need access to each object type's specific properties.
 
 Note: use the objectType property (KTTilemapObjectType enum) to determine what class the object is. You can safely omit isKindOfClass and
 cast to the appropriate subclass. */
@interface KTTilemapObject : NSObject <NSCoding>
{
	@protected
	CGPoint _position;
	CGSize _size;
	@private
	KTTilemapProperties* _properties;
}

/** Name of the object. */
@property (nonatomic, copy) NSString* name;
/** The type of object assigned by the user. The type is editable in Tiled from an object's properties dialog. The Types list in Tiled is prefilled with the 
 Object Types added in the Tiled Preferences dialog. You can also import & export Object Types from there. */
@property (nonatomic, copy) NSString* userType;
/** The object's properties. */
@property (nonatomic, readonly) KTTilemapProperties* properties;
/** The position of the object (in tile coordinates). For polygons and polylines this refers to the first point of the polygon/polyline. */
@property (nonatomic) CGPoint position;
/** The size of the object (in points). For poly objects the size is the bounding box of the polygon/polyline. */
@property (nonatomic) CGSize size;
/** The type of the object, it can be either a rectangle, closed polygon, polyline or a tile. Useful for casting to the proper class without
 having to query isKindOfClass. */
@property (nonatomic) KTTilemapObjectType objectType;

// TMX Parser needs these
-(KTTilemapRectangleObject*) rectangleObjectFromPolyObject:(KTTilemapPolyObject*)polyObject;
-(void) internal_setProperties:(KTTilemapProperties *)properties;
@end

/** A polygon or polyline object. A polygon is assumed to have its last point connect with the first, the polyline does not.
 Though it's up to you how you interpret that. If you need to differentiate between the two, refer to the KTTilemapObject base class' objectType
 property. */
@interface KTTilemapPolyObject : KTTilemapObject
/** Array of CGPoint containing the points. The points are absolute coordinates with the first point identical to the object's position. */
@property (nonatomic, readonly) CGPoint* points;
/** The number of points stored in the points array. */
@property (nonatomic, readonly) unsigned int numberOfPoints;
/** The polygon's bounding box. All points of the polygon/polyline lie on or inside the boundingBox. Useful for quickly discarding collision with
 polygons because if the target object does not intersect with a polygon's bounding box, it will definitely not intersect with the polygon. */
@property (nonatomic, readonly) CGRect boundingBox;
/** (TMX Parser Only) Creates the points array from a CGPoint encoded string where string representation of CGPoint are separated by a space character.
 For example: @"0,0 -80,80 -80,160 0,200 80,200" */
-(void) makePointsFromString:(NSString*)string;
@end

/** A rectangle object, usually referred to as simply "object" in Tiled. */
@interface KTTilemapRectangleObject : KTTilemapObject
/** The rectangle as CGRect, for convenience. */
@property (nonatomic, readonly) CGRect rect;
@end

/** A tile object. */
@interface KTTilemapTileObject : KTTilemapObject
/** The GID of the tile object. */
@property (nonatomic) gid_t gid;

// TODO: property that returns tile's position in tile coordinate
@end
