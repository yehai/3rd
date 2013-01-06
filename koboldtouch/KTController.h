//
//  KTController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 24.09.12.
//
//

#import "ccTypes.h"
#import "KTModelControllerBase.h"
#import "KTMultiTouchProtocol.h"
#import "KTMotionProtocol.h"

@class KTModel;
@class KTGameController;
@class KTSceneViewController;

/** typedef of the CreateModelBlock */
typedef KTModel* (^CreateModelBlock)(void);

static const NSInteger kInvalidControllerTag = -1;

/** Base class for controller objects. Controllers have a model and an array of subControllers. */
@interface KTController : KTModelControllerBase <KTMultiTouchProtocol, KTMotionProtocol>
{
	@protected

	@private
	NSMutableArray* _subControllers;
}

/** The model associated with this controller. Each controller has exactly one model. The model can be nil. */
@property (nonatomic, readonly) KTModel* model;
/** The sub controllers, if any. */
@property (nonatomic, readonly) NSArray* subControllers;
/** Returns the controller's parent controller. The game controller's parentController is always nil. */
@property (nonatomic, readonly, weak) KTController* parentController;
/** Returns the currently presented scene view controller instance. */
@property (nonatomic, readonly, weak) KTSceneViewController* sceneViewController;
/** Returns the game controller instance. */
@property (nonatomic, readonly, weak) KTGameController* gameController;
/** A block that creates and returns a KTModel object. Use this to create and assign a model to a controller
 without having to subclass the controller class. The createModelBlock is executed after initWithDefaults,
 and only when the model is not loaded from an archive. */
@property (nonatomic, copy) CreateModelBlock createModelBlock;

/** Identifies this controller. Can be used in subControllerByName to access that specific subcontroller. */
@property (nonatomic, copy) NSString* name;
/** Identifies this controller. Can be used in subControllerByTag to access that specific subcontroller. */
@property (nonatomic) NSInteger tag;

/** Creates and returns a new controller object without a model. */
+(id) controller;

/** Adds a sub controller to this controller. */
-(void) addSubController:(KTController*)controller;

/** Replaces an existing sub controller with a different controller. If the supposedly existing controller is not
 in the subControllers array, or existingController is nil, the new controller will simply be added. */
//-(void) replaceSubController:(KTController*)existingController withController:(KTController*)newController;

/** Removes a controller from the subControllers array. If the controller not in the subControllers array, this method has no effect. */
-(void) removeSubController:(KTController*)controller;

/** Removes all sub controllers. */
-(void) removeAllSubControllers;

/** Removes the controller from its parent controller. The controller should deallocate unless strongly referenced elsewhere. */
-(void) remove;

/** Returns a sub controller by its class. Returns the first sub controller whose class matches the controllerClass parameter. */
-(KTController*) subControllerByClass:(Class)controllerClass;
/** Returns a sub controller by its name. Returns the first sub controller whose name property matches the name parameter. */
-(KTController*) subControllerByName:(NSString*)controllerName;
/** Returns a sub controller by its tag. Returns the first sub controller whose tag property matches the tag parameter. */
-(KTController*) subControllerByTag:(NSInteger)controllerTag;

/** Runs just before the sceneViewController is replaced with a new one. The self.sceneViewController property still points to the previous sceneViewController. */
-(void) sceneWillChange;
/** Runs just after the previous sceneViewController has been replaced with a new one.
 The self.sceneViewController property already points to the new sceneViewController. */
-(void) sceneDidChange;

// internal use only
-(void) internal_setModel:(KTModel*)model;
-(void) internal_addSubController:(KTController*)controller insertAsFirstController:(BOOL)insertAsFirstController;
-(void) internal_setGameController:(KTGameController*)gameController;
-(void) internal_setSceneViewController:(KTSceneViewController*)sceneViewController;
-(void) internal_setParentController:(KTController*)parentController;
-(void) internal_setControllerReferencesOnController:(KTController*)controller
									parentController:(KTController*)parentController
								 sceneViewController:(KTSceneViewController*)sceneViewController
									  gameController:(KTGameController*)gameController;
@end
