//
//  KTTMXParser.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTMXParser.h"
#import "KTTilemap.h"
#import "KTTilemapProperties.h"
#import "KTTilemapTileProperties.h"
#import "KTMutableNumber.h"

#import "base64.h"
#import "ZipUtils.h"


@implementation KTTMXParser

-(id) init
{
	self = [super init];
	if (self)
	{
		_numberFormatter = [[NSNumberFormatter alloc] init];
		[_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		// Why not make it locale-aware? Because it would make TMX maps created by US developers unusable by
		// devs in other countries whose decimal separator is not a dot but a comma.
		[_numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
	}
	return self;
}

-(void) parseTMXFile:(NSString*)tmxFile tilemap:(KTTilemap*)tilemap
{
	_tilemap = tilemap;
	_tmxFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:tmxFile];
	
	NSURL* url = [NSURL fileURLWithPath:_tmxFile];
	NSData* data = [NSData dataWithContentsOfURL:url];
	[self parseTMXWithData:data];
	
	_tmxFile = nil;
}

-(void) parseTMXString:(NSString*)tmxString
{
	NSData* data = [tmxString dataUsingEncoding:NSUTF8StringEncoding];
	[self parseTMXWithData:data];
}

-(void) parseTMXWithData:(NSData*)data
{
	NSAssert(data, @"can't parse TMX, data is nil");
	
	_dataString = [NSMutableString stringWithCapacity:4096];
	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	parser.shouldProcessNamespaces = NO;
	parser.shouldReportNamespacePrefixes = NO;
	parser.shouldResolveExternalEntities = NO;
	[parser parse];
	
	_dataString = nil;
	_parsingLayer = nil;
	_parsingObject = nil;
	_parsingTileset = nil;
}

-(id) valueFromString:(NSString*)string
{
	LOG_EXPR(string);
	LOG_EXPR(@" this method to be removed ");
	return string;
}

-(void) parseMapWithAttributes:(NSDictionary*)attributes
{
	NSAssert([[attributes objectForKey:@"version"] isEqualToString:@"1.0"],
			 @"unsupported TMX version: %@", [attributes objectForKey:@"version"]);
	
	NSString* orientationAttribute = [attributes objectForKey:@"orientation"];
	if ([orientationAttribute isEqualToString:@"orthogonal"])
		_tilemap.orientation = KTTilemapOrientationOrthogonal;
	else if ([orientationAttribute isEqualToString:@"isometric"])
		_tilemap.orientation = KTTilemapOrientationIsometric;
	else if ([orientationAttribute isEqualToString:@"hexagonal"])
		_tilemap.orientation = KTTilemapOrientationHexagonal;
	else
		[NSException raise:@"unsupported TMX orientation" format:@"unsupported TMX orientation: %@", orientationAttribute];
	
	CGSize mapSize;
	mapSize.width = [[attributes objectForKey:@"width"] intValue];
	mapSize.height = [[attributes objectForKey:@"height"] intValue];
	_tilemap.mapSize = mapSize;
	
	CGSize gridSize;
	gridSize.width = [[attributes objectForKey:@"tilewidth"] intValue];
	gridSize.height = [[attributes objectForKey:@"tileheight"] intValue];
	_tilemap.gridSize = gridSize;
	
	_parsingElement = KTTilemapParsingElementMap;
}

-(void) parseTilesetWithAttributes:(NSDictionary*)attributes
{
	// If this is an external tileset then start parsing that
	NSString* externalTilesetFilename = [attributes objectForKey:@"source"];
	if (externalTilesetFilename)
	{
		// Tileset file will be relative to the map file. So we need to convert it to an absolute path
		NSString* dir = [_tmxFile stringByDeletingLastPathComponent];
		externalTilesetFilename = [dir stringByAppendingPathComponent:externalTilesetFilename];
		[self parseTMXFile:externalTilesetFilename tilemap:_tilemap];
	}
	else
	{
		KTTilemapTileset* tileset = [[KTTilemapTileset alloc] init];
		tileset.name = [attributes objectForKey:@"name"];
		tileset.firstGid = (gid_t)[[attributes objectForKey:@"firstgid"] intValue];
		tileset.spacing = [[attributes objectForKey:@"spacing"] intValue];
		tileset.margin = [[attributes objectForKey:@"margin"] intValue];
		tileset.transparentColor = [attributes objectForKey:@"trans"];
		CGSize tileSize;
		tileSize.width = [[attributes objectForKey:@"tilewidth"] intValue];
		tileSize.height = [[attributes objectForKey:@"tileheight"] intValue];
		tileset.tileSize = tileSize;
		[_tilemap addTileset:tileset];
		_parsingTileset = tileset;
		_parsingElement = KTTilemapParsingElementTileset;
	}
}

-(void) parseTilesetTileOffsetWithAttributes:(NSDictionary*)attributes
{
	CGPoint offset;
	offset.x = [[attributes objectForKey:@"x"] intValue];
	offset.y = [[attributes objectForKey:@"y"] intValue];
	_parsingTileset.drawOffset = offset;
}

-(void) parseTilesetImageWithAttributes:(NSDictionary*)attributes
{
	NSString* source = [attributes objectForKey:@"source"];
	_parsingTileset.imageFile = [source lastPathComponent];
}

-(void) parseTilesetTileWithAttributes:(NSDictionary*)attributes
{
	_parsingTileGid = _parsingTileset.firstGid + (gid_t)[[attributes objectForKey:@"id"] intValue];
	_parsingElement = KTTilemapParsingElementTile;
}

-(void) parseLayerWithAttributes:(NSDictionary*)attributes
{
	KTTilemapLayer* layer = [[KTTilemapLayer alloc] init];
	layer.tilemap = _tilemap;
	layer.isTileLayer = YES;
	layer.name = [attributes objectForKey:@"name"];
	layer.visible = ![[attributes objectForKey:@"visible"] isEqualToString:@"0"];
	layer.opacity = 255;
	NSString* opacity = [attributes objectForKey:@"opacity"];
	if (opacity)
	{
		layer.opacity = (unsigned char)(255.0f * [opacity floatValue] + 0.5f);
	}
	
	CGSize layerSize;
	layerSize.width = [[attributes objectForKey:@"width"] intValue];
	layerSize.height = [[attributes objectForKey:@"height"] intValue];
	layer.size = layerSize;
	layer.tileCount = layerSize.width * layerSize.height;
	[_tilemap addLayer:layer];
	
	_parsingLayer = layer;
	_parsingElement = KTTilemapParsingElementLayer;
}

-(void) parseObjectGroupWithAttributes:(NSDictionary*)attributes
{
	KTTilemapLayer* layer = [[KTTilemapLayer alloc] init];
	layer.tilemap = _tilemap;
	layer.isObjectLayer = YES;
	layer.name = [attributes objectForKey:@"name"];
	layer.opacity = 255;
	NSString* opacity = [attributes objectForKey:@"opacity"];
	if (opacity)
	{
		layer.opacity = (unsigned char)(255.0f * [opacity floatValue]);
	}
	
	// Tiled quirk: object layers only write visible="0" to TMX when not visible, otherwise visible is simply omitted from TMX file
	layer.visible = YES;
	NSString* visible = [attributes objectForKey:@"visible"];
	if (visible)
	{
		layer.visible = ![visible isEqualToString:@"0"];
	}
	[_tilemap addLayer:layer];
	
	_parsingLayer = layer;
	_parsingElement = KTTilemapParsingElementObjectGroup;
}

-(void) parseObjectWithAttributes:(NSDictionary*)attributes
{
	KTTilemapObject* object = nil;

	// determine type of object first
	if ([attributes objectForKey:@"gid"])
	{
		KTTilemapTileObject* tileObject = [[KTTilemapTileObject alloc] init];
		tileObject.gid = (gid_t)[[attributes objectForKey:@"gid"] intValue];
		tileObject.size = _tilemap.gridSize;
		object = tileObject;
	}
	else if ([attributes objectForKey:@"width"] || [attributes objectForKey:@"height"])
	{
		KTTilemapRectangleObject* rectObject = [[KTTilemapRectangleObject alloc] init];
		rectObject.size = CGSizeMake([[attributes objectForKey:@"width"] intValue], [[attributes objectForKey:@"height"] intValue]);
		object = rectObject;
	}
	else
	{
		KTTilemapPolyObject* polyObject = [[KTTilemapPolyObject alloc] init];
		polyObject.objectType = KTTilemapObjectTypeUnset;	// it could be a zero-sized rectangle object
		object = polyObject;
	}
	
	object.name = [attributes objectForKey:@"name"];
	object.userType = [attributes objectForKey:@"type"];
	
	CGPoint position;
	position.x = [[attributes objectForKey:@"x"] intValue];
	position.y = [[attributes objectForKey:@"y"] intValue];
	// Correct y position. (Tiled uses Y origin on top extending downward, cocos2d has Y origin at bottom extending upward)
	position.y = (_tilemap.mapSize.height * _tilemap.gridSize.height) - position.y /*- _tilemap.gridSize.height*/;
	if (object.objectType == KTTilemapObjectTypeRectangle)
	{
		// rectangles have their origin point at the upper left corner, but we need it to be in the lower left corner
		position.y -= object.size.height;
	}
	object.position = position;

	_parsingObject = object;
	_parsingElement = KTTilemapParsingElementObject;
}

-(void) parsePolygonWithAttributes:(NSDictionary*)attributes
{
	[(KTTilemapPolyObject*)_parsingObject makePointsFromString:[attributes objectForKey:@"points"]];
	_parsingObject.objectType = KTTilemapObjectTypePolygon;
}

-(void) parsePolyLineWithAttributes:(NSDictionary*)attributes
{
	[(KTTilemapPolyObject*)_parsingObject makePointsFromString:[attributes objectForKey:@"points"]];
	_parsingObject.objectType = KTTilemapObjectTypePolyLine;
}

-(void) addParsingObjectToLayer
{
	// Add the object to the object Layer
	NSAssert2(_parsingLayer.isObjectLayer, @"ERROR adding object %@: parsing layer (%@) is not an object layer", _parsingObject, _parsingLayer);
	if (_parsingObject.objectType == KTTilemapObjectTypeUnset)
	{
		// we have a zero-sized rectangle object, replace parsing object
		_parsingObject = [_parsingObject rectangleObjectFromPolyObject:(KTTilemapPolyObject*)_parsingObject];
	}

	[_parsingLayer addObject:_parsingObject];
}

-(void) parsePropertyWithAttributes:(NSDictionary*)attributes
{
	switch (_parsingElement)
	{
		case KTTilemapParsingElementMap:
		{
			[_tilemap.properties setValue:[attributes objectForKey:@"value"] forKey:[attributes objectForKey:@"name"]];
			break;
		}
		case KTTilemapParsingElementLayer:
		case KTTilemapParsingElementObjectGroup:
		{
			[_parsingLayer.properties setValue:[attributes objectForKey:@"value"] forKey:[attributes objectForKey:@"name"]];
			break;
		}
		case KTTilemapParsingElementObject:
		{
			[_parsingObject.properties setValue:[attributes objectForKey:@"value"] forKey:[attributes objectForKey:@"name"]];
			break;
		}
		case KTTilemapParsingElementTile:
		{
			[_parsingTileset.tileProperties propertiesForGid:_parsingTileGid setValue:[attributes objectForKey:@"value"] forKey:[attributes objectForKey:@"name"]];
			break;
		}
		case KTTilemapParsingElementTileset:
		{
			[_parsingTileset.properties setValue:[attributes objectForKey:@"value"] forKey:[attributes objectForKey:@"name"]];
			break;
		}
			
		default:
			NSLog(@"TMX Parser: parsing element is unsupported. Cannot add attribute named '%@' with value '%@'",
				  [attributes objectForKey:@"name"], [attributes objectForKey:@"value"] );
			break;
	}
}

-(void) parseDataWithAttributes:(NSDictionary*)attributes
{
	NSString* encoding = [attributes objectForKey:@"encoding"];
	NSString* compression = [attributes objectForKey:@"compression"];
	
	NSAssert([encoding isEqualToString:@"base64"], @"TMX tile layers must be Base64 encoded. Change the encoding in Tiled preferences.");
	NSAssert1([compression isEqualToString:@"gzip"] || [compression isEqualToString:@"zlib"],
			  @"TMX: unsupported tile layer compression method: %@. Change compression in Tiled preferences, zlib is recommended.", compression);
	
	if ([encoding isEqualToString:@"base64"])
	{
		_parsingData = YES;
		_dataFormat |= KTTilemapDataFormatBase64;
		
		if ([compression isEqualToString:@"gzip"])
		{
			_dataFormat |= KTTilemapDataFormatGzip;
		}
		else if ([compression isEqualToString:@"zlib"])
		{
			_dataFormat |= KTTilemapDataFormatZlib;
		}
	}
}

-(void) loadTileLayerTiles
{
	unsigned char* tileGidBuffer;
	unsigned int tileGidBufferSize = base64Decode((unsigned char*)[_dataString UTF8String], (unsigned int)_dataString.length, &tileGidBuffer);
	if (tileGidBuffer == NULL)
	{
		[NSException raise:@"TMX decode error" format:@"TMX decoding data of layer (%@) failed", _parsingLayer];
	}
	
	if (_dataFormat & (KTTilemapDataFormatGzip | KTTilemapDataFormatZlib))
	{
		// deflate the buffer if it is in compressed format
		unsigned char* deflatedTileGidBuffer;
		CGSize mapSize = _tilemap.mapSize;
		unsigned int expectedSize = mapSize.width * mapSize.height * sizeof(gid_t);
		unsigned int deflatedTileGidBufferSize = ccInflateMemoryWithHint(tileGidBuffer, tileGidBufferSize, &deflatedTileGidBuffer, expectedSize);
		NSAssert2(deflatedTileGidBufferSize == expectedSize, @"TMX data decode: hint mismatch! (got: %i, expected: %i)", deflatedTileGidBufferSize, expectedSize);
		
		// free the compressed buffer, we don't need this anymore
		free(tileGidBuffer);
		
		if (deflatedTileGidBuffer == NULL)
		{
			[NSException raise:@"TMX decode error" format:@"TMX deflating data of layer (%@) failed", _parsingLayer];
		}
		
		[_parsingLayer.tiles takeOwnershipOfGidBuffer:(gid_t*)deflatedTileGidBuffer bufferSize:deflatedTileGidBufferSize];
	}
	else
	{
		// the buffer is not compressed and can be used directly
		[_parsingLayer.tiles takeOwnershipOfGidBuffer:(gid_t*)tileGidBuffer bufferSize:tileGidBufferSize];
	}

	[_dataString setString:@""];
	_parsingData = NO;
}

-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName
  namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qualifiedName
	attributes:(NSDictionary*)attributes
{
	// sorted by expected number of appearances in an average TMX file
	if ([elementName isEqualToString:@"object"])
	{
		[self parseObjectWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"polygon"])
	{
		[self parsePolygonWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"polyline"])
	{
		[self parsePolyLineWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"property"])
	{
		[self parsePropertyWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"tileset"])
	{
		[self parseTilesetWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"image"])
	{
		[self parseTilesetImageWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"tile"])
	{
		[self parseTilesetTileWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"layer"])
	{
		[self parseLayerWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"data"])
	{
		[self parseDataWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"objectgroup"])
	{
		[self parseObjectGroupWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"tileoffset"])
	{
		[self parseTilesetTileOffsetWithAttributes:attributes];
	}
	else if ([elementName isEqualToString:@"map"])
	{
		[self parseMapWithAttributes:attributes];
	}
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName
  namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qualifiedName
{
	if ([elementName isEqualToString:@"data"] && (_dataFormat & KTTilemapDataFormatBase64))
	{
		[self loadTileLayerTiles];
	}
	else if ([elementName isEqualToString:@"map"] || [elementName isEqualToString:@"layer"] ||
			 [elementName isEqualToString:@"objectgroup"] || [elementName isEqualToString:@"object"] ||
			 [elementName isEqualToString:@"tile"] || [elementName isEqualToString:@"tileset"])
	{
		if (_parsingElement == KTTilemapParsingElementObject)
		{
			[self addParsingObjectToLayer];
		}
		
		_parsingElement = KTTilemapParsingElementNone;
	}
}

-(void) parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
	if (_parsingData)
	{
		[_dataString appendString:string];
	}
}

-(void) parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
	[NSException raise:@"TMX Parse Error!" format:@"TMX Parse Error! File: %@ - Description: %@ - Reason: %@ - Suggestion: %@",
	 _tmxFile, parseError.localizedDescription, parseError.localizedFailureReason, parseError.localizedRecoverySuggestion];
}

@end
