//
//  KTObjectLayerViewController.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"
#import "KTObjectLayerSpawnProtocol.h"

@class KTDrawingPrimitivesViewController;
@class KTTilemapLayer;
@class KTTilemapModel;

/** View controller for a tilemap object layer. */
@interface KTObjectLayerViewController : KTViewController
{
@protected
@private
	KTDrawingPrimitivesViewController* _drawingPrimitivesVC;
	BOOL _spawnDelegateImplementsDidCreateObject;
}

/** Delegate object that receives spawn protocol messages as objects on object layers are being created. */
@property (nonatomic, weak) id<KTObjectLayerSpawnProtocol> objectSpawnDelegate;

/** If enabled, will render the polygon objects (rectangle, polyline, polygon) as drawing primitives on the layer. Useful for debugging purposes. */
@property (nonatomic) BOOL drawObjects;
/** Draw the bounding boxes of polygon/polyline objects. */
@property (nonatomic) BOOL drawPolyObjectBoundingBoxes;

/** Returns the tilemap object layer. */
@property (nonatomic, readonly) KTTilemapLayer* objectLayer;

/** Create a tilemap object layer view controller with model and tilemap layer. */
-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel objectLayer:(KTTilemapLayer*)objectLayer;

@end
