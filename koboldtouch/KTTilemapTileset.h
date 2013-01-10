//
//  KTTilemapTileset.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import <Foundation/Foundation.h>

typedef enum : uint32_t
{
	KTTilemapTileHorizontalFlip		= 0x80000000,
	KTTilemapTileVerticalFlip		= 0x40000000,
	KTTilemapTileDiagonalFlip		= 0x20000000,
	KTTilemapTileFlippedAll			= (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip | KTTilemapTileDiagonalFlip),
	KTTilemapTileFlipMask			= ~(KTTilemapTileFlippedAll),
} KTTilemapTileFlip;

/** TMX Tileset */
@interface KTTilemapTileset : NSObject <NSCoding>
{
@private
	__weak CCTexture2D* _texture;
	unsigned int _textureRectCount;
	CGRect* _textureRects;
}
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* imageFile;
@property (nonatomic) unsigned int firstGid;
@property (nonatomic) unsigned int lastGid;
@property (nonatomic) unsigned int tilesPerRow;
@property (nonatomic) unsigned int tilesPerColumn;
@property (nonatomic) int spacing;
@property (nonatomic) int margin;
@property (nonatomic) CGPoint drawOffset;
@property (nonatomic) CGSize tileSize;
@property (nonatomic, readonly) CCTexture2D* texture;
-(CGRect) textureRectForGid:(unsigned int)gid;
@end