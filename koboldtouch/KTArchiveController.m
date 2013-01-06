//
//  KTSaveLoadController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTArchiveController.h"
#import "KTGameController.h"
#import "KTSceneViewController.h"
#import "KTModel.h"

NSString* const kCodingKeyForArchiveVersion = @"~>archiveVersion";

@implementation KTArchiveController

+(id) saveLoadControllerWithArchiveVersion:(int)archiveVersion
{
	return [[self alloc] initWithArchiveVersion:archiveVersion];
}

-(id) initWithArchiveVersion:(int)archiveVersion
{
	self = [super init];
	if (self)
	{
		NSAssert1(archiveVersion >= 0, @"archive version must be a positive number! Got: %i", archiveVersion);
		_archiveVersion = archiveVersion;
		_archiveVersionBeingDecoded = KTArchiveNotDecoding;
	}
	return self;
}

#pragma mark Archiving

-(void) archiveController:(KTController*)controller coder:(NSKeyedArchiver*)coder level:(unsigned int)level index:(unsigned int)index
{
	if (controller.model)
	{
		NSString* key = [NSString stringWithFormat:@"%u,%u", level, index];
		NSData* data = [NSKeyedArchiver archivedDataWithRootObject:controller.model];
		[coder encodeObject:data forKey:key];
		NSLog(@"key (%@): encoded model (%@) of controller (%@)", key, controller.model, controller);
	}
	
	level++;
	unsigned int count = (unsigned int)controller.subControllers.count;
	for (unsigned int i = 0; i < count; i++)
	{
		KTController* subController = [controller.subControllers objectAtIndex:i];
		[self archiveController:subController coder:coder level:level index:i];
	}
}

-(NSData*) archivedDataWithController:(KTSceneViewController*)controller
{
	NSMutableData* data = [NSMutableData data];
	NSKeyedArchiver* coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[coder encodeInt:_archiveVersion forKey:kCodingKeyForArchiveVersion];
	
	unsigned int level = 0, index = 0;
	[self archiveController:controller coder:coder level:level index:index];
	
	[coder finishEncoding];
	return data;
}

-(void) writeToFile:(NSString*)file controller:(KTSceneViewController*)controller
{
	NSData* data = [self archivedDataWithController:controller];
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@", self.gameController.appSupportDirectory, file];
	[data writeToFile:fullPath atomically:YES];
}


#pragma mark Unarchiving

-(int) archiveVersionForData:(NSData*)data
{
	NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	if ([decoder containsValueForKey:kCodingKeyForArchiveVersion])
	{
		return [decoder decodeIntForKey:kCodingKeyForArchiveVersion];
	}
	return KTArchiveNotCompatible;
}

-(int) archiveVersionFromFile:(NSString*)file
{
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@", self.gameController.appSupportDirectory, file];
	if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
	{
		NSData* data = [NSData dataWithContentsOfFile:fullPath];
		return [self archiveVersionForData:data];
	}
	return KTArchiveFileNotFound;
}

-(void) unarchiveController:(KTController*)controller decoder:(NSKeyedUnarchiver*)decoder level:(unsigned int)level index:(unsigned int)index
{
	NSString* key = [NSString stringWithFormat:@"%u,%u", level, index];
	NSData* data = [decoder decodeObjectForKey:key];
	if (data)
	{
		KTModel* model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		NSLog(@"key (%@): decoded model (%@) for controller (%@)", key, model, controller);
		NSAssert1([model isKindOfClass:[KTModel class]], @"unarchived object (%@) is not a KTModel object!", model);

		[controller internal_setModel:model];
	}
	
	level++;
	unsigned int count = (unsigned int)controller.subControllers.count;
	for (unsigned int i = 0; i < count; i++)
	{
		KTController* subController = [controller.subControllers objectAtIndex:i];
		[self unarchiveController:subController decoder:decoder level:level index:i];
	}
}

-(void) unarchiveController:(KTSceneViewController*)controller withData:(NSData*)data
{
	_archiveVersionBeingDecoded = [self archiveVersionForData:data];
	NSLog(@"Loading Archive Version: %u (current version: %i)", _archiveVersionBeingDecoded, _archiveVersion);

	NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	unsigned int level = 0, index = 0;
	[self unarchiveController:controller decoder:decoder level:level index:index];
	
	_archiveVersionBeingDecoded = KTArchiveNotDecoding;
}

-(void) loadFromFile:(NSString*)file controller:(KTSceneViewController*)controller
{
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@", self.gameController.appSupportDirectory, file];
	if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
	{
		NSData* data = [NSData dataWithContentsOfFile:fullPath];
		[self unarchiveController:controller withData:data];
	}
	else
	{
		NSLog(@"can't load archive, file '%@' does not exist!", fullPath);
	}
}

@end
