//
//  KTCCScene.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 03.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTCCScene.h"
#import "KTSceneViewController.h"
#import "KTGameController.h"

#import "CCScene.h"
#import "CCDirector.h"
#import "CCNode+Autoscale.h"


@implementation KTCCScene

/*
 -(void) addChild:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag
 {
 NSLog(@"scene add child: %@", node);
 [super addChild:node z:z tag:tag];
 }
 */

-(void) onEnter
{
	[super onEnter];
	BOOL pause = self.sceneViewController.gameController.pauseScenesDuringTransition;
	self.sceneViewController.paused = pause;
	[self.sceneViewController internal_pauseActions:pause];
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	self.sceneViewController.paused = NO;
	[self.sceneViewController internal_pauseActions:NO];
}

-(void) onExitTransitionDidStart
{
	[super onExitTransitionDidStart];
	BOOL pause = self.sceneViewController.gameController.pauseScenesDuringTransition;
	self.sceneViewController.paused = pause;
	[self.sceneViewController internal_pauseActions:pause];
}

-(void) onExit
{
	[super onExit];
	self.sceneViewController.paused = NO;
	[self.sceneViewController internal_pauseActions:NO];
}

-(void) cleanup
{
	// inform about cleanup, which for scenes only occurs when the scene has been replaced by another
	[self.sceneViewController internal_viewDidDisappear];
	
	[super cleanup];
}

-(void) dealloc
{
	NSLog(@"dealloc: %@", self);
}

@end
