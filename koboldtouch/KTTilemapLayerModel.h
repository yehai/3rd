//
//  KTTilemapLayerModel.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTEntityModel.h"

@class KTTilemapLayer;

/** Model class for KTTileLayerViewController and KTObjectLayerViewController. Handles capping position to map boundary. */
@interface KTTilemapLayerModel : KTEntityModel
{
@protected
	CGSize _cameraMinBoundary;
	CGSize _cameraMaxBoundary;
@private
}

/** Reference to the KTTilemapLayer object. */
@property (nonatomic, weak) KTTilemapLayer* tileLayer;

/** Allows the layer to scroll endlessly, wrapping around at tilemap borders. */
@property (nonatomic) BOOL endlessScrolling;

/** Create model with KTTilemapLayer. */
-(id) initWithTilemapLayer:(KTTilemapLayer*)tileLayer;

/** Returns a position capped to a valid view position for the layer. This valid position lies half a screen width & height
 inward of the tile layer for layers that do not scroll endlessly. */
-(CGPoint) capPositionToScrollBoundary:(CGPoint)position;

@end
