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

#import "KTMoveAction.h"

@interface KTTilemapModel ()
// declare private methods here
@end


@implementation KTTilemapModel

-(void) load
{
	if (_tilemap == nil)
	{
		NSString* tmxFile = ((KTTilemapViewController*)self.controller).tmxFile;
		_tilemap = [KTTilemap tilemapWithTMXFile:tmxFile];
	}
}

-(void) unload
{
	_tilemap = nil;
}

@end
