//
//  KTMotionProtocol.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//
//

#ifndef Kobold2D_Libraries_KTMotionProtocol_h
#define Kobold2D_Libraries_KTMotionProtocol_h

/** @file KTTMotionProtocol.h */

@class KTAccelerometerData;

/** Defines messages for motion events. */
@protocol KTMotionProtocol <NSObject>
@optional
/** Implement this method to receive accelerometer events. You must first enable the scene view controller's motion
 controller and add your class as delegate to receive the event. */
-(void) accelerometerDidAccelerate:(KTAccelerometerData*)accelerometerData;
@end

#endif
