//
//  KTLegacyTilemapViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class CCTMXTiledMap;

/** Legacy tilemap view controller wrapping cocos2d's slow and minimalistic tilemap renderer CCTMXTiledMap. */
@interface KTLegacyTilemapViewController : KTViewController
{
@protected
@private
}

/** The TMX file to load. Create this file with the Tiled Map Editor http://www.mapeditor.org */
@property (nonatomic, copy) NSString* tmxFile;

/** Returns the rootNode cast to CCTMXTiledMap. */
@property (nonatomic, readonly) CCTMXTiledMap* tilemap;

/** Initialize legacy tilemap viewcontroller with TMX file. Create this file with the Tiled Map Editor http://www.mapeditor.org */
+(id) legacyTilemapControllerWithTMXFile:(NSString*)tmxFile;
/** Initialize legacy tilemap viewcontroller with TMX file. Create this file with the Tiled Map Editor http://www.mapeditor.org */
-(id) initWithTMXFile:(NSString*)tmxFile;


@end
