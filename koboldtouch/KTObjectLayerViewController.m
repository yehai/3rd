//
//  KTObjectLayerViewController.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTObjectLayerViewController.h"
#import "KTTilemapLayerModel.h"
#import "KTTilemapLayerView.h"
#import "KTDrawingPrimitivesViewController.h"
#import "KTDrawingPrimitives.h"
#import "KTTilemap.h"

@implementation KTObjectLayerViewController

@dynamic objectLayer;
-(KTTilemapLayer*) objectLayer
{
	return ((KTTilemapLayerModel*)self.model).tileLayer;
}

-(void) setObjectSpawnDelegate:(id<KTObjectLayerSpawnProtocol>)objectSpawnDelegate
{
	_objectSpawnDelegate = objectSpawnDelegate;
	_spawnDelegateImplementsDidCreateObject = [_objectSpawnDelegate respondsToSelector:@selector(objectLayerViewController:didCreateObject:polygon:)];
}

-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel objectLayer:(KTTilemapLayer*)objectLayer
{
	self = [super init];
	if (self)
	{
		self.name = objectLayer.name;
		
		self.createModelBlock = ^()
		{
			return [[KTTilemapLayerModel alloc] initWithTilemapLayer:objectLayer];
		};
	}
	return self;
}

-(void) setDrawObjects:(BOOL)drawObjects
{
	if (_drawObjects != drawObjects)
	{
		_drawObjects = drawObjects;

		if (_drawObjects)
		{
			[self addDrawingPrimitivesViewController];
		}
		else
		{
			[self removeDrawingPrimitivesViewController];
		}
	}
}

#pragma mark Draw primitives

const ccColor4F kOutlineColor = (ccColor4F){1.0f, 1.0f, 0.0f, 0.6f};
const ccColor4F kFillColor = (ccColor4F){0.7f, 0.7f, 0.7f, 0.16f};
const ccColor4F kTileOutlineColor = (ccColor4F){0.0f, 0.0f, 0.0f, 0.8f};
const ccColor4F kTileFillColor = (ccColor4F){1.0f, 0.0f, 1.0f, 0.2f};
const ccColor4F kBBoxOutlineColor = (ccColor4F){1.0f, 0.1f, 0.1f, 0.8f};
const ccColor4F kBBoxFillColor = (ccColor4F){0.0f, 0.0f, 0.0f, 0.0f};

-(KTDrawPolygon*) drawPolygonFromPosition:(CGPoint)position size:(CGSize)size isTile:(BOOL)isTile
{
	KTDrawPolygon* polygon = [[KTDrawPolygon alloc] init];
	polygon.outlineColor = (isTile ? kTileOutlineColor : kOutlineColor);
	polygon.fillColor = (isTile ? kTileFillColor : kFillColor);

	if (CGSizeEqualToSize(size, CGSizeZero))
	{
		// zero sized rect will draw a rect that has its position at the center
		const float kOffset = 10.0f;
		position.x -= kOffset;
		position.y -= kOffset;
		size = CGSizeMake(kOffset * 2.0f, kOffset * 2.0f);
	}
	else
	{
		// ensure minimum width & height
		size.width = fmaxf(size.width, 1.0f);
		size.height = fmaxf(size.height, 1.0f);
	}
	
	CGPoint oppositeCorner = ccpAdd(position, CGPointMake(size.width, size.height));
	[polygon addPoint:position];
	[polygon addPoint:CGPointMake(position.x, oppositeCorner.y)];
	[polygon addPoint:oppositeCorner];
	[polygon addPoint:CGPointMake(oppositeCorner.x, position.y)];
	
	return polygon;
}

-(KTDrawPolygon*) drawPolygonFromPolygonObject:(KTTilemapPolyObject*)object isPolyLine:(BOOL)isPolyLine
{
	NSAssert1(object.numberOfPoints >= 2, @"object %@ has not enough points for a polyline/polygon", object);
	NSAssert1(object.objectType == KTTilemapObjectTypePolyLine || object.numberOfPoints >= 3, @"object %@ has not enough points for a polygon", object);
	
	KTDrawPolygon* polygon = [[KTDrawPolygon alloc] init];
	[polygon allocateMemoryForNumberOfPoints:object.numberOfPoints];
	for (NSUInteger i = 0; i < object.numberOfPoints; i++)
	{
		[polygon addPoint:ccpAdd(object.position, object.points[i])];
	}
	
	polygon.outlineColor = kOutlineColor;
	polygon.fillColor = kFillColor;
	polygon.isPolyLine = isPolyLine;
	
	return polygon;
}

-(void) addRectangleObject:(KTTilemapRectangleObject*)object
{
	if (_objectSpawnDelegate == nil || [_objectSpawnDelegate respondsToSelector:@selector(objectLayerViewController:willCreateObject:)] == NO ||
		[_objectSpawnDelegate objectLayerViewController:self willCreateObject:object])
	{
		KTDrawPolygon* polygon = [self drawPolygonFromPosition:object.position size:object.size isTile:NO];
		[_drawingPrimitivesVC addPolygon:polygon];
		
		if (_spawnDelegateImplementsDidCreateObject)
		{
			[_objectSpawnDelegate objectLayerViewController:self didCreateObject:object polygon:polygon];
		}
	}
}

