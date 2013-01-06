//
//  KTMultiTouchController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTController.h"
#import "KTMultiTouchProtocol.h"
#import "KTMultiTouchDelegateWrapper.h"
#import "ccMoreMacros.h"

#import "CCGLView.h"

@class CCDirector;
@class KTMultiTouchDelegateWrapper;

#if KK_PLATFORM_IOS
typedef UIEvent KTEvent;
typedef UITouch KTTouch;
#elif KK_PLATFORM_MAC
typedef NSEvent KTEvent;
typedef NSTouch KTTouch;
#endif


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
/** If a touch delegate sets this property to YES, the touch will not be forwarded to other delegates. Defaults to NO. */
@property (nonatomic) BOOL swallowTouch;

// internal
-(void) reset;
-(BOOL) isValid;
-(void) updateWithEvent:(KTEvent*)event touch:(KTTouch*)touch;
@end

/** Touch event that contains all information about a multitouch event. */
@interface KTMultiTouchEvent : NSObject
{
	@private
	NSMutableArray* _touchEvents;
}
/** A set of KTTouchEvent objects representing each touch. */
@property (nonatomic) NSArray* touchEvents;
/** If a touch delegate sets this property to YES, the touches will not be forwarded to other delegates. Defaults to NO. */
@property (nonatomic) BOOL swallowTouches;

// internal
-(void) reset;
-(void) updateWithTouches:(NSSet*)touches event:(KTEvent*)event;
@end


// internal use only
@protocol KTTouchDelegate
#if KK_PLATFORM_IOS
<NSObject, CCTouchDelegate>
#elif KK_PLATFORM_MAC
<NSObject>
// TODO ...
#endif
@end

/** Multi-Touch controller forwards touch events to registered controllers. Currently supports only iOS, but can be extended to support Mac touch events as well. */
@interface KTMultiTouchController : KTController <KTTouchDelegate>
{
@protected
@private
	__weak CCDirector* _director;
	__weak CCGLView* _glView;
	KTMultiTouchEvent* _multiTouchEvent;
	NSMutableArray* _delegateWrappers;
	NSMutableArray* _delegateWrappersToAdd;
	NSMutableArray* _delegateWrappersToRemove;
	BOOL _currentlyProcessingEvent;
}

/** If YES, multi touch events will be reported. If NO, only a single touch event will be reported. Forwarded to the property of the same name
 on cocos2d's OpenGL view. Defaults to NO. */
@property (nonatomic) BOOL multipleTouchEnabled;

/** Whether touch events will be sent or not. If set to NO, no touch events will be generated. Defaults to YES. */
@property (nonatomic) BOOL enabled;

/** Add a delegate (usually a controller) that should receive touch events. */
-(void) addDelegate:(id<KTMultiTouchProtocol>)delegate;
/** Remove a touch delegate. Does nothing if delegate hasn't been added before. */
-(void) removeDelegate:(id<KTMultiTouchProtocol>)delegate;

@end
