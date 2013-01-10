//
//  KTTilemapLayerViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapLayerViewController.h"
#import "KTTilemapModel.h"

// temporary
#import "KKInput.h"

#import "CCDirector.h"
#import "CCNode.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCActionInterval.h"
#import "CGPointExtension.h"
#import "KTTilemapLayerView.h"
#import "KTTilemapModel.h"
#import "KTTilemapLayerModel.h"

@interface KTTilemapLayerViewController ()
@end


@implementation KTTilemapLayerViewController

-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel tileLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		self.name = tileLayer.name;
		
		self.createModelBlock = ^()
		{
			self.tilemapLayerModel = [[KTTilemapLayerModel alloc] initWithTilemapModel:tilemapModel tileLayer:tileLayer];
			self.tilemapLayerModel.scrollCenter = [CCDirector sharedDirector].windowCenter;
			return self.tilemapLayerModel;
		};
	}
	return self;
}

-(void) loadView
{
	KTTilemapLayer* tileLayer = self.tilemapLayerModel.tileLayer;
	self.tilemapLayerView = [[KTTilemapLayerView alloc] initWithTileLayer:tileLayer];
	self.tilemapLayerView.visible = tileLayer.visible;
	self.rootNode = self.tilemapLayerView;
}

-(void) afterStep:(KTStepInfo *)stepInfo
{
	[_tilemapLayerView setScrollCenter:_tilemapLayerModel.scrollCenter];
	[_tilemapLayerView drawTileLayer:_tilemapLayerModel.tileLayer];
}

@end
