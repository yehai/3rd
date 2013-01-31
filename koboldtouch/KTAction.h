//
//  KTAction.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 16.01.13.
//
//

#import <Foundation/Foundation.h>
#import "KTEntityModel.h"

@class KTStepInfo;

/** Actions act on (influence, change properties, etc.) a specific model. The defining property of actions is that whatever
 they're supposed to do eventually ends, which will remove the action from the model automatically. For example moving the
 model to a specific location - upon arrival at the destination the action removes itself from the model and its memory is released.
 
 Note: KoboldTouch actions are quite similar to CCAction* classes. The most notable difference is that they act on KTEntityModel
 objects, never on views directly, to conform to the MVC programming model. 
 
 Caution: It is illegal to re-run the same action on the same or a different model object while the action is running. You can
 however re-run the action after it has been stopped.
 */
@interface KTAction : NSObject
{
	@protected
	__weak KTEntityModel* _model;
	float _elapsedTime;
	float _duration;
	@private
}

/** The KTEntityModel object this action is associated with. Will be nil if the action isn't running. */
@property (nonatomic, weak, readonly) KTEntityModel* model;
/** Check if the action is still running. If it is not running, it is safe to re-run the action on the same or a different model. */
@property (nonatomic, readonly) BOOL isRunning;
/** How long the action will run before it stops automatically (in seconds). Can be modified by subclasses to extend or shorten the duration as needed. */
@property (nonatomic, readonly) float duration;
/** How much time has elapsed since the action started running (in seconds). Can be modified by subclasses to extend or shorten the duration as needed. */
@property (nonatomic, readonly) float elapsedTime;

/** Resets the action. Override this in subclasses to perform any steps necessary to initially and repeatedly set up the action.
 
 Tip: it is not necessary to call [super reset].
 
 Caution: Keep in mind that KTAction are supposed to be reusable, so a reset has to reset all settings back to original or default values, 
 even where it may not be necessary initially (ie resetting all values being updated while the action is running back to 0 or defaults). */
-(void) reset;

/** Updates the action with a delta time. Override this in subclasses to update the action's state and the model.
 
 Tip: it is not necessary to call [super updateWithDeltaTime:deltaTime].
*/
-(void) updateWithDeltaTime:(float)deltaTime;


/// Internal use
-(id) initWithDuration:(float)duration;
-(void) startWithModel:(KTEntityModel*)model;
-(void) update:(KTStepInfo*)stepInfo;
-(void) stop;
@end
