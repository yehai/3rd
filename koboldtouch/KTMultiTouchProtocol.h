//
//  KTMultiTouchProtocol.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//
//

#ifndef Kobold2D_Libraries_KTMultiTouchProtocol_h
#define Kobold2D_Libraries_KTMultiTouchProtocol_h

/** @file KTTMultiTouchProtocol.h */

@class KTMultiTouchEvent;
@class KTTouchEvent;

/** Defines the messages a delegate can implement to handle (multi) touch events. 
 Simply implement one or more of the KTTouchDelegate protocol messages and register with KTMultiTouchController.
 
 To work with multiple touches iterate over multiTouchEvent.touchEvents. You can also get all touches from uiEvent:
 NSSet* touches = [multiTouchEvent.uiEvent allTouches];
 */
@protocol KTMultiTouchProtocol <NSObject>
@optional
/** One or more touches began. The KTMultiTouchEvent contains an array with all active touches. */
-(void) touchesBeganWithEvent:(KTMultiTouchEvent*)multiTouchEvent;
/** One or more touches moved. The KTMultiTouchEvent contains an array with all active touches. */
-(void) touchesMovedWithEvent:(KTMultiTouchEvent*)multiTouchEvent;
/** One or more touches ended. The KTMultiTouchEvent contains an array with all active touches. */
-(void) touchesEndedWithEvent:(KTMultiTouchEvent*)multiTouchEvent;
/** One or more touches were cancelled. The KTMultiTouchEvent contains an array with all active touches. */
-(void) touchesCancelledWithEvent:(KTMultiTouchEvent*)multiTouchEvent;

/** A single touch began. Returns the KTTouchEvent for just that touch. */
-(void) touchBeganWithEvent:(KTTouchEvent*)touchEvent;
/** A single touch moved. Returns the KTTouchEvent for just that touch. */
-(void) touchMovedWithEvent:(KTTouchEvent*)touchEvent;
/** A single touch ended. Returns the KTTouchEvent for just that touch. */
-(void) touchEndedWithEvent:(KTTouchEvent*)touchEvent;
/** A single touch was cancelled. Returns the KTTouchEvent for just that touch. */
-(void) touchCancelledWithEvent:(KTTouchEvent*)touchEvent;
@end

#endif
