//
//  KTTilemapLayerViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class KTTilemapLayer;
@class KTTileLayerModel;
@class KTTileLayerView;
@class KTTilemapModel;
@class CCSpriteBatchNode;

/** View controller for a TMX Tile Layer. It's view is a KTTileLayerView and the model is a KTTileLayerModel. */
@interface KTTileLayerViewController : KTViewController
{
@protected
@private
}

/** Returns the tilemap tile layer. */
@property (nonatomic, readonly) KTTilemapLayer* tileLayer;

/** Initializes a KTTileLayerViewController with a KTTilemapModel and a KTTilemapLayer. The latter must be a tile layer. */
-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel tileLayer:(KTTilemapLayer*)tileLayer;

@end
