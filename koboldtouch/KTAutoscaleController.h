//
//  KTAutoscaleController.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTController.h"
#import "kobold2d.h"

/** Defines the properties that can be autoscaled. */
typedef enum
{
	KTAutoscalePropertyNone = 1 << 0, /**< don't scale any properties (disables autoscaling) */
	KTAutoscalePropertyPosition = 1 << 1, /**< scale position property */
	//KTAutoscalePropertyScaleX = 1 << 2, /**< scale scaleX property */
	//KTAutoscalePropertyScaleY = 1 << 3, /**< scale scaleY property */
} KTAutoscaleProperty;

/** Allows certain node properties (mostly just position) to be scaled automatically based on display resolution (in points, not pixels).
 
 Use by first setting the designResolution property to the resolution you designed your views in. This should be the smallest supported resolution of your app and defaults to 480x320. 
 Then call  autoscaleNode:scaledProperties: for every node which you want to autoscale based on display resolution. Design your game to use coordinates
 relative to the design resolution. Upscaling is handled automatically if you run the app on a device with a higher resolution.
 
 How it works: before a node gets drawn on the screen, its scaled properties are changed according to the difference between designResolution and the current display resolution in points.
 Just after rendering, the properties are reset back to their original setting. That way your game objects can be programmed to a specific resolution (ie 480x320) but do the exact same thing
 in any resolution (586x320, 1024x768) or even in different orientations (320x480, 320x586, 768x1024).
 
 Caution #1: A node whose position is scaled will take the same time moving from A to B even if A and B may be much farther apart on iPad. That means as screen size increases the movement
 of the node will seem faster because it travels a larger distance over the same time frame. This is regardless of whether you're using CCMove* actions or if you update the position
 property manually every update.
 
 Caution #2: Touch detection on nodes whose position is autoscaled requires the use of the convertToDesignResolution: method to change a touch location (which is in screen coordinates)
 to the corresponding location in design coordinates. The node may appear to be at coordinates 900x700 on iPad, but it was designed to be at around 422x292 and that's the coordinate space
 the autoscaled node continues to use even on larger screen devices. Therefore the touches on iPad will not "hit" the node unless you convert (scale down) the touch location to the design resolution.
 */
@interface KTAutoscaleController : KTController
{
@protected
@private
}

@property (nonatomic) CGSize designResolution;
@property (nonatomic, readonly) CGSize currentResolution;
@property (nonatomic, readonly) CGSize scaleFactor;

/** Enables or disables autoscaling for a specific node. To disable autoscaling for a node that has autoscaling enabled at a later time simply 
 specify KTAutoscalePropertyNone (0) as propertyFlags. */
-(void) autoscaleNode:(CCNode*)node scaledProperties:(KTAutoscaleProperty)propertyFlags;

/** Converts a point in screen coordinates to the corresponding location in designResolution. This is necessary for touch input because autoscaled nodes will be positioned
 at their original designResolution (ie 480x320) and only rendered at their upscaled position. The physical screen coordinates however may be much larger (ie 1024x768) thus
 touch locations need to be downscaled to the designResolution before you can perform a hit test on an autoscaled node. */
-(CGPoint) convertToDesignResolution:(CGPoint)pointInScreenCoordinates;

/** Same as instance method but can be used without requiring a reference to the KTAutoscaleController object. 
 
 Usage: CGPoint downscaledPoint = [KTAutoscaleController convertToDesignResolution:touchLocation]; */
+(CGPoint) convertToDesignResolution:(CGPoint)pointInScreenCoordinates;

@end
