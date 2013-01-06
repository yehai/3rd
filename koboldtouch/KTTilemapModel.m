//
//  KTTilemapModel.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapModel.h"
#import "KTTilemapViewController.h"
#import "KTMacros.h"

@interface KTTilemapModel ()
// declare private methods here
@end


@implementation KTTilemapModel

-(void) load
{
	if (_tilemap == nil)
	{
		NSString* tmxFile = ((KTTilemapViewController*)self.controller).tmxFile;
		KTASSERT_FILEEXISTS(tmxFile);
		_tilemap = [[KTTilemap alloc] init];
		[_tilemap parseTMXFile:tmxFile];
	}
}

-(void) unload
{
}

@end
