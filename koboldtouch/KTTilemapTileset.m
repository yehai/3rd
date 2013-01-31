//
//  KTTilemapTileset.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTilemapTileset.h"
#import "KTTilemap.h"
#import "KTTilemapProperties.h"
#import "KTTilemapTileProperties.h"

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
	return [NSString stringWithFormat:@"%@ (name: '%@', image: '%@', firstGid: %i, spacing: %i, margin: %i, tileSize: %.0f,%.0f, num properties: %u)",
			[super description], _name, _imageFile, _firstGid, _spacing, _margin, _tileSize.width, _tileSize.height, (unsigned int)_properties.count];
}

-(void) dealloc
{
	if (_textureRects)
	{
		free(_textureRects);
	}
}

static NSArray* kPVRImageFileExtensions = nil;

-(CCTexture2D*) texture
{
	if (_texture == nil)
	{
		if (kPVRImageFileExtensions == nil)
		{
			kPVRImageFileExtensions = [NSArray arrayWithObjects:@"pvr.ccz", @"pvr.gz", @"pvr", nil];
		}
		
		// try loading .pvr.ccz / .pvr / .pvr.gz first and default to imageFile if not found
		NSFileManager* fileManager = [NSFileManager defaultManager];
		CCFileUtils* fileUtils = [CCFileUtils sharedFileUtils];
		//NSLog(@"KTTilemapTileset now attempts to load tileset textures with pvr.ccz, pvr.gz and pvr extensions. This may cause cocos2d to spit out 'warning: file not found' messages. Ignore them!");
		
		for (NSString* fileExtension in kPVRImageFileExtensions)
		{
			NSString* pvrImageFile = [NSString stringWithFormat:@"%@.%@", [_imageFile stringByDeletingPathExtension], fileExtension];
			pvrImageFile = [fileUtils fullPathFromRelativePath:pvrImageFile];
			if ([fileManager fileExistsAtPath:pvrImageFile])
			{
				_texture = [[CCTextureCache sharedTextureCache] addImage:pvrImageFile];
				break;
			}
		}
		
		// no pvr version of tileset found, load the default tileset image
		if (_texture == nil)
		{
			_texture = [[CCTextureCache sharedTextureCache] addImage:[fileUtils fullPathFromRelativePath:_imageFile]];
		}
		
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
	
	_textureRectCount = (_lastGid + 1) - _firstGid;
	unsigned int bufferSize = _textureRectCount * sizeof(CGRect);
	_textureRects = malloc(bufferSize);
	NSAssert1(_textureRects, @"tileset _textureRects is nil, failed to allocate %u bytes", bufferSize);
	
	// now create the rects and store them in buffer
	unsigned int index = 0;
	gid_t gid = _firstGid;
	while (gid <= _lastGid)
	{
		_textureRects[index++] = [self rectForGid:gid++];
	}
	NSAssert2(_textureRectCount == index, @"created %u rects but expected to create %u rects", index, _textureRectCount);
}

-(CGRect) rectForGid:(gid_t)gid
{
	CGRect rect;
	rect.size = _tileSize;
	gid = gid - _firstGid;
	rect.origin.x = (gid % _tilesPerRow) * (_tileSize.width + _spacing) + _margin;
	rect.origin.y = (gid / _tilesPerRow) * (_tileSize.height + _spacing) + _margin;
	return rect;
}

-(CGRect) textureRectForGid:(gid_t)gid
{
	gid_t tilesetGid = (gid & KTTilemapTileFlipMask);
	if (gid == 0 || tilesetGid < _firstGid || tilesetGid > _lastGid)
	{
		return CGRectZero;
	}
	
	tilesetGid -= _firstGid;
	NSAssert2(tilesetGid < _textureRectCount, @"can't get texture rect for gid %u (index out of bounds) from tileset: %@", tilesetGid, self);
	NSAssert(_textureRects, @"can't get texture rect, _textureRects is nil");
	return _textureRects[tilesetGid];
}

-(KTTilemapProperties*) properties
{
	if (_properties == nil)
	{
		_properties = [[KTTilemapProperties alloc] init];
	}
	return _properties;
}

-(KTTilemapTileProperties*) tileProperties
{
	if (_tileProperties == nil)
	{
		_tileProperties = [[KTTilemapTileProperties alloc] init];
	}
	return _tileProperties;
}

@end
