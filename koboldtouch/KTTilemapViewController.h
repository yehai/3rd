//
//  KTTilemapViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"
#import "KTObjectLayerSpawnProtocol.h"

@class KTTilemapModel;
@class KTTileLayerViewController;

/** New tilemap renderer of KoboldTouch, completely rewritten with a very clean underlying data model. 
 Can load TMX Tilemaps created by Tiled Map Editor or you can create a tilemap from scratch programmatically.
 
 Tip: when using the scrolling API with speed always use integer speed values for best scrolling quality.
 Decimal values may cause unsteady scrolling because the tilemap's position is always rounded to the next
 nearest integer value to avoid "black line" artifacts. If possible avoid the duration based scrolling
 because it's difficult to ensure a steady movement rate.
 */
@interface KTTilemapViewController : KTViewController

/** Delegate object that receives spawn protocol messages as objects on object layers are being created. */
@property (nonatomic, weak) id<KTObjectLayerSpawnProtocol> objectSpawnDelegate;

/** The TMX file to load respectively that was loaded. */
@property (nonatomic, copy) NSString* tmxFile;

/** Draw the objects (rectangles, polylines and polygones) just as they are drawn in Tiled. Mainly for debugging purposes, or if it is
 vital for the user to see the lines. However this flag enables objects on all layers, to toggle drawObjects for individual layers
 set the property on KTObjectLayerViewController. */
@property (nonatomic) BOOL drawObjects;
/** Draw the bounding boxes of polygon/polyline objects. */
@property (nonatomic) BOOL drawPolyObjectBoundingBoxes;

/** Initialize tilemap viewcontroller with TMX file. */
+(id) tilemapControllerWithTMXFile:(NSString*)tmxFile;
/** Initialize tilemap viewcontroller with TMX file. */
-(id) initWithTMXFile:(NSString*)tmxFile;

/** Returns the view controller for the tile or object layer with the given name. */
-(id) tilemapLayerViewControllerByName:(NSString*)layerName;

/** Scrolls to the coordinate (in points) instantly. */
-(void) scrollToPosition:(CGPoint)position;
/** Scrolls to a tile coordinate instantly. */
-(void) scrollToTileCoordinate:(CGPoint)tileCoord;
/** Scrolls by a certain distance (in points) instantly. */
-(void) scrollByPointOffset:(CGPoint)pointOffset;
/** Scrolls by a certain distance (in tile coordinates) instantly. */
-(void) scrollByTileOffset:(CGPoint)tileOffset;

/** Scrolls to the coordinate (in points) with a given duration (in seconds). */
-(void) scrollToPosition:(CGPoint)position duration:(float)duration;
/** Scrolls to a tile coordinate with the given duration (in seconds). */
-(void) scrollToTileCoordinate:(CGPoint)tileCoord duration:(float)duration;
/** Scrolls to the coordinate (in points) with a given speed (in points per frame). */
-(void) scrollToPosition:(CGPoint)position speed:(float)speed;
/** Scrolls to a tile coordinate with the given speed (in points per frame). */
-(void) scrollToTileCoordinate:(CGPoint)tileCoord speed:(float)speed;

/** Scrolls by a certain distance (in points) with the given duration (in seconds). */
-(void) scrollByPointOffset:(CGPoint)pointOffset duration:(float)duration;
/** Scrolls by a certain distance (in tile coordinates) with the given duration (in seconds). */
-(void) scrollByTileOffset:(CGPoint)tileOffset duration:(float)duration;
/** Scrolls by a certain distance (in points) with a given speed (in points per frame). */
-(void) scrollByPointOffset:(CGPoint)pointOffset speed:(float)speed;
/** Scrolls by a certain distance (in tile coordinates) with a given speed (in points per frame). */
-(void) scrollByTileOffset:(CGPoint)tileOffset speed:(float)speed;

@end
