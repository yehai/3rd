//
//  KTTilemapLayerModel.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapLayerModel.h"


@implementation KTTilemapLayerModel

#pragma mark Load/Unload


-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel tileLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		_tilemapModel = tilemapModel;
		_tileLayer = tileLayer;
	}
	return self;
}

/* 
// Executed when model is first initialized. Is NOT executed when model is loaded from archive!
-(void) initWithDefaults
{
}
*/

/* 
// Executed after model has been initialized or loaded from archive. Use this for common setup code.
-(void) load
{
}
*/

/* 
// Unload private resources of the model. 
// The model's unload method is executed before the controller's unload method.
-(void) unload
{
}
*/

/*
// Runs just before the sceneViewController is replaced with a new one. 
// The self.sceneViewController property still points to the previous sceneViewController.
// Mainly used by game controllers to perform cleanup when the scene is about to change.
-(void) sceneWillChange
{
}
*/

/*
// Runs just after the previous sceneViewController has been replaced with a new one.
// The self.sceneViewController property already points to the new sceneViewController.
-(void) sceneDidChange
{
}
*/

#pragma mark Step

// Executed before step and afterStep
-(void) beforeStep:(KTStepInfo *)stepInfo
{
	_scrollCenter.x += 4;
	_scrollCenter.y += 3;
}

/*
// Executed every frame, unless self.nextStep is set greater than stepInfo.currentStep
-(void) step:(KTStepInfo *)stepInfo
{
	// example: this pauses step methods for 200 steps, effentively creating a 200-step interval
	self.nextStep = stepInfo.currentStep + 200;
}
*/

/*
// Executed after the step method
-(void) afterStep:(KTStepInfo *)stepInfo
{
}
*/

@end
