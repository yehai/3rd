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

@interface KTTilemapLayerViewController ()
// declare private methods here
@end


@implementation KTTilemapLayerViewController

-(id) initWithTileLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		self.tileLayer = tileLayer;
		self.name = tileLayer.name;
	}
	return self;
}


-(void) loadView
{
	self.rootNode = [[KTTilemapLayerView alloc] initWithTileLayer:_tileLayer];
}

@end
