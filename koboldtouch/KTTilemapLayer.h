//
//  KTTilemapLayer.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import <Foundation/Foundation.h>

@class KTTilemap;
@class KTTilemapTileset;
@class KTTilemapLayerTiles;
@class KTTilemapProperties;
@class KTTilemapObject;

/** TMX Layer data. Can be either a tile or object layer. Depending on which it is not all properties are used, this is noted in the property descriptions. */
@interface KTTilemapLayer : NSObject <NSCoding>
{
	@private
	KTTilemapProperties* _properties;
	KTTilemapLayerTiles* _tiles;
	NSMutableArray* _objects;
}

/** The name of the layer. */
@property (nonatomic, copy) NSString* name;
/** The layer's properties. */
@property (nonatomic, readonly) KTTilemapProperties* properties;
/** Reference to the tilemap to allow KTTileLayerViewController and KTObjectLayerViewController quick access to the KTTilemap object. */
@property (nonatomic, weak) KTTilemap* tilemap;

/** (Object Layers Only) A list of "objects" on this layer. These "objects" are Tiled's rectangles, polylines and polygons. They can be used to position
 tilemap objects not editable in Tiled by (normally) using the first point of such an "object" as the origin for the actual game object.
 Always nil for tile layers. */
@property (nonatomic, readonly) NSArray* objects;

/** (Tile Layers Only) Reference to the KTTilemapLayerTiles object which contains the memory buffer for the tile GIDs of this tile layer. Always nil
 for object layers. */
@property (nonatomic, readonly) KTTilemapLayerTiles* tiles;
/** (Tile Layers Only) The layer's size (in tiles). Since Tiled does not support layers having different sizes as the map itself, the layer size is identical
 to the mapSize property of KTTilemap. */
@property (nonatomic) CGSize size;
/** (Tile Layers Only) How many tiles there are in this layer. Simply the product of size.width * size.height. Merely an optimization artifact. */
@property (nonatomic) unsigned int tileCount;

/** How opaque the layer is. Uses cocos2d's "opacity" values which go from 0 (fully transparent) to 255 (fully opaque).
 The opacity of a layer can be set in Tiled by moving the Opacity slider just above the Layers list. */
@property (nonatomic) unsigned char opacity;
/** Is set if this layer is an Object Layer. If NO it is a Tile Layer. */
@property (nonatomic) BOOL isObjectLayer;
/** Is set if this layer is a Tile Layer. If NO it is a Object Layer. */
@property (nonatomic) BOOL isTileLayer;
/** Whether the tiles on this layer are visible or not. If a tile layer is not visible, it will still create the tiles and therefore
 use the same memory as if the tiles were visible. */
@property (nonatomic) BOOL visible;
/** If YES, this layer will scroll endlessly, repeating itself (wrap around) at map borders. */
@property (nonatomic) BOOL endlessScrolling;

/** Returns the tile GID at a specific tile coordinate, without the flip flags normally encoded in the GID. Returns 0 if there is no tile set at this coordinate
 (empty tile) or if the tile coordinate is outside the boundaries of the layer. */
-(gid_t) tileGidAt:(CGPoint)tilePos;
/** Like tileAt but returns the GID including the KTTilemapTileFlip flags. To get just the GID from the returned value use tileAt or mask out
 the flip flags: gid = (gidWithFlags & KTTilemapTileFlipMask) - you don't normally need the flip flags unless they have some meaning in your game,
 for example if certain tile GIDs can only be operated from one side (ie a button tile that the player must approach from the correct side to operate it). */
-(gid_t) tileGidWithFlagsAt:(CGPoint)tilePos;

/** Adds a tilemap object if the layer is an object layer. Ignored if the layer is a tile layer. */
-(void) addObject:(KTTilemapObject*)object;
/** Removes a tilemap object if the layer is an object layer. Ignored if the layer is a tile layer, or layer does not contain object. */
-(void) removeObject:(KTTilemapObject*)object;
/** Returns the object at the given index. Returns nil if object does not exist or the index is out of bounds (contrary to NSArray which would raise an exception). */
-(KTTilemapObject*) objectAtIndex:(NSUInteger)index;
/** Returns the first object with the given name, or nil if there's no object with this name on this layer. Object names are case-sensitive! */
-(KTTilemapObject*) objectByName:(NSString*)name;

@end
