//
//  KTModel.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 24.09.12.
//
//

#import "KTModel.h"
#import "KTController.h"
#import "KTGameController.h"
#import "KTArchiveController.h"
#import "KTMutableNumber.h"

@implementation KTModel

NSString* const kCodingKeyRemainingUntilNextStep = @"remainingUntilNextStep";
NSString* const kCodingKeyForKeyedValues = @"keyedValues";

-(void) encodeWithCoder:(NSCoder*)aCoder
{
	NSLog(@"encoding: %@", NSStringFromClass([self class]));
	
	NSUInteger currentStep = [KTGameController sharedGameController].currentStep;
	[aCoder encodeInteger:self.nextStep - currentStep forKey:kCodingKeyRemainingUntilNextStep];
	[aCoder encodeBool:self.paused forKey:@"paused"];
	if (_keyedValues)
	{
		[aCoder encodeObject:_keyedValues forKey:kCodingKeyForKeyedValues];
	}
	
	[self archiveWithCoder:(NSKeyedArchiver*)aCoder];
}

-(id) initWithCoder:(NSCoder*)aDecoder
{
	NSLog(@"decoding: %@", NSStringFromClass([self class]));
	self = [super init];
	if (self)
	{
		NSUInteger remainingUntilNextStep = [aDecoder decodeIntegerForKey:kCodingKeyRemainingUntilNextStep];
		self.nextStep = [KTGameController sharedGameController].currentStep + remainingUntilNextStep;
		self.paused = [aDecoder decodeBoolForKey:@"paused"];
		_keyedValues = [aDecoder decodeObjectForKey:kCodingKeyForKeyedValues];

		KTArchiveController* archiveController = [KTGameController sharedGameController].archiveController;
		[self initWithArchive:(NSKeyedUnarchiver*)aDecoder archiveVersion:archiveController.archiveVersionBeingDecoded];
	}
	return self;
}

+(id) model
{
	return [[self alloc] init];
}

-(void) unload
{
	_keyedValues = nil;
}

#pragma mark Overrides
-(void) initWithArchive:(NSKeyedUnarchiver*)aDecoder archiveVersion:(int)archiveVersion
{
}
-(void) archiveWithCoder:(NSKeyedArchiver*)aCoder
{
}


#pragma mark Paused

-(void) setPaused:(BOOL)paused
{
	[super setPaused:paused];
	
	// synchronize model/controller pause
	if (_controller.paused != paused)
	{
		_controller.paused = paused;
	}
}

-(void) internal_setController:(KTController*)controller
{
	_controller = controller;
}

#pragma mark Key/Value Model
-(void) setValue:(id)value forKey:(NSString*)key
{
	if (_keyedValues == nil)
	{
		_keyedValues = [NSMutableDictionary dictionary];
	}
	
	[_keyedValues setValue:value forKey:key];
}

#pragma mark BOOL
-(void) setBool:(BOOL)boolValue forKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	if (value)
		value.boolValue = boolValue;
	else
		[self setValue:[[KTMutableNumber alloc] initWithBool:boolValue] forKey:key];
}

-(BOOL) boolForKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	return (value ? value.boolValue : NO);
}

#pragma mark float
-(void) setFloat:(float)floatValue forKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	if (value)
		value.floatValue = floatValue;
	else
		[self setValue:[[KTMutableNumber alloc] initWithFloat:floatValue] forKey:key];
}

-(float) floatForKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	return (value ? value.floatValue : 0.0f);
}

#pragma mark double
-(void) setDouble:(double)doubleValue forKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	if (value)
		value.doubleValue = doubleValue;
	else
		[self setValue:[[KTMutableNumber alloc] initWithDouble:doubleValue] forKey:key];
}

-(double) doubleForKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	return (value ? value.doubleValue : 0.0);
}

#pragma mark int32
-(void) setInt32:(int32_t)int32Value forKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	if (value)
		value.intValue = int32Value;
	else
		[self setValue:[[KTMutableNumber alloc] initWithInt:int32Value] forKey:key];
}

-(int32_t) int32ForKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	return (value ? value.intValue : 0);
}

-(void) setUnsignedInt32:(uint32_t)unsignedInt32Value forKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	if (value)
		value.unsignedIntValue = unsignedInt32Value;
	else
		[self setValue:[[KTMutableNumber alloc] initWithUnsignedInt:unsignedInt32Value] forKey:key];
}

-(uint32_t) unsignedInt32ForKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	return (value ? value.unsignedIntValue : 0);
}

#pragma mark int64
-(void) setInt64:(int64_t)int64Value forKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	if (value)
		value.longLongValue = int64Value;
	else
		[self setValue:[[KTMutableNumber alloc] initWithLongLong:int64Value] forKey:key];
}

-(int64_t) int64ForKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	return (value ? value.longLongValue : 0);
}

-(void) setUnsignedInt64:(uint64_t)unsignedInt64Value forKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	if (value)
		value.unsignedLongLongValue = unsignedInt64Value;
	else
		[self setValue:[[KTMutableNumber alloc] initWithUnsignedLongLong:unsignedInt64Value] forKey:key];
}

-(uint64_t) unsignedInt64ForKey:(NSString*)key
{
	KTMutableNumber* value = [_keyedValues valueForKey:key];
	return (value ? value.unsignedLongLongValue : 0);
}

-(KTMutableNumber*) mutableNumberForKey:(NSString*)key
{
	return [_keyedValues valueForKey:key];
}

@end
