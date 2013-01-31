//
//  KTTilemapTileProperties.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 21.01.13.
//
//

#import "KTTilemapTileProperties.h"
#import "KTTilemapProperties.h"
#import "KTMutableNumber.h"

@implementation KTTilemapTileProperties

-(id) init
{
	self = [super init];
	if (self)
	{
		_tileProperties = [NSMutableDictionary dictionaryWithCapacity:16];
	}
	return self;
}

-(KTTilemapProperties*) propertiesForGid:(gid_t)gid
{
	return [_tileProperties objectForKey:[NSNumber numberWithUnsignedInt:gid]];
}

-(KTTilemapProperties*) propertiesForGid:(gid_t)gid createNonExistingProperties:(BOOL)createNonExistingProperties
{
	KTTilemapProperties* properties = [self propertiesForGid:gid];
	if (properties == nil && createNonExistingProperties)
	{
		properties = [[KTTilemapProperties alloc] init];
		[_tileProperties setObject:properties forKey:[NSNumber numberWithUnsignedInt:gid]];
	}
	return properties;
}

-(KTTilemapProperties*) propertiesForGid:(gid_t)gid setValue:(NSString*)string forKey:(NSString*)key
{
	KTTilemapProperties* properties = [self propertiesForGid:gid createNonExistingProperties:YES];
	KTMutableNumber* number = [properties numberFromString:string];
	if (number)
	{
		[properties setNumber:number forKey:key];
	}
	else
	{
		[properties setString:string forKey:key];
	}
	return properties;
}

-(KTTilemapProperties*) propertiesForGid:(gid_t)gid setNumber:(KTMutableNumber*)number forKey:(NSString*)key
{
	KTTilemapProperties* properties = [self propertiesForGid:gid createNonExistingProperties:YES];
	[properties setNumber:number forKey:key];
	return properties;
}

-(KTTilemapProperties*) propertiesForGid:(gid_t)gid setString:(NSString*)string forKey:(NSString*)key
{
	KTTilemapProperties* properties = [self propertiesForGid:gid createNonExistingProperties:YES];
	[properties setString:string forKey:key];
	return properties;
}

@end
