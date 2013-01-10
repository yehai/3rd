//
//  KTTilemapTileset.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTilemapTileset.h"
#import "KTTilemap.h"

@implementation KTTilemapTileset
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
	return [NSString stringWithFormat:@"%@ (name: '%@', image: '%@', firstGid: %i, spacing: %i, margin: %i, tileSize: %.0f,%.0f)",
			[super description], _name, _imageFile, _firstGid, _spacing, _margin, _tileSize.width, _tileSize.height];
}
-(void) dealloc
{
	if (_textureRects)
	{
		free(_textureRects);
	}
}
-(CCTexture2D*) texture
{
	if (_texture == nil)
	{
		_texture = [[CCTextureCache sharedTextureCache] addImage:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:_imageFile]];
		NSAssert(_texture, @"could not find (or otherwise load) image file: '%@'", _imageFile);
		[self setupTextureRects];
	}
	return _texture;
}
-(void) setupTextureRects
{
	// first figure out how many rects to allocate
	CGSize imageSize = _texture.contentSize;
	_tilesPerRow = (imageSize.width - _margin * 2 + _spacing) / (_tileSize.width + _spacing);
	_tilesPerColumn = (imageSize.height - _margin * 2 + _spacing) / (_tileSize.height + _spacing);
	_lastGid = _firstGid + (_tilesPerRow * _tilesPerColumn) - 1;
	LOG_EXPR(_lastGid);
	
	_textureRectCount = (_lastGid + 1) - _firstGid;
	unsigned int bufferSize = _textureRectCount * sizeof(CGRect);
	_textureRects = malloc(bufferSize);
	NSAssert1(_textureRects, @"tileset _textureRects is nil, failed to allocate %u bytes", bufferSize);
	
	// now create the rects and store them in buffer
	unsigned int index = 0;
	unsigned int gid = _firstGid;
	while (gid <= _lastGid)
	{
		_textureRects[index++] = [self rectForGid:gid++];
	}
	NSAssert2(_textureRectCount == index, @"created %u rects but expected to create %u rects", index, _textureRectCount);
}
-(CGRect) rectForGid:(unsigned int)gid
{
	CGRect rect;
	rect.size = _tileSize;
	gid = gid - _firstGid;
	rect.origin.x = (gid % _tilesPerRow) * (_tileSize.width + _spacing) + _margin;
	rect.origin.y = (gid / _tilesPerRow) * (_tileSize.height + _spacing) + _margin;
	return rect;
}
-(CGRect) textureRectForGid:(unsigned int)gid
{
	if (gid == 0)
	{
		return CGRectZero;
	}
	
	unsigned int localGid = (gid & KTTilemapTileFlipMask);
	if (localGid < _firstGid || localGid > _lastGid)
	{
		//NSLog(@"WARNING: gid %u is not from this tileset: %@ - only one tileset per layer is supported.", localGid, self);
		return CGRectZero;
	}
	
	localGid -= _firstGid;
	NSAssert2(localGid < _textureRectCount, @"can't get texture rect for gid %u (index out of bounds) from tileset: %@", localGid, self);
	NSAssert(_textureRects, @"can't get texture rect, _textureRects is nil");
	return _textureRects[localGid];
}
@end
