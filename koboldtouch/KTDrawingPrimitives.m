//
//  KTDrawingPrimitives.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 18.01.13.
//
//

#import "KTDrawingPrimitives.h"
#import "kobold2d.h"

@implementation KTDrawPrimitive
@end


@implementation KTDrawDot

-(id) init
{
	self = [super init];
	if (self)
	{
		_radius = 1.0f;
		_color = ccc4f(1.0f, 1.0f, 1.0f, 1.0f);
	}
	return self;
}

@end


@implementation KTDrawLine

-(id) init
{
	self = [super init];
	if (self)
	{
		_thickness = 1.0f;
		_color = ccc4f(1.0f, 1.0f, 1.0f, 1.0f);;
	}
	return self;
}

@end


const NSUInteger kDefaultNumberOfPointsToAllocate = 8;

@implementation  KTDrawPolygon

-(id) init
{
	self = [super init];
	if (self)
	{
		_numberOfPoints = 0;
		_numberOfPointsAllocated = 0;
		[self allocateMemoryForNumberOfPoints:kDefaultNumberOfPointsToAllocate];
		
		_outlineThickness = 1.0f;
		_outlineColor = ccc4f(1.0f, 1.0f, 1.0f, 1.0f);
		_fillColor = ccc4f(0.0f, 0.0f, 0.0f, 0.0f);
	}
	return self;
}

-(void) dealloc
{
	free(_points);
}

-(NSString*) description
{
	CGPoint firstPoint = (_numberOfPoints > 0 ? _points[0] : CGPointZero);
	return [NSString stringWithFormat:@"%@ - first point: {%.3f, %.3f}, number of points: %lu",
			[super description], firstPoint.x, firstPoint.y, (unsigned long)_numberOfPoints];
}

@dynamic color;
-(ccColor4F) color
{
	return _fillColor;
}
-(void) setColor:(ccColor4F)color
{
	_outlineColor = color;
	_fillColor = color;
}

-(void) allocateMemoryForNumberOfPoints:(NSUInteger)additionalPoints
{
	NSUInteger requestedNumberOfPoints = _numberOfPoints + additionalPoints;
	if (requestedNumberOfPoints > _numberOfPointsAllocated)
	{
		do
		{
			if (_numberOfPointsAllocated == 0)
			{
				_numberOfPointsAllocated = requestedNumberOfPoints;
			}
			else
			{
				_numberOfPointsAllocated *= 2;
			}
		} while (requestedNumberOfPoints > _numberOfPointsAllocated);
		
		_points = realloc(_points, _numberOfPointsAllocated * sizeof(CGPoint));
	}
}

-(void) addPoint:(CGPoint)point
{
	[self allocateMemoryForNumberOfPoints:1];
	_points[_numberOfPoints++] = point;
}

-(void) addPoints:(CGPoint*)points count:(NSUInteger)count
{
	[self allocateMemoryForNumberOfPoints:count];
	
	for (NSUInteger i = 0; i < count; i++)
	{
		[self addPoint:points[i]];
	}
}

-(void) removeAllPoints
{
	_numberOfPoints = 0;
	_numberOfPointsAllocated = 0;
	[self allocateMemoryForNumberOfPoints:kDefaultNumberOfPointsToAllocate];
}

@end
