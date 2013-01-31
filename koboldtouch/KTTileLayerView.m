//
//  KTTilemapLayerView.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTileLayerView.h"
#import "KTTilemapLayer.h"
#import "KTTilemap.h"

#import "CCDirectorExtensions.h"
#import "CCNode+Autoscale.h"
#import "CCSprite+ReorderChildDirtyProperty.h"

@implementation KTTileLayerView

-(id) initWithTileLayer:(KTTilemapLayer*)tileLayer
{
	self = [super initWithTilemapLayer:tileLayer];
	if (self)
	{
		_previousPosition = CGPointMake(INT_MAX, INT_MAX);

		[self createTilesetBatchNodes];
	}
	return self;
}

-(void) createTilesetBatchNodes
{
	// assume batch node is not normally at full capacity: allocate 50% of full capacity for reasonably good starting point and memory usage
	NSUInteger batchNodeCapacity = (_visibleTilesOnScreen.width * _visibleTilesOnScreen.height) / 2;
	NSUInteger numTilesets = _tileLayer.tilemap.tilesets.count;
	_batchNodes = [NSMutableDictionary dictionaryWithCapacity:numTilesets];
	
	// get all tileset textures and create batch nodes, but don't add them as child just yet
	for (KTTilemapTileset* tileset in _tileLayer.tilemap.tilesets)
	{
		CCTexture2D* tilesetTexture = tileset.texture;
		[tilesetTexture setAliasTexParameters];
		
		if ([_batchNodes objectForKey:tilesetTexture] == nil)
		{
			CCSpriteBatchNode* batchNode = [CCSpriteBatchNode batchNodeWithTexture:tilesetTexture capacity:batchNodeCapacity];
			[_batchNodes setObject:batchNode forKey:tileset.imageFile];
		}
	}

	// initialize sprites, it doesn't matter with which texture just yet
	_visibleTiles = [NSMutableArray arrayWithCapacity:_visibleTilesOnScreen.width * _visibleTilesOnScreen.height];
	CCSprite* tileSprite = nil;
	for (int tilePosY = 0; tilePosY < _visibleTilesOnScreen.height; tilePosY++)
	{
		for (int tilePosX = 0; tilePosX < _visibleTilesOnScreen.width; tilePosX++)
		{
			tileSprite = [[CCSprite alloc] init];
			tileSprite.visible = NO;
			[_visibleTiles addObject:tileSprite];
		}
	}
}

-(void) cleanup
{
	_batchNodes = nil;
	_visibleTiles = nil;
	[super cleanup];
}

