//
//  KTDrawingPrimitivesModel.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 18.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTDrawingPrimitivesModel.h"
#import "KTDrawingPrimitivesViewController.h"
#import "KTDrawingPrimitives.h"

@implementation KTDrawingPrimitivesModel

-(void) addPrimitive:(KTDrawPrimitive*)primitive toArray:(NSMutableArray*)array
{
	[array addObject:primitive];
	_viewNeedsUpdate = YES;
}

-(void) removePrimitive:(KTDrawPrimitive*)primitive fromArray:(NSMutableArray*)array
{
	if ([array containsObject:primitive])
	{
		primitive.isDrawing = NO;
		[array removeObject:primitive];
		_viewNeedsReset = YES;
	}
}

-(void) addDot:(KTDrawDot*)dot
{
	if (_dots == nil)
	{
		_dots = [NSMutableArray arrayWithCapacity:1];
	}

	[self addPrimitive:dot toArray:_dots];
}
-(void) removeDot:(KTDrawDot*)dot
{
	[self removePrimitive:dot fromArray:_dots];
}
-(void) removeAllDots
{
	for (KTDrawDot* dot in [_dots reverseObjectEnumerator])
	{
		[self removePrimitive:dot fromArray:_dots];
	}
}

-(void) addLine:(KTDrawLine*)line
{
	if (_lines == nil)
	{
		_lines = [NSMutableArray arrayWithCapacity:1];
	}

	[self addPrimitive:line toArray:_lines];
}
-(void) removeLine:(KTDrawLine*)line
{
	[self removePrimitive:line fromArray:_lines];
}
-(void) removeAllLines
{
	for (KTDrawLine* line in [_lines reverseObjectEnumerator])
	{
		[self removePrimitive:line fromArray:_lines];
	}
}

-(void) addPolygon:(KTDrawPolygon*)polygon
{
	if (_polygons == nil)
	{
		_polygons = [NSMutableArray arrayWithCapacity:1];
	}

	[self addPrimitive:polygon toArray:_polygons];
}
-(void) removePolygon:(KTDrawPolygon*)polygon
{
	[self removePrimitive:polygon fromArray:_polygons];
}
-(void) removeAllPolygons
{
	for (KTDrawPolygon* polygon in [_polygons reverseObjectEnumerator])
	{
		[self removePrimitive:polygon fromArray:_polygons];
	}
}


-(void) clearAllDrawingFlags
{
	for (KTDrawDot* dot in _dots)
	{
		dot.isDrawing = NO;
	}
	for (KTDrawLine* line in _lines)
	{
		line.isDrawing = NO;
	}
	for (KTDrawPolygon* polygon in _polygons)
	{
		polygon.isDrawing = NO;
	}
}

// Executed after the step method
-(void) afterStep:(KTStepInfo *)stepInfo
{
	if (_viewNeedsReset)
	{
		[self clearAllDrawingFlags];
		
		KTDrawingPrimitivesViewController* drawVC = (KTDrawingPrimitivesViewController*)self.controller;
		[drawVC resetView];
		_viewNeedsReset = NO;
		[drawVC updateView];
		_viewNeedsUpdate = NO;
	}
	else if (_viewNeedsUpdate)
	{
		KTDrawingPrimitivesViewController* drawVC = (KTDrawingPrimitivesViewController*)self.controller;
		[drawVC updateView];
		_viewNeedsUpdate = NO;
	}
}

@end
