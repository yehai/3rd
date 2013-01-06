//
//  KTTilemap.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//
//

#import <Foundation/Foundation.h>

@class KTTilemap;
@class CCTexture2D;

/** TMX Tileset */
@interface KTTilemapTileset : NSObject <NSCoding>
{
	@private
	__weak CCTexture2D* _texture;
	unsigned int _textureRectCount;
	CGRect* _textureRects;
}
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* imageFile;
@property (nonatomic) unsigned int firstGid;
@property (nonatomic) unsigned int lastGid;
@property (nonatomic) unsigned int tilesPerRow;
@property (nonatomic) unsigned int tilesPerColumn;
@property (nonatomic) int spacing;
@property (nonatomic) int margin;
@property (nonatomic) CGPoint drawOffset;
@property (nonatomic) CGSize tileSize;
@property (nonatomic, readonly) CCTexture2D* texture;
-(CGRect) textureRectForGid:(unsigned int)gid;
@end

typedef enum : uint32_t
{
	KTTilemapTileHorizontalFlip		= 0x80000000,
	KTTilemapTileVerticalFlip		= 0x40000000,
	KTTilemapTileDiagonalFlip		= 0x20000000,
	KTTilemapTileFlippedAll			= (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip | KTTilemapTileDiagonalFlip),
	KTTilemapTileFlipMask			= ~(KTTilemapTileFlippedAll),
} KTTilemapTileFlip;

/** TMX Layer Tiles */
@interface KTTilemapLayerTiles : NSObject <NSCoding>
@property (nonatomic, weak) KTTilemapTileset* tileset;
@property (nonatomic) uint32_t* gid;
-(id) initWithTiles:(uint32_t*)tiles tilemap:(KTTilemap*)tilemap;
@end

/** TMX Tile Layer */
@interface KTTilemapLayer : NSObject <NSCoding>
@property (nonatomic, copy) NSString* name;
@property (nonatomic) NSMutableArray* objects;
@property (nonatomic) NSMutableDictionary* properties;
@property (nonatomic, weak) KTTilemap* tilemap;
@property (nonatomic) KTTilemapLayerTiles* tiles;
@property (nonatomic) CGSize size;
@property (nonatomic) unsigned int tilesCount;
@property (nonatomic) int opacity;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL isObjectLayer;
// x/y defaults to 0/0 - none of these values can be changed in Tiled, thus they don't appear here
-(unsigned int) tileAt:(CGPoint)tilePos;
-(unsigned int) tileWithFlagsAt:(CGPoint)tilePos;
@end

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

typedef enum : unsigned char
{
	KTTilemapOrientationOrthogonal,
	KTTilemapOrientationIsometric,
	KTTilemapOrientationHexagonal,
} KTTilemapOrientation;

/** TMX Tilemap */
@interface KTTilemap : NSObject <NSXMLParserDelegate, NSCoding>
@property (nonatomic) CGSize mapSize;
@property (nonatomic) CGSize gridSize;
@property (nonatomic) NSMutableDictionary* properties;
@property (nonatomic) NSMutableArray* tilesets;
@property (nonatomic) NSMutableDictionary* tileProperties;
@property (nonatomic) NSMutableArray* layers;
@property (nonatomic) KTTilemapOrientation orientation;
-(void) parseTMXFile:(NSString*)tmxFile;
@end


// Parsing only
typedef enum
{
	KTTilemapParsingElementNone,
	KTTilemapParsingElementMap,
	KTTilemapParsingElementLayer,
	KTTilemapParsingElementObjectGroup,
	KTTilemapParsingElementObject,
	KTTilemapParsingElementTile,
} KTTilemapParsingElement;

typedef enum
{
	KTTilemapDataFormatNone = 1 << 0,
	KTTilemapDataFormatBase64 = 1 << 1,
	KTTilemapDataFormatGzip = 1 << 2,
	KTTilemapDataFormatZlib = 1 << 3,
} KTTilemapDataFormat;

// internal use only
@interface KTTilemapParser : NSObject <NSXMLParserDelegate>
{
@private
	KTTilemap* _tilemap;
	NSString* _tmxFile;
	NSMutableString* _dataString;
	NSNumberFormatter* _numberFormatter;
	int _parsingTileGid;
	KTTilemapParsingElement _parsingElement;
	KTTilemapDataFormat _dataFormat;
	BOOL _loadingData;
}
-(void) parseTMXFile:(NSString*)tmxFile tilemap:(KTTilemap*)tilemap;
@end
