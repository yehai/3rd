//
//  KTColorGradientViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KoboldTouch.h"

#import "ccTypes.h"

typedef enum
{
	KTColorGradientTypeSolid,
	KTColorGradientTypeGradient,
} KTColorGradientType;

/** Defines the properties of the KTColorGradientViewController. */
@interface KTColorGradient : NSObject
/** The solid fill color. Defaults to white. */
@property (nonatomic) ccColor4B solidColor;
/** The start color of the gradient. Defaults to white. */
@property (nonatomic) ccColor4B startColor;
/** The end color of the gradient. Defaults to black. */
@property (nonatomic) ccColor4B endColor;
/** The direction vector for the gradient. Defaults to 0,-1 (from top to bottom). */
@property (nonatomic) CGPoint direction;
/** The position and size of the colored rectangle. Defaults to fill the window (screen). */
@property (nonatomic) CGRect frame;
// internal use only
@property (nonatomic, readonly) KTColorGradientType colorGradientType;
@end

/** View controller that fills the screen (by default) or any rectangle with either a solid color or a color gradient.
 Wraps cocos2d's CCLayerColor and CCLayerGradient classes. */
@interface KTColorGradientViewController : KTViewController
{
@protected
@private
	KTColorGradient* _colorGradient;
}

/** Creates a KTColorGradientViewController from the properties in the KTColorGradient object. */
+(id) colorGradientControllerWithColorGradient:(KTColorGradient*)colorGradient;
/** Creates a KTColorGradientViewController from the properties in the KTColorGradient object. */
-(id) initWithColorGradient:(KTColorGradient*)colorGradient;

@end
