//
//  KTGameStepInfo.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTController.h"
#import "ccTypes.h"

/** Every step method receives this object as its only parameter. It contains most commonly used
 parameters needed during step processing, like deltaTime and currentStep. The KTStepInfo instance
 is owned by the KTGameController. It is purposefully readonly since the same object is passed to all
 step methods. */
@interface KTStepInfo : NSObject
/** Delta time of this step. This is the time that has passed since the previous step method was executed. */
@property (nonatomic, readonly) float deltaTime;
/** Current step counter. This is the total number of steps that were executed since the app started. */
@property (nonatomic, readonly) NSUInteger currentStep;


// internal: Used only by KTGameController to update current step's properties.
-(void) internal_setStepDeltaTime:(float)deltaTime currentStep:(NSUInteger)currentStep;
@end
