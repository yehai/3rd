//
//  KTTilemapObject.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//
//

#import "KTTilemapObject.h"

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
	return [NSString stringWithFormat:@"%@ (name: '%@', type: '%@', position: %.0f,%.0f, size: %.0f,%.0f, gid: %i, visible: %i, polyType: %i, points: %@, properties: %u)",
			[super description], _name, _type, _position.x, _position.y, _size.width, _size.height, _gid, _visible, _polyType, _points, (unsigned int)_properties.count];
}
@end
