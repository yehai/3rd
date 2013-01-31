//
//  KTTilemapLayerModel.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapLayerModel.h"
#import "KTTilemapLayer.h"
#import "KTTilemap.h"

@implementation KTTilemapLayerModel

-(id) initWithTilemapLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		_tileLayer = tileLayer;
		[self setModelPositionBoundary];
		
		// TEST
		//self.endlessScrolling = YES;
		//tileLayer.endlessScrolling = YES;
	}
	return self;
}

-(void) setEndlessScrolling:(BOOL)endlessScrolling
{
	if (_endlessScrolling != endlessScrolling)
	{
		_endlessScrolling = endlessScrolling;
		[self setModelPositionBoundary];
	}
}

-(void) setModelPositionBoundary
{
	CGSize winSize = [CCDirector sharedDirector].winSize;
	CGSize mapSize = _tileLayer.tilemap.mapSize;
	CGSize gridSize = _tileLayer.tilemap.gridSize;

	if (_endlessScrolling)
	{
		_cameraMinBoundary = CGSizeZero;
		_cameraMaxBoundary = CGSizeMake(mapSize.width * gridSize.width * 2.0f,
										mapSize.height * gridSize.height * 2.0f);
	}
	else
	{
		_cameraMinBoundary = CGSizeMake(winSize.width * 0.5f, winSize.height * 0.5f);
		_cameraMaxBoundary = CGSizeMake(mapSize.width * gridSize.width - _cameraMinBoundary.width,
										mapSize.height * gridSize.height - _cameraMinBoundary.height);
	}

	// updates position with new boundary
	self.position = self.position;
}

-(void) setPosition:(CGPoint)position
{
	[super setPosition:[self capPositionToScrollBoundary:position]];
}

-(CGPoint) capPositionToScrollBoundary:(CGPoint)position
{
	if (_endlessScrolling)
	{
		/*
		position.x = (position.x < _cameraMinBoundary.width) ? position.x + _cameraMaxBoundary.width : position.x;
		position.y = (position.y < _cameraMinBoundary.height) ? position.y + _cameraMaxBoundary.height : position.y;
		position.x = (position.x >= _cameraMaxBoundary.width) ? position.x - _cameraMaxBoundary.width : position.x;
		position.y = (position.y >= _cameraMaxBoundary.height) ? position.y - _cameraMaxBoundary.height : position.y;
		 */
	}
	else
	{
		position.x = MAX(position.x, _cameraMinBoundary.width);
		position.y = MAX(position.y, _cameraMinBoundary.height);
		position.x = MIN(position.x, _cameraMaxBoundary.width);
		position.y = MIN(position.y, _cameraMaxBoundary.height);
	}
	return position;
}

@end
