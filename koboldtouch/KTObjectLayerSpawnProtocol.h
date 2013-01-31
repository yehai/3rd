//
//  KTObjectLayerSpawnProtocol.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 19.01.13.
//
//

#import <Foundation/Foundation.h>

@class KTObjectLayerViewController;
@class KTTilemapObject;
@class KTDrawPolygon;
@class KTDrawPolyLine;

/** Protocol messages that can be implemented by delegates wanting to receive messages for each object created on an object layer.
 The delegate can then decide if or what type of (additional) view controllers etc. to create, or modify the created or about to be created object. */
@protocol KTObjectLayerSpawnProtocol <NSObject>

@optional
/** Informs delegate that the view controller is about to create an object. Return NO to prevent this object from being created. */
-(BOOL) objectLayerViewController:(KTObjectLayerViewController*)objectLayerVC willCreateObject:(KTTilemapObject*)object;

/** Informs the delegate that the view controller has created an object (rectangle, polyline, polygon or tile). Also passes in the drawing primitive polygon object
 used to display the object on the tilemap like Tiled does (mainly for debugging). */
-(void) objectLayerViewController:(KTObjectLayerViewController*)objectLayerVC didCreateObject:(KTTilemapObject*)object polygon:(KTDrawPolygon*)polygon;

@end
