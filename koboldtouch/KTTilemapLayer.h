//
//  KTTilemapLayer.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import <Foundation/Foundation.h>

@class KTTilemap;
@class KTTilemapLayerTiles;

/** TMX Tile Layer */
@interface KTTilemapLayer : NSObject <NSCoding>
@property (nonatomic, copy) NSString* name;
@property (nonatomic) NSMutableArray* objects;
@property (nonatomic) NSMutableDictionary* properties;
@property (nonatomic, weak) KTTilemap* tilemap;
@property (nonatomic) KTTilemapLayerTiles* tiles;
@property (nonatomic) CGSize size;
@property (nonatomic) unsigned int tilesCount;
@property (nonatomic) int opacity;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL isObjectLayer;
// x/y defaults to 0/0 - none of these values can be changed in Tiled, thus they don't appear here
-(unsigned int) tileAt:(CGPoint)tilePos;
-(unsigned int) tileWithFlagsAt:(CGPoint)tilePos;
@end
