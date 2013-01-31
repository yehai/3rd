//
//  KTMultiTouchController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTController.h"
#import "KTMultiTouchProtocol.h"
#import "KTMultiTouchEvent.h"

#import "ccMoreMacros.h"
#import "CCGLView.h"

@class CCDirector;
@class KTMultiTouchDelegateWrapper;


// internal use only
@protocol KTTouchDelegate
#if KK_PLATFORM_IOS
<NSObject, CCTouchDelegate>
#elif KK_PLATFORM_MAC
<NSObject, CCMouseEventDelegate>
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

/** Only for Mac OS X: creates touch events when you click a mouse button. */
@property (nonatomic) BOOL emulateTouchesWithMouse;

/** Whether touch events will be sent or not. If set to NO, no touch events will be generated. Defaults to YES. */
@property (nonatomic) BOOL enabled;

/** Add a delegate (usually a controller) that should receive touch events. */
-(void) addDelegate:(id<KTMultiTouchProtocol>)delegate;
/** Remove a touch delegate. Does nothing if delegate hasn't been added before. */
-(void) removeDelegate:(id<KTMultiTouchProtocol>)delegate;

@end