-(void) addBoundingBoxForPolyObject:(KTTilemapPolyObject*)object
{
	//if (_drawPolyObjectBoundingBoxes)
	{
		KTDrawPolygon* bbox = [self drawPolygonFromPosition:object.boundingBox.origin size:object.boundingBox.size isTile:NO];
		bbox.outlineColor = kBBoxOutlineColor;
		bbox.fillColor = kBBoxFillColor;
		[_drawingPrimitivesVC addPolygon:bbox];
	}
}

-(void) addPolylineObject:(KTTilemapPolyObject*)object
{
	if (_objectSpawnDelegate == nil || [_objectSpawnDelegate respondsToSelector:@selector(objectLayerViewController:willCreateObject:)] == NO ||
		[_objectSpawnDelegate objectLayerViewController:self willCreateObject:object])
	{
		KTDrawPolygon* polygon = [self drawPolygonFromPolygonObject:object isPolyLine:YES];
		[_drawingPrimitivesVC addPolygon:polygon];

		[self addBoundingBoxForPolyObject:object];

		if (_spawnDelegateImplementsDidCreateObject)
		{
			[_objectSpawnDelegate objectLayerViewController:self didCreateObject:object polygon:polygon];
		}
	}
}

-(void) addPolygonObject:(KTTilemapPolyObject*)object
{
	if (_objectSpawnDelegate == nil || [_objectSpawnDelegate respondsToSelector:@selector(objectLayerViewController:willCreateObject:)] == NO ||
		[_objectSpawnDelegate objectLayerViewController:self willCreateObject:object])
	{
		KTDrawPolygon* polygon = [self drawPolygonFromPolygonObject:object isPolyLine:NO];
		[_drawingPrimitivesVC addPolygon:polygon];

		[self addBoundingBoxForPolyObject:object];

		if (_spawnDelegateImplementsDidCreateObject)
		{
			[_objectSpawnDelegate objectLayerViewController:self didCreateObject:object polygon:polygon];
		}
	}
}

-(void) addTileObject:(KTTilemapTileObject*)object
{
	if (_objectSpawnDelegate == nil || [_objectSpawnDelegate respondsToSelector:@selector(objectLayerViewController:willCreateObject:)] == NO ||
		[_objectSpawnDelegate objectLayerViewController:self willCreateObject:object])
	{
		KTDrawPolygon* polygon = [self drawPolygonFromPosition:object.position size:object.size isTile:YES];
		[_drawingPrimitivesVC addPolygon:polygon];

		if (_spawnDelegateImplementsDidCreateObject)
		{
			[_objectSpawnDelegate objectLayerViewController:self didCreateObject:object polygon:polygon];
		}
	}
}

-(void) addDrawingPrimitivesViewController
{
	if (_drawingPrimitivesVC == nil)
	{
		_drawingPrimitivesVC = [KTDrawingPrimitivesViewController controller];
		_drawingPrimitivesVC.loadViewBlock = ^(CCNode* rootNode){
			rootNode.zOrder = 0xFFFFFF;
		};
		[self addSubController:_drawingPrimitivesVC];
		
		KTTilemapLayerModel* objectLayerModel = (KTTilemapLayerModel*)self.model;
		NSAssert(objectLayerModel, @"objectLayerModel is nil");
		
		for (KTTilemapObject* object in objectLayerModel.tileLayer.objects)
		{
			switch (object.objectType)
			{
				case KTTilemapObjectTypeRectangle:
					[self addRectangleObject:(KTTilemapRectangleObject*)object];
					break;
				case KTTilemapObjectTypePolyLine:
					[self addPolylineObject:(KTTilemapPolyObject*)object];
					break;
				case KTTilemapObjectTypePolygon:
					[self addPolygonObject:(KTTilemapPolyObject*)object];
					break;
				case KTTilemapObjectTypeTile:
					[self addTileObject:(KTTilemapTileObject*)object];
					break;
				default:
					[NSException raise:@"unhandled KTTilemapObjectType" format:@"object %@ type %u is unhandled in switch", object, object.objectType];
					break;
			}
		}
	}
}

-(void) removeDrawingPrimitivesViewController
{
	[self removeSubController:_drawingPrimitivesVC];
	_drawingPrimitivesVC = nil;
}

#pragma mark loadView

-(void) loadView
{
	KTTilemapLayer* objectLayer = self.objectLayer;
	KTTilemapLayerView* objectLayerView = [[KTTilemapLayerView alloc] initWithTilemapLayer:objectLayer];
	objectLayerView.visible = objectLayer.visible;
	self.rootNode = objectLayerView;
}

@end
