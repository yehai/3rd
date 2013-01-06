//
//  KTViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 22.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTController.h"

@class CCNode;
@class KTEntityModel;


/** typedef of the LoadViewBlock */
typedef void (^LoadViewBlock)(CCNode* rootNode);

/** A view controller manages the cocos2d node hierarchy. */
@interface KTViewController : KTController
{
@protected
	BOOL _isSceneViewController;
@private
}

/** The root node (view) of this view controller. It is the node in the cocos2d node hierarchy that this view controller manages.
 The view controller should only modify the rootNode and the child nodes of rootNode, but never modify the node's parent. */
@property (nonatomic, weak) CCNode* rootNode;

/** The entity model associated with this view controller. 
 This is automatically set if the model property is set to a model of class KTEntityModel. */
@property (nonatomic, readonly, weak) KTEntityModel* entityModel;

/** The loadViewBlock receives the root node as parameter. You can assign this block to add additional views to the rootNode
 without having to subclass the view controller. The block is executed after loadView. */
@property (nonatomic, copy) LoadViewBlock loadViewBlock;

/** Runs shortly before the view and subviews are loaded. Use this to register controllers and other
 oncy-only setup code that must occur before the view begins loading. */
-(void) viewWillLoad;
/** Runs after the view and all subviews have been loaded. Use this to run once-only setup code. */
-(void) viewDidLoad;
/** Runs before the view is removed from the hierarchy, when a scene transition begins.
 Use this to run once-only cleanup code. This is the method you want to override in order to nil (release) all strong references to cocos2d node objects.
 At this point, all controller and node references are still valid. */
-(void) viewWillDisappear;
/** Runs after the view is removed from the hierarchy, when the scene transition ended. Use this to run once-only cleanup code.
 At this point, all node and controller references are already nil, including references to game controller, scene view controller and
 parent controller. */
-(void) viewDidDisappear;

/** Creates the rootNode and runs the loadViewBlock. In subclasses you can override loadView to create a different rootNode,
 but you *must* call [super loadView] (and do so after assigning to rootNode) to allow the loadViewBlock to run. */
-(void) loadView;

/** Adds a view (CCNode object) to the controller's rootNode. Called when a KTViewController instance is added to another view controller.
 The default implementation calls Cocos2D's addChild: method if rootNode is not nil. */
-(void) addSubView:(CCNode*)viewNode;

/** This applies the common entity model properties (position, rotation, scale) to the view node. It's best to call this
 method in the afterStep: method.
 */
-(void) updateViewFromEntityModel;

// internal use only
-(void) internal_runLoadViewBlock;
-(void) internal_pauseActions:(BOOL)pause;
@property (nonatomic, readonly) BOOL isSceneViewController;
@end
