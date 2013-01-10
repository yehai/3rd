//
//  KTTMXParser.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTMXParser.h"
#import "KTTilemap.h"
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
	
	_dataString = [NSMutableString stringWithCapacity:1024];
	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	parser.shouldProcessNamespaces = NO;
	parser.shouldReportNamespacePrefixes = NO;
	parser.shouldResolveExternalEntities = NO;
	[parser parse];
	
	_dataString = nil;
	
	[self postProcessing];
}

// update additional fields derived only after loading the TMX file
-(void) postProcessing
{
	// ...
}

-(id) valueFromString:(NSString*)string
{
	NSNumber* number = [_numberFormatter numberFromString:string];
	if (number)
	{
		if (number.objCType[0] == 'f' || number.objCType[0] == 'd')
		{
			return [KTMutableNumber numberWithFloat:number.floatValue];
		}
		else
		{
			return [KTMutableNumber numberWithInt:number.intValue];
		}
	}
	return string;
}

-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName
  namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qualifiedName
	attributes:(NSDictionary*)attributes
{
	//NSLog(@"Element: %@ with attributes: %@", elementName, attributes);
	
	if ([elementName isEqualToString:@"map"])
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
	else if ([elementName isEqualToString:@"tileset"])
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
			tileset.firstGid = [[attributes objectForKey:@"firstgid"] intValue];
			tileset.spacing = [[attributes objectForKey:@"spacing"] intValue];
			tileset.margin = [[attributes objectForKey:@"margin"] intValue];
			CGSize tileSize;
			tileSize.width = [[attributes objectForKey:@"tilewidth"] intValue];
			tileSize.height = [[attributes objectForKey:@"tileheight"] intValue];
			tileset.tileSize = tileSize;
			[_tilemap.tilesets addObject:tileset];
		}
	}
	else if ([elementName isEqualToString:@"tileoffset"])
	{
		KTTilemapTileset* tileset = [_tilemap.tilesets lastObject];
		CGPoint offset;
		offset.x = [[attributes objectForKey:@"x"] intValue];
		offset.y = [[attributes objectForKey:@"y"] intValue];
		tileset.drawOffset = offset;
	}
	else if ([elementName isEqualToString:@"image"])
	{
		KTTilemapTileset* tileset = [_tilemap.tilesets lastObject];
		NSString* source = [attributes objectForKey:@"source"];
		tileset.imageFile = [source lastPathComponent];
	}
	else if ([elementName isEqualToString:@"tile"])
	{
		KTTilemapTileset* tileset = [_tilemap.tilesets lastObject];
		NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:3];
		_parsingTileGid = tileset.firstGid + [[attributes objectForKey:@"id"] intValue];
		if (_tilemap.tileProperties == nil)
		{
			_tilemap.tileProperties = [NSMutableDictionary dictionaryWithCapacity:1];
		}
		[_tilemap.tileProperties setObject:dict forKey:[NSNumber numberWithInt:_parsingTileGid]];
		_parsingElement = KTTilemapParsingElementTile;
	}
	else if ([elementName isEqualToString:@"layer"])
	{
		KTTilemapLayer* layer = [[KTTilemapLayer alloc] init];
		layer.tilemap = _tilemap;
		layer.isObjectLayer = NO;
		layer.name = [attributes objectForKey:@"name"];
		layer.visible = ![[attributes objectForKey:@"visible"] isEqualToString:@"0"];
		layer.opacity = 255;
		if ([attributes objectForKey:@"opacity"])
			layer.opacity = (int)(255.0f * ([[attributes objectForKey:@"opacity"] floatValue] + 0.5f));
		CGSize layerSize;
		layerSize.width = [[attributes objectForKey:@"width"] intValue];
		layerSize.height = [[attributes objectForKey:@"height"] intValue];
		layer.size = layerSize;
		layer.tilesCount = layerSize.width * layerSize.height;
		[_tilemap.layers addObject:layer];
		
		_parsingElement = KTTilemapParsingElementLayer;
	}
	else if ([elementName isEqualToString:@"objectgroup"])
	{
		KTTilemapLayer* layer = [[KTTilemapLayer alloc] init];
		layer.tilemap = _tilemap;
		layer.isObjectLayer = YES;
		layer.name = [attributes objectForKey:@"name"];
		[_tilemap.layers addObject:layer];
		
		_parsingElement = KTTilemapParsingElementObjectGroup;
	}
	else if ([elementName isEqualToString:@"object"])
	{
		KTTilemapObject* object = [[KTTilemapObject alloc] init];
		object.name = [attributes objectForKey:@"name"];
		object.type = [attributes objectForKey:@"type"];
		object.gid = [[attributes objectForKey:@"gid"] intValue];
		
		CGSize size;
		size.width = [[attributes objectForKey:@"width"] intValue];
		size.height = [[attributes objectForKey:@"height"] intValue];
		object.size = size;
		
		CGPoint position;
		position.x = [[attributes objectForKey:@"x"] intValue];
		position.y = [[attributes objectForKey:@"y"] intValue];
		// Correct y position. (Tiled uses Flipped, cocos2d uses Standard)
		position.y = (_tilemap.mapSize.height * _tilemap.gridSize.height) - position.y - size.height;
		object.position = position;
		
		// Add the object to the object Layer
		KTTilemapLayer* layer = [self lastObjectLayer];
		if (layer.objects == nil)
		{
			layer.objects = [NSMutableArray arrayWithCapacity:1];
		}
		[layer.objects addObject:object];
		
		_parsingElement = KTTilemapParsingElementObject;
	}
	else if ([elementName isEqualToString:@"data"])
	{
		NSString* encoding = [attributes objectForKey:@"encoding"];
		NSString* compression = [attributes objectForKey:@"compression"];
		NSAssert1([compression isEqualToString:@"gzip"] || [compression isEqualToString:@"zlib"],
				  @"TMX: unsupported compression method: %@", compression);
		
		if ([encoding isEqualToString:@"base64"])
		{
			_loadingData = YES;
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
		
		NSAssert(_dataFormat != KTTilemapDataFormatNone, @"TMX file must be Base64 encoded and gzip/zlib compressed. Change the file format in Tiled Preferences." );
	}
	else if ([elementName isEqualToString:@"polygon"])
	{
		KTTilemapLayer* layer = [self lastObjectLayer];
		KTTilemapObject* object = [layer.objects lastObject];
		object.points = [attributes objectForKey:@"points"];
		object.polyType = KTTilemapObjectPolyTypePolygon;
	}
	else if ([elementName isEqualToString:@"polyline"])
	{
		KTTilemapLayer* layer = [self lastObjectLayer];
		KTTilemapObject* object = [layer.objects lastObject];
		object.points = [attributes objectForKey:@"points"];
		object.polyType = KTTilemapObjectPolyTypePolyline;
	}
	else if ([elementName isEqualToString:@"property"])
	{
		if (_parsingElement == KTTilemapParsingElementNone)
		{
			NSLog(@"TMX Parser: parsing element is unsupported. Cannot add property named '%@' with value '%@'",
				  [attributes objectForKey:@"name"], [attributes objectForKey:@"value"] );
		}
		else if (_parsingElement == KTTilemapParsingElementMap)
		{
			if (_tilemap.properties == nil)
			{
				_tilemap.properties = [NSMutableDictionary dictionaryWithCapacity:1];
			}
			id value = [self valueFromString:[attributes objectForKey:@"value"]];
			[_tilemap.properties setObject:value forKey:[attributes objectForKey:@"name"]];
		}
		else if (_parsingElement == KTTilemapParsingElementLayer)
		{
			KTTilemapLayer* layer = [_tilemap.layers lastObject];
			if (layer.properties == nil)
			{
				layer.properties = [NSMutableDictionary dictionaryWithCapacity:1];
			}
			id value = [self valueFromString:[attributes objectForKey:@"value"]];
			[layer.properties setObject:value forKey:[attributes objectForKey:@"name"]];
		}
		else if (_parsingElement == KTTilemapParsingElementObjectGroup)
		{
			KTTilemapLayer* layer = [self lastObjectLayer];
			if (layer.properties == nil)
			{
				layer.properties = [NSMutableDictionary dictionaryWithCapacity:1];
			}
			id value = [self valueFromString:[attributes objectForKey:@"value"]];
			[layer.properties setObject:value forKey:[attributes objectForKey:@"name"]];
		}
		else if (_parsingElement == KTTilemapParsingElementObject)
		{
			KTTilemapLayer* layer = [self lastObjectLayer];
			KTTilemapObject* object = [layer.objects lastObject];
			if (object.properties == nil)
			{
				object.properties = [NSMutableDictionary dictionaryWithCapacity:1];
			}
			id value = [self valueFromString:[attributes objectForKey:@"value"]];
			[object.properties setObject:value forKey:[attributes objectForKey:@"name"]];
		}
		else if (_parsingElement == KTTilemapParsingElementTile)
		{
			if (_tilemap.tileProperties == nil)
			{
				_tilemap.tileProperties = [NSMutableDictionary dictionaryWithCapacity:1];
			}
			NSMutableDictionary* dict = [_tilemap.tileProperties objectForKey:[NSNumber numberWithInt:_parsingTileGid]];
			NSAssert1(dict, @"tile properties dictionary is nil, for tile with identifier: %i", _parsingTileGid);
			id value = [self valueFromString:[attributes objectForKey:@"value"]];
			[dict setObject:value forKey:[attributes objectForKey:@"name"]];
		}
	}
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName
  namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qualifiedName
{
	if ([elementName isEqualToString:@"data"] && (_dataFormat & KTTilemapDataFormatBase64))
	{
		KTTilemapLayer* layer = [_tilemap.layers lastObject];
		
		unsigned char* buffer;
		int bufferSize = base64Decode((unsigned char*)[_dataString UTF8String], (unsigned int)_dataString.length, &buffer);
		if (buffer == NULL)
		{
			[NSException raise:@"TMX decode error" format:@"TMX decoding data of layer (%@) failed", layer];
		}
		
		if (_dataFormat & (KTTilemapDataFormatGzip | KTTilemapDataFormatZlib))
		{
			unsigned char* deflated;
			CGSize mapSize = _tilemap.mapSize;
			unsigned int expectedSize = mapSize.width * mapSize.height * sizeof(uint32_t);
			unsigned int inflatedBufferSize = ccInflateMemoryWithHint(buffer, bufferSize, &deflated, expectedSize);
			NSAssert2(inflatedBufferSize == expectedSize, @"TMX data decode: hint mismatch! (got: %i, expected: %i)", inflatedBufferSize, expectedSize);
			inflatedBufferSize = 0; // XXX: to avoid compiler warnings in release builds
			
			free(buffer);
			
			if (deflated == NULL)
			{
				[NSException raise:@"TMX decode error" format:@"TMX deflating data of layer (%@) failed", layer];
			}
			
			layer.tiles = [[KTTilemapLayerTiles alloc] initWithTiles:(uint32_t*)deflated tilemap:_tilemap];
			free(deflated);
		}
		else
		{
			layer.tiles = [[KTTilemapLayerTiles alloc] initWithTiles:(uint32_t*)buffer tilemap:_tilemap];
			free(buffer);
		}
		
		// find the first non-zero tile
		uint32_t firstTile = 0, count = _tilemap.mapSize.width * _tilemap.mapSize.height * sizeof(uint32_t);
		for (unsigned int i = 0; i < count; i++)
		{
			uint32_t tile = layer.tiles.gid[i] & KTTilemapTileFlipMask;
			if (tile > 0)
			{
				firstTile = tile;
				break;
			}
		}
		
		// find the corresponding tileset for the given gid range
		KTTilemapTileset* usedTileset = nil;
		for (KTTilemapTileset* tileset in _tilemap.tilesets)
		{
			if (tileset.firstGid > firstTile)
			{
				break;
			}
			usedTileset = tileset;
		}
		
		NSAssert1(usedTileset, @"TMX: unable to determine tileset used by layer (%@)", layer);
		layer.tiles.tileset = usedTileset;
		
		[_dataString setString:@""];
		_loadingData = NO;
	}
	else if ([elementName isEqualToString:@"layer"] || [elementName isEqualToString:@"objectgroup"] ||
			 [elementName isEqualToString:@"object"] || [elementName isEqualToString:@"map"])
	{
		_parsingElement = KTTilemapParsingElementNone;
	}
}

-(void) parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
	if (_loadingData)
	{
		[_dataString appendString:string];
	}
}

-(void) parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
	[NSException raise:@"TMX Parse Error!" format:@"TMX Parse Error! File: %@ - Description: %@ - Reason: %@ - Suggestion: %@",
	 _tmxFile, parseError.localizedDescription, parseError.localizedFailureReason, parseError.localizedRecoverySuggestion];
}

-(KTTilemapLayer*) lastObjectLayer
{
	for (KTTilemapLayer* layer in [_tilemap.layers reverseObjectEnumerator])
	{
		if (layer.isObjectLayer)
		{
			return layer;
		}
	}
	return nil;
}

@end
