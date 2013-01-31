//
//  KTTilemapLayerViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTileLayerViewController.h"
#import "KTTilemapModel.h"

// temporary
#import "KKInput.h"

#import "CCDirector.h"
#import "CCNode.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCActionInterval.h"
#import "CGPointExtension.h"
#import "KTTileLayerView.h"
#import "KTTilemapModel.h"
#import "KTTilemapLayerModel.h"

@interface KTTileLayerViewController ()
@end


@implementation KTTileLayerViewController

@dynamic tileLayer;
-(KTTilemapLayer*) tileLayer
{
	return ((KTTilemapLayerModel*)self.model).tileLayer;
}

-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel tileLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		self.name = tileLayer.name;
		
		self.createModelBlock = ^()
		{
			return [[KTTilemapLayerModel alloc] initWithTilemapLayer:tileLayer];
		};
	}
	return self;
}

-(void) loadView
{
	KTTilemapLayer* tileLayer = self.tileLayer;
	KTTileLayerView* tileLayerView = [[KTTileLayerView alloc] initWithTileLayer:tileLayer];
	tileLayerView.visible = tileLayer.visible;
	tileLayerView.opacity = tileLayer.opacity;
	self.rootNode = tileLayerView;
}

@end
