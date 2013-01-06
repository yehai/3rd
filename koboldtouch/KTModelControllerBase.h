//
//  KTModelControllerBase.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import <Foundation/Foundation.h>

@class KTStepInfo;

/** Defines the step methods which, when implemented in a KTController or KTModel subclass, will be called every step.
 By default a step equals a frame.
 
 If you have a controller with a model, the Model's step methods (beforeStep, step, afterStep) run just before the corresponding Controller step methods.
 */
@protocol KTModelControllerProtocol <NSObject>

/** When paused, object will not execute any of the step methods. For controllers the paused flag will also pause
 the controller's subControllers. So in order to pause your game layer, but not the pause menu layer, simply pause
 your game layer's view controller.
 
 Tip: pausing the KTGameController will cause cocos2d to unlink from the CADisplayLink (same as [CCDirector stopAnimation]).
 */
@property (nonatomic) BOOL paused;

/** By setting nextStep to a value greater than currentStep you can temporarily disable the step methods,
 until currentStep is greater or equal nextStep. For example, this will prevent the step methods from being
 executed for 120 steps:
 self.nextStep = stepInfo.currentStep + 120;
 
 Tip: you can easily create a fixed update interval for your step method by simply setting nextStep to currentStep plus
 a fixed amount every time the step method is called.
 */
@property (nonatomic) NSUInteger nextStep;

@optional
/** Called before the step: method, when implemented. Use this to execute code that is required to be complete during step. */
-(void) beforeStep:(KTStepInfo*)stepInfo;
/** Called when implemented. Step is practically the same as an update method scheduled with scheduleUpdate. Use this to update your models and views. */
-(void) step:(KTStepInfo*)stepInfo;
/** Called after the step: method, when implemented. Use this to execute code that must be run after the step method. */
-(void) afterStep:(KTStepInfo*)stepInfo;

@end


/** Abstract base class for both KTModel and KTController classes. Implements the KTModelControllerProtocol that is used by both models and controllers. */
@interface KTModelControllerBase : NSObject <KTModelControllerProtocol>
{
	@protected
	
	@private
	// set if class implements selector (for quicker equality check instead of using respondsToSelector)
	SEL _beforeStepSelector;
	SEL _stepSelector;
	SEL _afterStepSelector;
}

@property (nonatomic) BOOL paused;
@property (nonatomic) NSUInteger nextStep;

/** Override to initialize with default values. On models it is not executed when model is initialized from archive.
 Note: self.controller, self.model and self.xxxxController properties are all nil at this point.
 Use load method to fully initialize model/controller and (on model) to run code that is common to both initializing from archive and initializing with defaults. */
-(void) initWithDefaults;

/** Use this to run once-only setup code. 
 On models, load runs after initWithDefaults or initWithArchive to setup the model.
 On controllers, load runs after the model's load method ran. Use it to update the controller's state from model data.
 Note: self.controller and self.model are set to the respective controller and model at this point, 
 and the controller's self.gameController, parentController and sceneViewController properties are also set at this point. */
-(void) load;

/** Use this to run once-only cleanup code. Unload runs after the viewDidDisappear message was sent. */
-(void) unload;

// for internal use
-(BOOL) internal_implementsStepSelector:(SEL)stepSelector;

@end
