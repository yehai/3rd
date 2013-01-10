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

@class KTTilemap;
@class CCTexture2D;

typedef enum : unsigned char
{
	KTTilemapOrientationOrthogonal,
	KTTilemapOrientationIsometric,
	KTTilemapOrientationHexagonal,
} KTTilemapOrientation;


/** Represents a Tilemap. The tilemap is usually created from a TMX file via the parseTMXFile method. */
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

