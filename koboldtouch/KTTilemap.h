//
//  KTTilemap.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//
//

#import <Foundation/Foundation.h>

#import "KTTilemapTileset.h"
#import "KTTilemapLayer.h"
#import "KTTilemapLayerTiles.h"
#import "KTTilemapObject.h"
#import "KTTypes.h"

@class KTTilemap;
@class KTTilemapTileset;
@class KTTilemapProperties;

/** Tilemap orientation: orthogonal (rectangular tiles), isometric (diamond/rhombus shaped tiles) and hexagonal (hexagon shaped tiles). */
typedef enum : unsigned char
{
	KTTilemapOrientationOrthogonal, /**< An orthogonal tilemap */
	KTTilemapOrientationIsometric,/**< An isometric tilemap */
	KTTilemapOrientationHexagonal,/**< A hexagonal tilemap */
} KTTilemapOrientation;


/** Represents a TMX Tilemap "map", ie global properties. The tilemap is usually created from a TMX file via the parseTMXFile method. */
@interface KTTilemap : NSObject <NSCoding>
{
	@private
	NSMutableArray* _tilesets;
	NSMutableArray* _layers;
	KTTilemapProperties* _properties;
}

/** The size of the map, in tiles. */
@property (nonatomic) CGSize mapSize;
/** The size of the "grid", meaning: the height & width of the tiles (in points). Can only be set in Tiled when a new tilemap is created. In the
 New Map dialog the gridSize is called "Tile Size". */
@property (nonatomic) CGSize gridSize;
/** The map's global properties. Editable in Tiled from the menu: Map -> Map Properties. */
@property (nonatomic, readonly) KTTilemapProperties* properties;

/** List of tilesets (KTTilemapTileset) used by this map. */
@property (nonatomic, readonly) NSArray* tilesets;
/** List of layers (KTTilemapLayer) used by this map, in the draw order respectively the reverse order they appear 
 in Tiled's Layers list (bottom-most = first, top-most = last). */
@property (nonatomic, readonly) NSArray* layers;
/** The orientiation (type) of tilemap. */
@property (nonatomic) KTTilemapOrientation orientation;

/** Parse and create a KTTilemap from a TMX file. */
+(id) tilemapWithTMXFile:(NSString*)tmxFile;

/** Creates an empty tilemap. Use this if you want to create your tilemap world entirely in code. */
+(id) tilemapWithOrientation:(KTTilemapOrientation)orientation mapSize:(CGSize)mapSize gridSize:(CGSize)gridSize;

/** Adds a tileset to the list of tilesets. */
-(void) addTileset:(KTTilemapTileset*)tileset;

/** Returns the tileset for a specific gid. Mainly to access that tile's properties. Will return nil for invalid gids (gid that points to a non-existing tileset,
 or if gid is 0). */
-(KTTilemapTileset*) tilesetForGid:(gid_t)gid;

/** Adds a tileset to the list of tilesets. */
-(void) addLayer:(KTTilemapLayer*)layer;

/** Returns the first layer with the given name, or nil if there's no layer with that name. Layer names are case-sensitive! */
-(KTTilemapLayer*) layerByName:(NSString*)name;

@end

