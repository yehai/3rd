//
//  KTTilemapProperties.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 21.01.13.
//
//

#import "KTTilemapProperties.h"
#import "KTMutableNumber.h"

static NSNumberFormatter* __numberFormatter = nil;

@implementation KTTilemapProperties

-(id) init
{
	self = [super init];
	if (self)
	{
		_properties = [NSMutableDictionary dictionaryWithCapacity:1];
		
		if (__numberFormatter == nil)
		{
			__numberFormatter = [[NSNumberFormatter alloc] init];
			[__numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			// Why not make it locale-aware? Because it would make TMX maps created by US developers unusable by
			// devs in other countries whose decimal separator is not a dot but a comma.
			[__numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
		}
	}
	return self;
}

-(void) setNumber:(KTMutableNumber*)number forKey:(NSString*)key
{
	[_properties setObject:number forKey:key];
}

-(void) setString:(NSString*)string forKey:(NSString*)key
{
	[_properties setObject:string forKey:key];
}

-(KTMutableNumber*) numberForKey:(NSString*)name
{
	id object = [_properties objectForKey:name];
	NSAssert2(object == nil || [object isKindOfClass:[KTMutableNumber class]],
			  @"requested number for key '%@' was not a KTMutableNumber but a %@",
			  name, NSStringFromClass([object class]));
	return (KTMutableNumber*)object;
}

-(NSString*) stringForKey:(NSString*)name
{
	id object = [_properties objectForKey:name];
	NSAssert2(object == nil || [object isKindOfClass:[NSString class]],
			  @"requested string for key '%@' was not a NSString but a %@",
			  name, NSStringFromClass([object class]));
	return (NSString*)object;
}

-(KTMutableNumber*) numberFromString:(NSString*)string
{
	NSNumber* number = [__numberFormatter numberFromString:string];
	
	if (number)
	{
		if (number.objCType[0] == 'f' || number.objCType[0] == 'd')
		{
			return [KTMutableNumber numberWithFloat:number.floatValue];
		}
		else
		{
			return [KTMutableNumber numberWithInt:number.intValue];
		}
	}
#if DEBUG
	else
	{
		// do a quick test to see if the user used , instead of . for floating point values
		NSString* testString = [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
		NSNumber* testNumber = [__numberFormatter numberFromString:testString];
		if (testNumber)
		{
			NSLog(@"KTTMXParser WARNING: The string '%@' supposedly represents a number, but used a , as decimal separator. Do not use , (comma) as decimal separator, use . (dot) instead.", string);
		}
	}
#endif
	
	return nil;
}

-(void) setValue:(NSString*)string forKey:(NSString*)key
{
	KTMutableNumber* number = [self numberFromString:string];
	if (number)
	{
		[self setNumber:number forKey:key];
	}
	else
	{
		[self setString:string forKey:key];
	}
}

@dynamic count;
-(NSUInteger) count
{
	return _properties.count;
}

@end
