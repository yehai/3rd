//
//  KTAutoscaleNodeProxy.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//
//

#import "KTAutoscaleNodeProxy.h"
#import "KTAutoscaleController.h"

@implementation KTAutoscaleNodeProxy

-(id) initWithNode:(CCNode*)node autoscaleController:(KTAutoscaleController*)autoscaleController
{
	self = [super init];
	if (self)
	{
		node.userObject = self;
		self.node = node;
		self.autoscaleController = autoscaleController;
	}
	return self;
}

-(void) cleanup
{
	_node.userObject = nil;
	self.node = nil;
	self.autoscaleController = nil;
}

@dynamic scaledProperties;
-(void) setScaledProperties:(KTAutoscaleProperty)propertyFlags
{
	_autoscalePosition = (propertyFlags & KTAutoscalePropertyPosition);
	//_autoscaleScaleX = (propertyFlags & KTAutoscalePropertyScaleX);
	//_autoscaleScaleY = (propertyFlags & KTAutoscalePropertyScaleY);
}
-(KTAutoscaleProperty) scaledProperties
{
	return (KTAutoscaleProperty)((_autoscalePosition ? KTAutoscalePropertyPosition : 0) /*|
								 (_autoscaleScaleX ? KTAutoscalePropertyScaleX : 0) |
								 (_autoscaleScaleY ? KTAutoscalePropertyScaleY : 0)*/);
}

-(CGPoint) scaledPosition:(CGPoint)position
{
	if (_autoscalePosition)
	{
		position.x *= _autoscaleController.scaleFactor.width;
		position.y *= _autoscaleController.scaleFactor.height;
	}
	return position;
}

/*
-(float) scaledScaleX:(float)scaleX
{
	if (_autoscaleScaleX)
	{
		scaleX *= _autoscaleController.scaleFactor.width;
	}
	return scaleX;
}

-(float) scaledScaleY:(float)scaleY
{
	if (_autoscaleScaleY)
	{
		scaleY *= _autoscaleController.scaleFactor.height;
	}
	return scaleY;
}
 */

@end
