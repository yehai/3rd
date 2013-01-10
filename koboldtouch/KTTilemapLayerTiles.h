//
//  KTTilemapLayerTiles.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import <Foundation/Foundation.h>

@class KTTilemap;
@class KTTilemapTileset;

/** TMX Layer Tiles */
@interface KTTilemapLayerTiles : NSObject <NSCoding>
@property (nonatomic, weak) KTTilemapTileset* tileset;
@property (nonatomic) uint32_t* gid;
-(id) initWithTiles:(uint32_t*)tiles tilemap:(KTTilemap*)tilemap;
@end
