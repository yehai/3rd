//
//  KTTMXParser.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTypes.h"

@class KTTilemap;
@class KTTilemapTileset;
@class KTTilemapLayer;
@class KTTilemapObject;

typedef enum
{
	KTTilemapParsingElementNone,
	KTTilemapParsingElementMap,
	KTTilemapParsingElementLayer,
	KTTilemapParsingElementObjectGroup,
	KTTilemapParsingElementObject,
	KTTilemapParsingElementTile,
	KTTilemapParsingElementTileset,
} KTTilemapParsingElement;

typedef enum
{
	KTTilemapDataFormatNone = 1 << 0,
	KTTilemapDataFormatBase64 = 1 << 1,
	KTTilemapDataFormatGzip = 1 << 2,
	KTTilemapDataFormatZlib = 1 << 3,
} KTTilemapDataFormat;

/** Internal use only. Temporary object that parses a TMX file and creates the KTTilemap hierarchy containing KTTilemapTileset, 
 KTTilemapLayer, KTTilemapLayerTiles and KTTilemapObject. Used by KTTilemap which has its own parseTMX method. Not meant to be subclassed
 or modified. */
@interface KTTMXParser : NSObject <NSXMLParserDelegate>
{
@private
	KTTilemap* _tilemap;
	NSString* _tmxFile;
	NSMutableString* _dataString;
	NSNumberFormatter* _numberFormatter;

	KTTilemapTileset* _parsingTileset;
	KTTilemapLayer* _parsingLayer;
	KTTilemapObject* _parsingObject;
	gid_t _parsingTileGid;
	KTTilemapParsingElement _parsingElement;
	KTTilemapDataFormat _dataFormat;
	BOOL _parsingData;
}

-(void) parseTMXFile:(NSString*)tmxFile tilemap:(KTTilemap*)tilemap;

@end
