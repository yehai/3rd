//
//  KTTilemapObject.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTilemapObject.h"
#import "KTTilemapProperties.h"

@implementation KTTilemapObject

-(id) initWithCoder:(NSCoder*)aDecoder
{
	if ((self = [super init]))
	{
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder*)aCoder
{
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ (name: '%@', userType: '%@', position: %.0f,%.0f, objectType: %i, properties: %u)",
			[super description], _name, _userType, _position.x, _position.y, _objectType, (unsigned int)_properties.count];
}

-(KTTilemapProperties*) properties
{
	if (_properties == nil)
	{
		_properties = [[KTTilemapProperties alloc] init];
	}
	return _properties;
}

-(KTTilemapRectangleObject*) rectangleObjectFromPolyObject:(KTTilemapPolyObject*)polyObject
{
	KTTilemapRectangleObject* rectObject = [[KTTilemapRectangleObject alloc] init];
	rectObject.name = polyObject.name;
	rectObject.userType = polyObject.userType;
	rectObject.position = polyObject.position;
	[rectObject internal_setProperties:polyObject.properties];
	rectObject.size = CGSizeZero;
	return rectObject;
}

-(void) internal_setProperties:(KTTilemapProperties*)properties
{
	_properties = properties;
}

@end


@implementation KTTilemapPolyObject

-(id) init
{
	self = [super init];
	if (self)
	{
		self.objectType = KTTilemapObjectTypePolyLine;
		_points = nil;
	}
	return self;
}

-(void) makePointsFromString:(NSString*)string
{
	NSArray* pointStrings = [string componentsSeparatedByString:@" "];
	
	_boundingBox = CGRectZero;
	_numberOfPoints = (unsigned int)pointStrings.count;
	_points = realloc(_points, _numberOfPoints * sizeof(CGPoint));
	
	CGPoint boundingBoxBottomLeft = CGPointZero;
	CGPoint boundingBoxTopRight = CGPointZero;
	
	NSUInteger currentIndex = 0;
	for (NSString* pointString in pointStrings)
	{
		// damn CGPointFromString requires the format with brackets, NSPointFromString happily converts without brackets
		// converting the input string for both platforms to the correct format with brackets, just in case
		NSString* cgPointString = [NSString stringWithFormat:@"{%@}", pointString];
		
#if KK_PLATFORM_IOS
		CGPoint point = CGPointFromString(cgPointString);
#elif KK_PLATFORM_MAC
		CGPoint point = NSPointFromString(cgPointString);
#endif
		
		point.y *= -1.0f;
		_points[currentIndex++] = point;
		
		// update polygon bounding box
		boundingBoxBottomLeft.x = MIN(point.x, boundingBoxBottomLeft.x);
		boundingBoxBottomLeft.y = MIN(point.y, boundingBoxBottomLeft.y);
		boundingBoxTopRight.x = MAX(point.x, boundingBoxTopRight.x);
		boundingBoxTopRight.y = MAX(point.y, boundingBoxTopRight.y);
	}

	_boundingBox = CGRectMake(boundingBoxBottomLeft.x, boundingBoxBottomLeft.y, boundingBoxTopRight.x, boundingBoxTopRight.y);
	_boundingBox.size = CGSizeMake(boundingBoxTopRight.x - _boundingBox.origin.x, boundingBoxTopRight.y - _boundingBox.origin.y);
	_boundingBox.origin = ccpAdd(_position, _boundingBox.origin);
}

-(void) dealloc
{
	free(_points);
}

@end

@implementation KTTilemapRectangleObject

-(id) init
{
	self = [super init];
	if (self)
	{
		self.objectType = KTTilemapObjectTypeRectangle;
	}
	return self;
}

@dynamic rect;
-(CGRect) rect
{
	return CGRectMake(_position.x, _position.y, _size.width, _size.height);
}

@end

@implementation KTTilemapTileObject

-(id) init
{
	self = [super init];
	if (self)
	{
		self.objectType = KTTilemapObjectTypeTile;
	}
	return self;
}

@end
