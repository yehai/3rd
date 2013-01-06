//
//  KTColorGradientViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTColorGradientViewController.h"

#import "CCDirector.h"
#import "CCLayer.h"

@implementation KTColorGradient
-(id) init
{
	self = [super init];
	if (self)
	{
		_solidColor = ccc4(255, 255, 255, 255);
		_startColor = ccc4(255, 255, 255, 255);
		_endColor = ccc4(0, 0, 0, 255);
		_direction = CGPointMake(0.0f, -1.0f);
		CGSize winSize = [CCDirector sharedDirector].winSize;
		_frame = CGRectMake(0, 0, winSize.width, winSize.height);
		_colorGradientType = KTColorGradientTypeSolid;
	}
	return self;
}
-(void) setSolidColor:(ccColor4B)solidColor
{
	_solidColor = solidColor;
	_colorGradientType = KTColorGradientTypeSolid;
}
-(void) setStartColor:(ccColor4B)startColor
{
	_startColor = startColor;
	_colorGradientType = KTColorGradientTypeGradient;
}
-(void) setEndColor:(ccColor4B)endColor
{
	_endColor = endColor;
	_colorGradientType = KTColorGradientTypeGradient;
}
-(void) setDirection:(CGPoint)direction
{
	_direction = direction;
	_colorGradientType = KTColorGradientTypeGradient;
}
@end


@implementation KTColorGradientViewController

+(id) colorGradientControllerWithColorGradient:(KTColorGradient*)colorGradient
{
	return [[self alloc] initWithColorGradient:colorGradient];
}

-(id) initWithColorGradient:(KTColorGradient*)colorGradient
{
	self = [super init];
	if (self)
	{
		_colorGradient = colorGradient;
	}
	return self;
}

-(void) loadView
{
	CCLayerColor* layerColor = nil;
	
	if (_colorGradient.colorGradientType == KTColorGradientTypeSolid)
	{
		layerColor = [CCLayerColor layerWithColor:_colorGradient.solidColor];
	}
	else if (_colorGradient.colorGradientType == KTColorGradientTypeGradient)
	{
		layerColor = [CCLayerGradient layerWithColor:_colorGradient.startColor
											fadingTo:_colorGradient.endColor
										 alongVector:_colorGradient.direction];
	}
	else
	{
		[NSException raise:@"invalid colorgradient type" format:@"invalid colorgradient type: %i", _colorGradient.colorGradientType];
	}

	[layerColor changeWidth:_colorGradient.frame.size.width
					 height:_colorGradient.frame.size.height];
	layerColor.position = _colorGradient.frame.origin;
	self.rootNode = layerColor;
}

@end
