//
//  KTTilemap.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//
//

// TMX Parser Code adapted from CCTMXXMLParser and related CCTMX* classes. Therefore this notice was included:

/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2009-2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "KTTilemap.h"
#import "KTTilemapTileset.h"
#import "KTTilemapProperties.h"
#import "KTTMXParser.h"
#import "KTMacros.h"

#import "CCFileUtils.h"
#import "CCTexture2D.h"
#import "CCTextureCache.h"

#pragma mark KTTilemap

@implementation KTTilemap

#pragma mark Init

-(id) init
{
	self = [super init];
	if (self)
	{
		_tilesets = [NSMutableArray array];
		_layers = [NSMutableArray array];
	}
	return self;
}

+(id) tilemapWithTMXFile:(NSString *)tmxFile
{
	return [[self alloc] initWithTMXFile:tmxFile];
}

-(id) initWithTMXFile:(NSString*)tmxFile
{
	self = [self init];
	if (self)
	{
		[self parseTMXFile:tmxFile];
	}
	return self;
}

+(id) tilemapWithOrientation:(KTTilemapOrientation)orientation mapSize:(CGSize)mapSize gridSize:(CGSize)gridSize
{
	return [[self alloc] initWithOrientation:orientation mapSize:mapSize gridSize:gridSize];
}

-(id) initWithOrientation:(KTTilemapOrientation)orientation mapSize:(CGSize)mapSize gridSize:(CGSize)gridSize
{
	self = [self init];
	if (self)
	{
		_orientation = orientation;
		_mapSize = mapSize;
		_gridSize = gridSize;
	}
	return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
	self = [self init];
	if (self)
	{
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ (orientation: %i, mapSize: %.0f,%.0f, gridSize: %.0f,%.0f, properties: %u, tileSets: %u, layers: %u)",
			[super description], _orientation, _mapSize.width, _mapSize.height, _gridSize.width, _gridSize.height,
			(unsigned int)_properties.count, (unsigned int)_tilesets.count,	(unsigned int)_layers.count];
}

-(NSString*) debugDescription
{
	NSMutableString* str = [NSMutableString stringWithCapacity:4096];
	[str appendFormat:@"\n%@\nmap properties: %@", [self description], _properties];
	
	for (KTTilemapTileset* tileset in _tilesets)
	{
		[str appendFormat:@"\n%@", [tileset description]];
	}
	
	for (KTTilemapLayer* layer in _layers)
	{
		[str appendFormat:@"\n%@", [layer description]];
		if (layer.properties)
		{
			[str appendFormat:@"\nlayer properties: %@", layer.properties];
		}
		
		for (KTTilemapObject* object in layer.objects)
		{
			[str appendFormat:@"\n\t%@", [object description]];
			if (object.properties)
			{
				[str appendFormat:@"\n\tobject properties: %@", object.properties];
			}
		}
	}
	
	return str;
}

-(void) parseTMXFile:(NSString*)tmxFile
{
	KTASSERT_FILEEXISTS(tmxFile);

	@autoreleasepool
	{
		KTTMXParser* parser = [[KTTMXParser alloc] init];
		[parser parseTMXFile:tmxFile tilemap:self];
		parser = nil;
	}
}

-(KTTilemapTileset*) tilesetForGid:(gid_t)gid
{
	KTTilemapTileset* foundTileset = nil;

	gid = (gid & KTTilemapTileFlipMask);
	if (gid > 0)
	{
		for (KTTilemapTileset* tileset in _tilesets)
		{
			if (tileset.firstGid > gid)
			{
				break;
			}
			foundTileset = tileset;
		}
	}
	
	return foundTileset;
}

-(void) addTileset:(KTTilemapTileset*)tileset
{
	[_tilesets addObject:tileset];
}

-(void) addLayer:(KTTilemapLayer*)layer
{
	[_layers addObject:layer];
}

-(KTTilemapLayer*) layerByName:(NSString*)name
{
	for (KTTilemapLayer* layer in _layers)
	{
		if ([layer.name isEqualToString:name])
		{
			return layer;
		}
	}
	return nil;
}

-(KTTilemapProperties*) properties
{
	if (_properties == nil)
	{
		_properties = [[KTTilemapProperties alloc] init];
	}
	return _properties;
}

@end
