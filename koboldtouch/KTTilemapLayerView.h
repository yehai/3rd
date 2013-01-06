//
//  KTTilemapLayerView.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "kobold2d.h"

#import "KTTilemap.h"

@interface KTTilemapLayerView : CCNode
{
@protected
@private
	CCSpriteBatchNode* _batchNode;
	CGPoint _rootNodePreviousPosition;
	CGSize _visibleTilesOnScreen;
	
	__weak KTTilemapLayer* _tileLayer;
}

-(id) initWithTileLayer:(KTTilemapLayer*)tileLayer;

@end
