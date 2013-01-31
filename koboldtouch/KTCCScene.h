//
//  KTCCScene.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 03.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class KTSceneViewController;

/** Internal use only. Customized CCScene class for KoboldTouch. Mainly exchanging events between KT and cocos2d,
 such as onEnter, onExit, cleanup, etc. */
@interface KTCCScene : CCScene
/** Reference to the scene view controller owning this KTCCScene object. */
@property (nonatomic) KTSceneViewController* sceneViewController;
@end
