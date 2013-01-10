//
//  KTTilemapObject.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import <Foundation/Foundation.h>

typedef enum : unsigned char
{
	KTTilemapObjectPolyTypeRectangle = 0,
	KTTilemapObjectPolyTypePolygon,
	KTTilemapObjectPolyTypePolyline,
} KTTilemapObjectPolyType;

/** TMX Object */
@interface KTTilemapObject : NSObject <NSCoding>
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* points;	// temporary, should be list of CGPoint, for Polygon/Polyline
@property (nonatomic) NSMutableDictionary* properties;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGSize size;
@property (nonatomic) int gid;
@property (nonatomic) BOOL visible;
@property (nonatomic) KTTilemapObjectPolyType polyType;
@end