-(void) willRenderFrame
{
	if (CGPointEqualToPoint(position_, _previousPosition) == NO)
	{
		// create initial tiles to fill screen
		KTTilemap* tilemap = _tileLayer.tilemap;
		CGSize mapSize = tilemap.mapSize;
		CGSize gridSize = tilemap.gridSize;
		CGSize halfGridSize = CGSizeMake(gridSize.width * 0.5f, gridSize.height * 0.5f);
		
		/*
		CGPoint absoluteScrollPosition = CGPointMake(fabsf(position_.x), fabsf(position_.y));
		CGPoint tileOffset = CGPointMake((int)(absoluteScrollPosition.x / gridSize.width), (int)(absoluteScrollPosition.y / gridSize.height));
		CGPoint pointOffset = CGPointMake((int)(tileOffset.x * gridSize.width), (int)(tileOffset.y * gridSize.height));
		*/

		CGPoint inversePosition = ccpMult(position_, -1.0f);
		CGPoint tileOffset = CGPointMake((int)(inversePosition.x / gridSize.width), (int)(inversePosition.y / gridSize.height));
		CGPoint pointOffset = CGPointMake((int)(tileOffset.x * gridSize.width), (int)(tileOffset.y * gridSize.height));
		//LOG_EXPR(tileOffset);
		//LOG_EXPR(pointOffset);
		
		// focus pos is world position in tilemap
		// start tile coord is half screen size minus focus
		// end tile coord is half screen size plus focus
		// view center: start coord is: focus pos minus view center
		// view center: end coord is: focus pos plus (screen size minus view center)
		
		NSUInteger i = 0;
		CCSprite* tileSprite = nil;
		CCSpriteBatchNode* currentBatchNode = nil;
		KTTilemapTileset* previousTileset = nil;
		NSUInteger countBatchNodeReparenting = 0;
		
		for (int viewTilePosY = 0; viewTilePosY < _visibleTilesOnScreen.height; viewTilePosY++)
		{
			for (int viewTilePosX = 0; viewTilePosX < _visibleTilesOnScreen.width; viewTilePosX++)
			{
				NSAssert2(_visibleTiles.count > i,
						  @"Tile layer index (%u) out of bounds (%u)! Perhaps due to window resize?",
						  (unsigned int)i, (unsigned int)_visibleTiles.count);
				
				tileSprite = [_visibleTiles objectAtIndex:i++];

				// get the proper git coordinate, wrap around as needed
				CGPoint gidCoordInLayer = CGPointMake(viewTilePosX + tileOffset.x, (mapSize.height - 1 - viewTilePosY) - tileOffset.y);
				if (_endlessScrolling)
				{
				}
				
				// no tile at this coordinate?
				gid_t gid = [_tileLayer tileGidWithFlagsAt:gidCoordInLayer];
				if (gid == 0)
				{
					tileSprite.visible = NO;
					continue;
				}

				// get the gid's tileset, reuse previous tileset if possible
				KTTilemapTileset* currentTileset = previousTileset;
				if (currentTileset == nil || gid < currentTileset.firstGid || gid > currentTileset.lastGid)
				{
					currentTileset = [tilemap tilesetForGid:gid];
				}
				NSAssert1(currentTileset, @"tileset for gid %u is nil!", gid);
				
				// switch the batch node if the current gid uses a different tileset than the previous gid
				if (currentTileset != previousTileset)
				{
					previousTileset = currentTileset;
					currentBatchNode = [_batchNodes objectForKey:currentTileset.imageFile];
				}
				
				// change the tile sprite's batch node since we're switching tilesets
				if (tileSprite.parent != currentBatchNode)
				{
					countBatchNodeReparenting++;
					[tileSprite removeFromParentAndCleanup:NO];
					tileSprite.texture = currentBatchNode.texture;
					[currentBatchNode addChild:tileSprite];
					
					// prevent cocos2d from running an insertion sort on all children (sort by zOrder not needed here)
					tileSprite.isReorderChildDirty = NO;
					
					// if this batchnode has no parent, it needs to be added as child (happens on first use)
					if (currentBatchNode.parent == nil)
					{
						[self addChild:currentBatchNode];
					}
				}

				CGRect textureRect = [currentTileset textureRectForGid:gid];
				//NSAssert2(CGRectIsEmpty(textureRect) == NO, @"Texture rect for gid (%u) is empty, picked the wrong tileset? (%@)", gid, currentTileset);

				tileSprite.visible = YES;
				tileSprite.textureRect = textureRect;
				
				CGPoint pos = CGPointMake(viewTilePosX * gridSize.width + halfGridSize.width + pointOffset.x,
										  viewTilePosY * gridSize.height + halfGridSize.height + pointOffset.y);
				if (pointOffset.x <= 0.0f)
				{
					//pos.x -= gridSize.width;
				}
				if (pointOffset.y <= 0.0f)
				{
				}
				tileSprite.position = pos;
				if (i == 0)
				{
					LOG_EXPR(tileSprite.position);
				}
				
				// set flip defaults
				tileSprite.rotation = 0.0f;
				tileSprite.flipX = NO;
				tileSprite.flipY = NO;
				
				if (gid & KTTilemapTileDiagonalFlip)
				{
					// handle the 4 diagonally flipped states.
					gid_t gidFlipFlags = gid & (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip);
					if (gidFlipFlags == KTTilemapTileHorizontalFlip)
					{
						tileSprite.rotation = 90;
					}
					else if (gidFlipFlags == KTTilemapTileVerticalFlip)
					{
						tileSprite.rotation = 270;
					}
					else if (gidFlipFlags == (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip))
					{
						tileSprite.rotation = 90;
						tileSprite.flipX = YES;
					}
					else
					{
						tileSprite.rotation = 270;
						tileSprite.flipX = YES;
					}
				}
				else
				{
					tileSprite.flipX = (gid & KTTilemapTileHorizontalFlip);
					tileSprite.flipY = (gid & KTTilemapTileVerticalFlip);
				}
			}
		}
		
		/*
		if (countBatchNodeReparenting > 0)
		{
			LOG_EXPR(countBatchNodeReparenting);
		}
		 */
	}
	
	_previousPosition = position_;
}

-(void) setOpacity:(GLubyte)opacity
{
	if (_opacity != opacity)
	{
		_opacity = opacity;
		
		for (CCSprite* sprite in _visibleTiles)
		{
			sprite.opacity = _opacity;
		}
	}
}

@end
