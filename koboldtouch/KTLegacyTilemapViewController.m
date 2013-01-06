//
//  KTLegacyTilemapViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTLegacyTilemapViewController.h"
#import "KTMacros.h"

#import "CCTMXTiledMap.h"

@implementation KTLegacyTilemapViewController

@dynamic tilemap;

-(CCTMXTiledMap*) tilemap
{
	return (CCTMXTiledMap*)self.rootNode;
}

+(id) legacyTilemapControllerWithTMXFile:(NSString*)tmxFile
{
	return [[self alloc] initWithTMXFile:tmxFile];
}

-(id) initWithTMXFile:(NSString*)tmxFile
{
	self = [super init];
	if (self)
	{
		self.tmxFile = tmxFile;
	}
	return self;
}


-(void) loadView
{
	NSAssert1(_tmxFile, @"legacy tilemap view controller (%@): tmxFile is nil!", self);
	KTASSERT_FILEEXISTS(_tmxFile);
	
	self.rootNode = [CCTMXTiledMap tiledMapWithTMXFile:_tmxFile];
}

@end
