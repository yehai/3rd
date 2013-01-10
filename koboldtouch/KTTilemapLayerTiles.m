//
//  KTTilemapLayerTiles.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTilemapLayerTiles.h"
#import "KTTilemap.h"

@implementation KTTilemapLayerTiles
-(id) initWithTiles:(uint32_t*)tiles tilemap:(KTTilemap*)tilemap
{
	if ((self = [super init]))
	{
		NSAssert(tiles != NULL, @"tiles is NULL");
		
		// copy tiles to our own buffer
		unsigned int bufferSize = tilemap.mapSize.width * tilemap.mapSize.height * sizeof(uint32_t);
		_gid = malloc(bufferSize);
		memcpy(&_gid[0], &tiles[0], bufferSize);
		
		/* IMPROVEME: get back to this some other time
		 // mem copy row by row to invert coordinates
		 //unsigned int gidY = 0;
		 unsigned int rowSize = tilemap.mapSize.width * sizeof(uint32_t);
		 for (int y = tilemap.mapSize.height - 1; y >= 0; y--)
		 {
		 unsigned int gidIndex = gidY * rowSize;
		 unsigned int tileIndex = y * rowSize;
		 memcpy(&_gid[gidIndex], &tiles[tileIndex], rowSize);
		 gidY++;
		 }
		 */
	}
	return self;
}
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
-(void) dealloc
{
	if (_gid)
	{
		free(_gid);
	}
}
@end
