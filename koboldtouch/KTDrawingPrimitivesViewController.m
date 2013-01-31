//
//  KTDrawingPrimitivesViewController.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 18.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTDrawingPrimitivesViewController.h"
#import "KTDrawingPrimitivesModel.h"
#import "KTDrawingPrimitives.h"

@implementation KTDrawingPrimitivesViewController

-(void) initWithDefaults
{
	self.model = [KTDrawingPrimitivesModel model];
}

#pragma mark View Controller Callbacks

-(void) loadView
{
	self.rootNode = [CCDrawNode node];
}

-(void) resetView
{
	CCDrawNode* drawNode = (CCDrawNode*)self.rootNode;
	[drawNode clear];
}

-(void) updateView
{
	CCDrawNode* drawNode = (CCDrawNode*)self.rootNode;
	KTDrawingPrimitivesModel* drawModel = (KTDrawingPrimitivesModel*)self.model;
	
	for (KTDrawDot* dot in drawModel.dots)
	{
		if (dot.isDrawing == NO)
		{
			dot.isDrawing = YES;
			[drawNode drawDot:dot.position
					   radius:dot.radius * CC_CONTENT_SCALE_FACTOR()
						color:dot.color];
		}
	}

	for (KTDrawLine* line in drawModel.lines)
	{
		if (line.isDrawing == NO)
		{
			line.isDrawing = YES;
			[drawNode drawSegmentFrom:line.endPoint1
								   to:line.endPoint2
							   radius:line.thickness * CC_CONTENT_SCALE_FACTOR()
								color:line.color];
		}
	}
	
	for (KTDrawPolygon* polygon in drawModel.polygons)
	{
		if (polygon.isDrawing == NO)
		{
			polygon.isDrawing = YES;

			if (polygon.isPolyLine && polygon.numberOfPoints >= 2)
			{
				for (NSUInteger i = 1; i < polygon.numberOfPoints; i++)
				{
					[drawNode drawSegmentFrom:polygon.points[i - 1]
										   to:polygon.points[i]
									   radius:polygon.outlineThickness * CC_CONTENT_SCALE_FACTOR()
										color:polygon.outlineColor];
				}
			}
			else if (polygon.numberOfPoints >= 3)
			{
				[drawNode drawPolyWithVerts:polygon.points
									  count:polygon.numberOfPoints
								  fillColor:polygon.fillColor
								borderWidth:polygon.outlineThickness * CC_CONTENT_SCALE_FACTOR()
								borderColor:polygon.outlineColor];
			}
			else
			{
				NSLog(@"can't draw KTDrawPolygon (%@) because it has only %lu points. A polygon requires at least 3 points, a polyline 2 points.",
					  polygon, (unsigned long)polygon.numberOfPoints);
			}
		}
	}
}

#pragma mark public interface

-(void) addDot:(KTDrawDot*)dot
{
	[(KTDrawingPrimitivesModel*)self.model addDot:dot];
}
-(void) removeDot:(KTDrawDot*)dot
{
	[(KTDrawingPrimitivesModel*)self.model removeDot:dot];
}
-(void) removeAllDots
{
	[(KTDrawingPrimitivesModel*)self.model removeAllDots];
}

-(void) addLine:(KTDrawLine*)line
{
	[(KTDrawingPrimitivesModel*)self.model addLine:line];
}
-(void) removeLine:(KTDrawLine*)line
{
	[(KTDrawingPrimitivesModel*)self.model removeLine:line];
}
-(void) removeAllLines
{
	[(KTDrawingPrimitivesModel*)self.model removeAllLines];
}

-(void) addPolygon:(KTDrawPolygon*)polygon
{
	[(KTDrawingPrimitivesModel*)self.model addPolygon:polygon];
}
-(void) removePolygon:(KTDrawPolygon*)polygon
{
	[(KTDrawingPrimitivesModel*)self.model removePolygon:polygon];
}
-(void) removeAllPolygons
{
	[(KTDrawingPrimitivesModel*)self.model removeAllPolygons];
}

@end
