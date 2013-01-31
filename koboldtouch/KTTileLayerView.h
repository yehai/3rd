//
//  KTTilemapLayerView.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "kobold2d.h"
#import "KTTilemapLayerView.h"

@class KTTilemapLayer;

/** The view of a tile layer. Derives from CCNode. Contains a CCSpriteBatchNode for the sprites visible on screen.
 Updates the sprites based on its position and draws only the sprites that are visible on the screen. Ensures that
 it does not show anything beyond the tile layer.
 
 Note: will need to be refactored to support isometric & hex views.
 */
@interface KTTileLayerView : KTTilemapLayerView
{
@protected
@private
	NSMutableDictionary* _batchNodes;
	NSMutableArray* _visibleTiles;
	CGPoint _previousPosition;
}

@property (nonatomic) GLubyte opacity;

/** Creates a KTTileLayerView with a KTTilemapLayer. */
-(id) initWithTileLayer:(KTTilemapLayer*)tileLayer;

@end
