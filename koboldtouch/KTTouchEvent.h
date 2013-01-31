//
//  KTTouchEvent.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 17.01.13.
//
//

#import <Foundation/Foundation.h>
#import "KTTypes.h"

/** Touch event that contains all information about a touch event. */
@interface KTTouchEvent : NSObject
/** The UIEvent/NSEvent for the touch. Use this to access allTouches. */
@property (nonatomic, weak) KTEvent* event;
/** The event's UITouch/NSTouch object. Use this to access touch phase, timestape, tapCount and whether the touch is being handled by a gesture recognizer. */
@property (nonatomic, weak) KTTouch* touch;
/** The touch location in GL (cocos2d) coordinates. */
@property (nonatomic, readonly) CGPoint locationInGLView;
/** The previous touch location in GL (cocos2d) coordinates. */
@property (nonatomic, readonly) CGPoint previousLocationInGLView;
/** If a touch delegate sets this property to YES, this particular touch will not be forwarded to other delegates. Defaults to NO. */
@property (nonatomic) BOOL swallowTouch;

// internal
-(void) reset;
-(BOOL) isValid;
-(void) updateWithEvent:(KTEvent*)event touch:(KTTouch*)touch;
@end