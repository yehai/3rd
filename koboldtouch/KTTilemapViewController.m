//
//  KTTilemapViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapViewController.h"
#import "KTTilemapLayerViewController.h"
#import "KTTilemapModel.h"

#import "CCNode.h"

@interface KTTilemapViewController ()
// declare private methods here
@end


@implementation KTTilemapViewController

+(id) tilemapControllerWithTMXFile:(NSString*)tmxFile
{
	return [[self alloc] initWithTMXFile:tmxFile];
}

-(id) initWithTMXFile:(NSString*)tmxFile
{
	self = [super init];
	if (self)
	{
		self.tmxFile = tmxFile;
	}
	return self;
}

#pragma mark Controller Callbacks

-(void) initWithDefaults
{
	self.createModelBlock = ^{
		return [KTTilemapModel model];
	};
}

-(void) loadView
{
	[super loadView];
	
	KTTilemapModel* tilemapModel = (KTTilemapModel*)self.model;
	NSAssert1([tilemapModel isKindOfClass:[KTTilemapModel class]], @"tilemapModel (%@) is not a KTTilemapModel class", tilemapModel);

	for (KTTilemapLayer* layer in tilemapModel.tilemap.layers)
	{
		if (layer.isObjectLayer)
		{
			// TODO: object layers
			//KTTilemapLayerViewController* layerViewController = [self.subControllers lastObject];
			//layerViewController.objectLayer = layer;
		}
		else
		{
			KTTilemapLayerViewController* layerViewController = [[KTTilemapLayerViewController alloc] initWithTilemapModel:tilemapModel tileLayer:layer];
			[self addSubController:layerViewController];
		}
	}
}

@end
