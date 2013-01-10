//
//  KTTMXParser.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import <Foundation/Foundation.h>

@class KTTilemap;

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
@interface KTTMXParser : NSObject <NSXMLParserDelegate>
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
