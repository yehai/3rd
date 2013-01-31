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
		_node = node;
		_node.userObject = self;
		self.autoscaleController = autoscaleController;
	}
	return self;
}

-(void) cleanup
{
	_node.userObject = nil;
	_node = nil;
	self.autoscaleController = nil;
}

-(CGPoint) scaledPosition:(CGPoint)position
{
	if (_scaledProperties & KTAutoscalePropertyPosition)
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
