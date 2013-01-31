//
//  KTTilemapViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapViewController.h"
#import "KTTileLayerViewController.h"
#import "KTObjectLayerViewController.h"
#import "KTTilemapModel.h"
#import "KTTilemapLayerModel.h"
#import "KTMoveAction.h"

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
		if (layer.isTileLayer)
		{
			KTTileLayerViewController* tileLayerVC = [[KTTileLayerViewController alloc] initWithTilemapModel:tilemapModel tileLayer:layer];
			[self addSubController:tileLayerVC];
		}
		else
		{
			KTObjectLayerViewController* objectLayerVC = [[KTObjectLayerViewController alloc] initWithTilemapModel:tilemapModel objectLayer:layer];
			objectLayerVC.objectSpawnDelegate = _objectSpawnDelegate;
			[self addSubController:objectLayerVC];
		}
	}
}

-(void) setDrawObjects:(BOOL)drawObjects
{
	if (_drawObjects != drawObjects)
	{
		_drawObjects = drawObjects;
		for (KTObjectLayerViewController* objectLayerVC in self.subControllers)
		{
			if ([objectLayerVC isKindOfClass:[KTObjectLayerViewController class]])
			{
				objectLayerVC.drawObjects = _drawObjects;
			}
		}
	}
}

-(void) setDrawPolyObjectBoundingBoxes:(BOOL)drawPolyObjectBoundingBoxes
{
	if (_drawPolyObjectBoundingBoxes != drawPolyObjectBoundingBoxes)
	{
		_drawPolyObjectBoundingBoxes = drawPolyObjectBoundingBoxes;
		for (KTObjectLayerViewController* objectLayerVC in self.subControllers)
		{
			if ([objectLayerVC isKindOfClass:[KTObjectLayerViewController class]])
			{
				objectLayerVC.drawPolyObjectBoundingBoxes = _drawPolyObjectBoundingBoxes;
			}
		}
	}
}

#pragma mark Layer access

-(id) tilemapLayerViewControllerByName:(NSString*)layerName
{
	id layerVC = [self subControllerByName:layerName];
	NSAssert2([layerVC isKindOfClass:[KTTileLayerViewController class]],
			  @"subcontroller with name '%@' is not a KTTilemapLayerViewController, it's a %@",
			  layerName, NSStringFromClass([layerVC class]));
	return layerVC;
}

#pragma mark Scroll Helper

-(void) scrollLayerModel:(KTTilemapLayerModel*)layerModel
				position:(CGPoint)position
			  timeFactor:(float)timeFactor
		positionIsOffset:(BOOL)positionIsOffset
	   timeFactorIsSpeed:(BOOL)timeFactorIsSpeed
{
	CGPoint destination = positionIsOffset ? ccpAdd(layerModel.position, position) : position;
	destination = [layerModel capPositionToScrollBoundary:destination];
	
	if (timeFactor <= 0.0f)
	{
		// instant scrolling, bypass actions
		layerModel.position = destination;
	}
	else if (CGPointEqualToPoint(layerModel.position, destination) == NO)
	{
		if (timeFactorIsSpeed)
		{
			[layerModel runAction:[KTMoveAction actionWithSpeed:timeFactor destination:destination]];
		}
		else
		{
			[layerModel runAction:[KTMoveAction actionWithDuration:timeFactor destination:destination]];
		}
	}
}

-(void) scrollToPosition:(CGPoint)position timeFactor:(float)timeFactor positionIsOffset:(BOOL)positionIsOffset timeFactorIsSpeed:(BOOL)timeFactorIsSpeed
{
	for (id layerVC in self.subControllers)
	{
		if ([layerVC isKindOfClass:[KTTileLayerViewController class]] ||
			[layerVC isKindOfClass:[KTObjectLayerViewController class]])
		{
			KTTileLayerViewController* tileLayerVC = (KTTileLayerViewController*)layerVC;
			KTTilemapLayerModel* layerModel = (KTTilemapLayerModel*)tileLayerVC.model;

			[self scrollLayerModel:layerModel
						  position:position
						timeFactor:timeFactor
				  positionIsOffset:positionIsOffset
				 timeFactorIsSpeed:timeFactorIsSpeed];
		}
	}
}

-(CGPoint) positionFromTileCoord:(CGPoint)tileCoord
{
	CGSize gridSize = ((KTTilemapModel*)self.model).tilemap.gridSize;
	return CGPointMake(tileCoord.x * gridSize.width, tileCoord.y * gridSize.height);
}

#pragma mark Scroll instantly

-(void) scrollToPosition:(CGPoint)position
{
	[self scrollToPosition:position timeFactor:0.0f positionIsOffset:NO timeFactorIsSpeed:NO];
}
-(void) scrollToTileCoordinate:(CGPoint)tileCoord
{
	[self scrollToPosition:[self positionFromTileCoord:tileCoord] timeFactor:0.0f positionIsOffset:NO timeFactorIsSpeed:NO];
}
-(void) scrollByPointOffset:(CGPoint)pointOffset
{
	[self scrollToPosition:pointOffset timeFactor:0.0f positionIsOffset:YES timeFactorIsSpeed:NO];
}
-(void) scrollByTileOffset:(CGPoint)tileOffset
{
	[self scrollToPosition:[self positionFromTileCoord:tileOffset] timeFactor:0.0f positionIsOffset:YES timeFactorIsSpeed:NO];
}

#pragma mark Scroll with speed/duration

-(void) scrollToPosition:(CGPoint)position duration:(float)duration
{
	[self scrollToPosition:position timeFactor:duration positionIsOffset:NO timeFactorIsSpeed:NO];
}
-(void) scrollToTileCoordinate:(CGPoint)tileCoord duration:(float)duration
{
	[self scrollToPosition:[self positionFromTileCoord:tileCoord] timeFactor:duration positionIsOffset:NO timeFactorIsSpeed:NO];
}

-(void) scrollToPosition:(CGPoint)position speed:(float)speed
{
	[self scrollToPosition:position timeFactor:speed positionIsOffset:NO timeFactorIsSpeed:YES];
}
-(void) scrollToTileCoordinate:(CGPoint)tileCoord speed:(float)speed
{
	[self scrollToPosition:[self positionFromTileCoord:tileCoord] timeFactor:speed positionIsOffset:NO timeFactorIsSpeed:YES];
}

-(void) scrollByPointOffset:(CGPoint)pointOffset duration:(float)duration
{
	[self scrollToPosition:pointOffset timeFactor:duration positionIsOffset:YES timeFactorIsSpeed:NO];
}
-(void) scrollByTileOffset:(CGPoint)tileOffset duration:(float)duration
{
	[self scrollToPosition:[self positionFromTileCoord:tileOffset] timeFactor:duration positionIsOffset:YES timeFactorIsSpeed:NO];
}

-(void) scrollByPointOffset:(CGPoint)pointOffset speed:(float)speed
{
	[self scrollToPosition:pointOffset timeFactor:speed positionIsOffset:YES timeFactorIsSpeed:YES];
}
-(void) scrollByTileOffset:(CGPoint)tileOffset speed:(float)speed
{
	[self scrollToPosition:[self positionFromTileCoord:tileOffset] timeFactor:speed positionIsOffset:YES timeFactorIsSpeed:YES];
}

@end
