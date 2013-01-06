//
//  KTSceneViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 22.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class KTGameController;
@class KTPhysicsController;
@class KTMultiTouchController;
@class KTMotionController;
@class KTSceneModel;

@class CCScene;

/** Specialized view controller that wraps a CCScene and manages the whole scene.
 
 Tip: pausing the scene view controller will also pause cocos2d, which means it will only render 4 frames per second
 to conserve CPU cycles.
 */
@interface KTSceneViewController : KTViewController
{
@protected
@private
	NSMutableDictionary* _subControllersByName;
}

/** Returns the rootNode cast to CCScene object. */
@property (nonatomic, readonly) CCScene* scene;

/** Returns the physics controller if a KTPhysicsController subclass was added as subcontroller. May be nil. */
@property (nonatomic, readonly, weak) KTPhysicsController* physicsController;
/** Returns the multitouch controller instance. */
@property (nonatomic, readonly, weak) KTMultiTouchController* multiTouchController;
/** Returns the motion controller instance. Always returns nil on Mac OS X. */
@property (nonatomic, readonly, weak) KTMotionController* motionController;

/** Create a sceneViewController with a model. */
+(id) sceneViewControllerWithSceneModel:(KTSceneModel*)sceneModel;
/** Create a sceneViewController with a model. */
-(id) initWithSceneModel:(KTSceneModel*)sceneModel;

/** Register a sub controller with a unique name. Other controllers can then access this controller by name. */
-(void) registerController:(KTController*)controller withName:(NSString*)name;
/** Remove a registered controller object. Does nothing if controller wasn't registered. */
-(void) removeRegisteredController:(KTController*)controller;
/** Remove a registered controller object by name. Does nothing if controller wasn't registered. */
-(void) removeRegisteredControllerByName:(NSString*)name;
/** Receive a previously registered controller by name. May return nil if there's no controller by that name.
 @warning: if you keep a strong reference to the returned controller, you **MUST** set the reference to nil in the
 viewWillDisappear method to avoid a retain cycle. It is recommended to declare that reference *weak* instead. */
-(id) registeredControllerByName:(NSString*)name;
/** Returns a registered controller by its class. 
 @warning: Returns the first controller object whose class matches. If there are multiple
 registered controllers of the same class there's no guarantee that you'll get the same one every time! */
-(id) registeredControllerByClass:(Class)controllerClass;

// internal use only, called by KTGameController when presenting scene, calls loadView method of view controllers
-(void) internal_viewWillDisappear;

@end
