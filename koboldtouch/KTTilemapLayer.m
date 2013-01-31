//
//  KTTilemapLayer.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTilemapLayer.h"
#import "KTTilemap.h"
#import "KTTilemapTileset.h"
#import "KTTilemapLayerTiles.h"
#import "KTTilemapProperties.h"

@implementation KTTilemapLayer

-(id) initWithCoder:(NSCoder*)aDecoder
{
	if ((self = [super init]))
	{
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder*)aCoder
{
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ (name: '%@', size: %.0f,%.0f, opacity: %i, visible: %i, isObjectLayer: %i, objects: %u, tiles: %@, properties: %u)",
			[super description], _name, _size.width, _size.height, _opacity, _visible, _isObjectLayer, (unsigned int)_objects.count, _tiles, (unsigned int)_properties.count];
}

-(gid_t) tileGidAt:(CGPoint)tilePos
{
	unsigned int index = tilePos.x + tilePos.y * _size.width;
	if (index >= _tileCount)
	{
		return 0;	// all illegal indices simply return 0 (the "empty" tile)
	}
	return (_tiles.gid[index] & KTTilemapTileFlipMask);
}

-(gid_t) tileGidWithFlagsAt:(CGPoint)tilePos
{
	unsigned int index = tilePos.x + tilePos.y * _size.width;
	if (index >= _tileCount)
	{
		return 0;	// all illegal indices simply return 0 (the "empty" tile)
	}
	return _tiles.gid[index];
}

@dynamic isTileLayer;
-(BOOL) isTileLayer
{
	return !_isObjectLayer;
}
-(void) setIsTileLayer:(BOOL)isTileLayer
{
	_isObjectLayer = !isTileLayer;
}

-(KTTilemapProperties*) properties
{
	if (_properties == nil)
	{
		_properties = [[KTTilemapProperties alloc] init];
	}
	return _properties;
}

-(KTTilemapLayerTiles*) tiles
{
	if (_tiles == nil && _isObjectLayer == NO)
	{
		_tiles = [[KTTilemapLayerTiles alloc] init];
	}
	return _tiles;
}

#pragma mark Objects

-(void) addObject:(KTTilemapObject*)object
{
	if (_isObjectLayer)
	{
		if (_objects == nil)
		{
			_objects = [NSMutableArray arrayWithCapacity:20];
		}
		
		[_objects addObject:object];
	}
}

-(void) removeObject:(KTTilemapObject*)object
{
	if (_isObjectLayer)
	{
		[_objects removeObject:object];
	}
}

-(KTTilemapObject*) objectAtIndex:(NSUInteger)index
{
	if (_isObjectLayer && index < _objects.count)
	{
		return [_objects objectAtIndex:index];
	}
	
	return nil;
}

-(KTTilemapObject*) objectByName:(NSString*)name
{
	for (KTTilemapObject* object in _objects)
	{
		if ([object.name isEqualToString:name])
		{
			return object;
		}
	}
	return nil;
}

@end
