//
//  KTTilemapLayerView.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CCNode.h"

@class KTTilemapLayer;

/** Base view class for tilemap tile layer views. Prevents movement past map border. Ensures
 position is cast to nearest integer (part of the "black line" artifacts fix). 
 
 Caution: will need to be refactored to support isometric & hex views.
 */
@interface KTTilemapLayerView : CCNode
{
@protected
	CGSize _visibleTilesOnScreen;
	CGSize _viewBoundary;
	__weak KTTilemapLayer* _tileLayer;
	BOOL _endlessScrolling;
@private
}

/** Creates a KTTilemapLayerView with a KTTilemapLayer. */
-(id) initWithTilemapLayer:(KTTilemapLayer*)tileLayer;

@end
