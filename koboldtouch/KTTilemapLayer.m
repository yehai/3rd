//
//  KTTilemapLayer.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTilemapLayer.h"
#import "KTTilemap.h"

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
-(unsigned int) tileAt:(CGPoint)tilePos
{
	unsigned int index = tilePos.x + tilePos.y * _size.width;
	if (index >= _tilesCount)
	{
		return 0;	// all illegal indices simply return 0 (the "empty" tile)
	}
	return (_tiles.gid[index] & KTTilemapTileFlipMask);
}
-(unsigned int) tileWithFlagsAt:(CGPoint)tilePos
{
	unsigned int index = tilePos.x + tilePos.y * _size.width;
	if (index >= _tilesCount)
	{
		return 0;	// all illegal indices simply return 0 (the "empty" tile)
	}
	return _tiles.gid[index];
}
@end
