//
//  KTAutoscaleController.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTAutoscaleController.h"
#import "KTAutoscaleNodeProxy.h"
#import "KTTypes.h"
#import "CCNode+Autoscale.h"

static CGSize _scaleFactor = {1.0f, 1.0f};

@implementation KTAutoscaleController

@dynamic scaleFactor;
-(CGSize) scaleFactor
{
	return _scaleFactor;
}

-(void) updateCurrentResolutionAndScaleFactor
{
	_currentResolution = [CCDirector sharedDirector].winSize;
	_scaleFactor.width = _currentResolution.width / _designResolution.width;
	_scaleFactor.height = _currentResolution.height / _designResolution.height;
}

-(void) setDesignResolution:(CGSize)designResolution
{
	if (CGSizeEqualToSize(_designResolution, designResolution) == NO)
	{
		_designResolution = designResolution;
		[self updateCurrentResolutionAndScaleFactor];
	}
}

+(CGPoint) convertToDesignResolution:(CGPoint)pointInScreenCoordinates
{
	CGPoint convertedPoint = pointInScreenCoordinates;
	convertedPoint.x /= _scaleFactor.width;
	convertedPoint.y /= _scaleFactor.height;
	return convertedPoint;
}

-(CGPoint) convertToDesignResolution:(CGPoint)pointInScreenCoordinates
{
	return [KTAutoscaleController convertToDesignResolution:pointInScreenCoordinates];
}

#pragma mark Controller Callbacks

// Executed after controller is first allocated and initialized.
// Add subcontrollers, set createModelBlock and loadViewBlock here.
-(void) initWithDefaults
{
	self.designResolution = CGSizeMake(480.0f, 320.0f);
}

-(void) autoscaleNode:(CCNode*)node scaledProperties:(KTAutoscaleProperty)propertyFlags
{
	if (propertyFlags == KTAutoscalePropertyNone)
	{
		// disable autoscaling of node by removing its autoscale proxy object
		[node.autoscaleNodeProxy cleanup];
	}
	else
	{
		// enable node autoscaling by adding the autoscale node proxy as userObject
		KTAutoscaleNodeProxy* autoscaleProxy = node.autoscaleNodeProxy;
		if (autoscaleProxy == nil)
		{
			autoscaleProxy = [[KTAutoscaleNodeProxy alloc] initWithNode:node autoscaleController:self];
		}
		
		autoscaleProxy.scaledProperties = propertyFlags;
	}
}

-(void) orientationChanged:(NSNotification*)notification
{
	[self updateCurrentResolutionAndScaleFactor];
}

// At this point the model is already initialized. Update the controller based on model.
-(void) load
{
#if KK_PLATFORM_IOS
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:KTDirectorDidReshapeProjectionNotification object:nil];
#endif
}

// Unload controller (private) resources here. The view and model are unloaded automatically.
// The controller's unload method is executed after the model's unload method.
-(void) unload
{
#if KK_PLATFORM_IOS
	[[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}

@end
