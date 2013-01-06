//
//  KTMotionController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTController.h"
#import "KTMotionProtocol.h"

#if KK_PLATFORM_IOS
#import <CoreMotion/CoreMotion.h>
typedef CMAcceleration KTAcceleration;
#elif KK_PLATFORM_MAC
typedef struct {
	double x;
	double y;
	double z;
} KTAcceleration;
typedef NSObject CMAccelerometerData;
#endif


/** Contains acceleration values in CMAcceleration structs. The raw values are as reported by the accelerometer. 
 The smoothAcceleration values
 
  */
@interface KTAccelerometerData : NSObject
/** Filtering factor determines how much of the previously filtered values are used to create smoothAcceleration
 and instantAcceleration. Default value is 0.1, range between 0.0 and 1.0.
 
 A filteringFactor of 0.1 means that only 10% of the new raw acceleration values are used to update the smoothAcceleration
 and instantAccleration properties.
 */
@property (nonatomic) double filteringFactor;
/** Raw acceleration values as reported by accelerometer. */
@property (nonatomic) KTAcceleration rawAcceleration;
/** Smoothed (low-pass filter) values where sudden changes in acceleration are reduced for a smoother (less sudden) change
 in acceleration values. Typically used by accelerometer controlled games since raw acceleration is too "jittery" and "jumpy". 
 
 Implementation details:
 http://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/MotionEvents/MotionEvents.html#//apple_ref/doc/uid/TP40009541-CH4-SW11
 */
@property (nonatomic) KTAcceleration smoothAcceleration;
/** Instant acceleration (high-pass filter) isolates the change in motion by reducing the constant effect of gravity. Use this if you want to detect
 sudden changes in motion, like hitting or shaking the device.
 
 Implementation details:
 http://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/MotionEvents/MotionEvents.html#//apple_ref/doc/uid/TP40009541-CH4-SW13
 */
@property (nonatomic) KTAcceleration instantAcceleration;
@end


/** Processes motion events and forwards them to KTMotionProtocol delegates. Disabled by default. Does not do anything on Mac OS X. */
@interface KTMotionController : KTController
{
@protected
@private
#if KK_PLATFORM_IOS
	CMMotionManager* _motionManager;
#endif
	KTAccelerometerData* _accelerometerData;
	NSMutableArray* _delegateWrappers;
	NSMutableArray* _delegateWrappersToAdd;
	NSMutableArray* _delegateWrappersToRemove;
	BOOL _currentlyProcessingEvent;
}

/** Whether motion events will be sent or not. If set to NO, no motion events will be generated. 
 Defaults to NO to conserve energy and processing power while not needed. You should do the same whenever you don't need motion data updates. */
@property (nonatomic) BOOL enabled;


/** Add a delegate (usually a controller) that should receive motion events. */
-(void) addDelegate:(id<KTMotionProtocol>)delegate;
/** Remove a motion event delegate. Does nothing if delegate hasn't been added before. */
-(void) removeDelegate:(id<KTMotionProtocol>)delegate;


@end
