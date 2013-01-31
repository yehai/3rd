//
//  KTLegacyTilemapViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class CCTMXTiledMap;

/** Legacy tilemap view controller wrapping cocos2d's slow and minimalistic tilemap renderer CCTMXTiledMap.
 You can only create 128x128 tilemaps (16,384 tiles) with this tilemap renderer, and this maximum size may
 not even render at 60 fps on all devices. Use KTTilemapViewController instead to be able to display huge (millions of tiles)
 tilemaps at 60 fps.
 */
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
