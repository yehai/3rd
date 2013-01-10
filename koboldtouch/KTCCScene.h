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

// customized scene class for KoboldTouch, mainly communicating back and forth between KT and cocos2d
@interface KTCCScene : CCScene
@property (nonatomic) KTSceneViewController* sceneViewController;
@end
