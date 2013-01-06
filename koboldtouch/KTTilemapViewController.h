//
//  KTTilemapViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class KTTilemapModel;

/** New tilemap renderer by KoboldTouch (early version, work in progress!). View controller for TMX Tilemaps created by Tiled Map Editor. */
@interface KTTilemapViewController : KTViewController
{
}

/** The TMX file to load. */
@property (nonatomic, copy) NSString* tmxFile;

/** Initialize tilemap viewcontroller with TMX file. */
+(id) tilemapControllerWithTMXFile:(NSString*)tmxFile;
/** Initialize tilemap viewcontroller with TMX file. */
-(id) initWithTMXFile:(NSString*)tmxFile;

@end
