//
//  KTTilemapLayerView.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapLayerView.h"
#import "CCDirectorExtensions.h"

@interface KTTilemapLayerView (PrivateMethods)
// declare private methods here
@end

@implementation KTTilemapLayerView

-(id) initWithTileLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		// FIXME: improve by rendering quads directly
		// for the time being rendering is simply sprite batched sprites

		_previousPosition = CGPointMake(INT_MAX, INT_MAX);
		
		CCTexture2D* tilesetTexture = tileLayer.tiles.tileset.texture;
		[tilesetTexture setAliasTexParameters];
		
		_batchNode = [CCSpriteBatchNode batchNodeWithTexture:tilesetTexture];
		[self addChild:_batchNode];
		
		// create initial tiles to fill screen
		CGSize winSize = [CCDirector sharedDirector].winSize;
		CGSize gridSize = tileLayer.tilemap.gridSize;
		
		_visibleTilesOnScreen = CGSizeMake(winSize.width / gridSize.width + 1, winSize.height / gridSize.height + 1);
		
		CCSprite* tile = nil;
		for (int tilePosY = 0; tilePosY < _visibleTilesOnScreen.height; tilePosY++)
		{
			for (int tilePosX = 0; tilePosX < _visibleTilesOnScreen.width; tilePosX++)
			{
				tile = [CCSprite spriteWithTexture:tilesetTexture];
				tile.visible = NO;
				[_batchNode addChild:tile];
			}
		}
	}
	return self;
}

-(void) setScrollCenter:(CGPoint)scrollCenter
{
	CGPoint windowCenter = [CCDirector sharedDirector].windowCenter;
	CGPoint pos = ccpMult(ccpSub(scrollCenter, windowCenter), -1.0f);
	pos.x = fminf(pos.x, 0.0f);
	pos.y = fminf(pos.y, 0.0f);
	self.position = pos;
}

-(void) drawTileLayer:(KTTilemapLayer*)tileLayer
{
	if (CGPointEqualToPoint(position_, _previousPosition) == NO)
	{
		// create initial tiles to fill screen
		KTTilemapLayerTiles* tiles = tileLayer.tiles;
		KTTilemapTileset* tileset = tiles.tileset;
		CGSize gridSize = tileLayer.tilemap.gridSize;
		CGSize mapSize = tileLayer.tilemap.mapSize;
		CGSize halfTileSize = CGSizeMake(tileset.tileSize.width * 0.5f, tileset.tileSize.height * 0.5f);
		
		CGPoint absoluteScrollPosition = CGPointMake(fabsf(position_.x), fabsf(position_.y));
		CGPoint tileOffset = CGPointMake((int)(absoluteScrollPosition.x / gridSize.width), (int)(absoluteScrollPosition.y / gridSize.height));
		CGPoint pointOffset = CGPointMake((int)(tileOffset.x * gridSize.width) + 0.5f, (int)(tileOffset.y * gridSize.height) + 0.5f);
		
		// focus pos is world position in tilemap
		// start tile coord is half screen size minus focus
		// end tile coord is half screen size plus focus
		// view center: start coord is: focus pos minus view center
		// view center: end coord is: focus pos plus (screen size minus view center)
		
		unsigned int i = 0;
		CCSprite* tile = nil;
		for (unsigned int tilePosY = 0; tilePosY < _visibleTilesOnScreen.height; tilePosY++)
		{
			for (unsigned int tilePosX = 0; tilePosX < _visibleTilesOnScreen.width; tilePosX++)
			{
				NSAssert(_batchNode.children.count > i, @"Tile layer index (%u) out of bounds (%u)! Perhaps due to window resize?", i, (unsigned int)_batchNode.children.count);
				tile = [_batchNode.children objectAtIndex:i++];
				tile.visible = NO;
				
				// no tile?
				unsigned int gid = [tileLayer tileWithFlagsAt:CGPointMake(tilePosX + tileOffset.x, (mapSize.height - 1 - tilePosY) - tileOffset.y)];
				if (gid == 0)
					continue;
				
				// rect will be empty if tile is from a different tileset
				CGRect textureRect = [tileset textureRectForGid:gid];
				if (CGRectIsEmpty(textureRect))
					continue;
				
				tile.textureRect = textureRect;
				tile.position = CGPointMake(tilePosX * gridSize.width + halfTileSize.width + pointOffset.x,
											tilePosY * gridSize.height + halfTileSize.height + pointOffset.y);
				
				// TRYFIX: black/weird lines (texel stretch: bad fix, flicker, subpixel off: bad fix, no alias texparams: bad fix, filter artifacts)
				tile.position = CGPointMake((int)(tile.position.x) + (0.5f / CC_CONTENT_SCALE_FACTOR()),
											(int)(tile.position.y) + (0.5f / CC_CONTENT_SCALE_FACTOR()));
				
				// TEMPORARY SOLUTION: squeeze tiles closer together
				//tile.position = CGPointMake(tile.position.x - i * 0.06f, tile.position.y - i * 0.02f);x
				
				// reset defaults
				tile.visible = YES;
				tile.rotation = 0.0f;
				tile.flipX = NO;
				tile.flipY = NO;
				
				if (gid & KTTilemapTileDiagonalFlip)
				{
					// handle the 4 diagonally flipped states.
					uint32_t flag = gid & (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip);
					if (flag == KTTilemapTileHorizontalFlip)
					{
						tile.rotation = 90;
					}
					else if (flag == KTTilemapTileVerticalFlip)
					{
						tile.rotation = 270;
					}
					else if (flag == (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip))
					{
						tile.rotation = 90;
						tile.flipX = YES;
					}
					else
					{
						tile.rotation = 270;
						tile.flipX = YES;
					}
				}
				else
				{
					tile.flipX = (gid & KTTilemapTileHorizontalFlip) == KTTilemapTileHorizontalFlip;
					tile.flipY = (gid & KTTilemapTileVerticalFlip) == KTTilemapTileVerticalFlip;
				}
			}
		}
		
	}
	
	_previousPosition = position_;
}

@end
