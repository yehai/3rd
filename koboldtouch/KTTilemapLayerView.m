//
//  KTTilemapLayerView.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapLayerView.h"
#import "KTTilemap.h"
#import "KTTilemapLayer.h"

@implementation KTTilemapLayerView

-(id) initWithTilemapLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		_tileLayer = tileLayer;
		_endlessScrolling = tileLayer.endlessScrolling;
		
		// create initial tiles to fill screen
		CGSize winSize = [CCDirector sharedDirector].winSize;
		CGSize gridSize = _tileLayer.tilemap.gridSize;
		CGSize mapSize = _tileLayer.tilemap.mapSize;
		
		_visibleTilesOnScreen = CGSizeMake(winSize.width / gridSize.width + 1, winSize.height / gridSize.height + 1);
		_viewBoundary = CGSizeMake(-(mapSize.width * gridSize.width - (_visibleTilesOnScreen.width - 1) * gridSize.width),
								   -(mapSize.height * gridSize.height - (_visibleTilesOnScreen.height - 1) * gridSize.height));
	}
	return self;
}

-(void) setPosition:(CGPoint)position
{
	// cap to nearest integer value to fix flickering lines
	position = ccpAdd(position, CGPointMake(0.5f, 0.5f));
	position.x = (long)position.x;
	position.y = (long)position.y;
	
	CGPoint windowCenter = ccpAdd([CCDirector sharedDirector].windowCenter, CGPointMake(0.5f, 0.5f));
	windowCenter.x = (long)windowCenter.x;
	windowCenter.y = (long)windowCenter.y;
	
	// convert to view coordinates
	position = ccpMult(ccpSub(position, windowCenter), -1.0f);
	
	if (_endlessScrolling)
	{
		/*
		// wrap around at 2x layer boundary (one additional layer to the right and top)
		// FIXME: if you scroll or reposition by more than 2x mapSize position will be wrong!
		CGSize mapSize = _tileLayer.tilemap.mapSize;
		CGSize maxSize = CGSizeMake(mapSize.width * 2.0f, mapSize.height * 2.0f);
		position.x = (position.x < 0.0f) ? position.x + maxSize.width : position.x;
		position.y = (position.y < 0.0f) ? position.y + maxSize.height : position.y;
		position.x = (position.x >= maxSize.width) ? position.x - maxSize.width : position.x;
		position.y = (position.y >= maxSize.height) ? position.y - maxSize.height : position.y;
		*/
	}
	else
	{
		// cap to layer boundary
		position.x = fminf(position.x, 0.0f);
		position.y = fminf(position.y, 0.0f);
		position.x = fmaxf(position.x, _viewBoundary.width);
		position.y = fmaxf(position.y, _viewBoundary.height);
	}
	
	[super setPosition:position];
}

@end
