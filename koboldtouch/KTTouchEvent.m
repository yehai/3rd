//
//  KTTouchEvent.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 17.01.13.
//
//

#import "KTTouchEvent.h"
#import "KTMultiTouchEvent.h"

static CGPoint kInvalidTouchLocation = {-1, -1};

@implementation KTTouchEvent

-(void) reset
{
	_event = nil;
	_touch = nil;
	_locationInGLView = kInvalidTouchLocation;
	_previousLocationInGLView = kInvalidTouchLocation;
	_swallowTouch = NO;
}

-(BOOL) isValid
{
	return (_event != nil);
}

-(void) updateWithEvent:(KTEvent*)event touch:(KTTouch*)touch
{
	_event = event;
	_touch = touch;
	
	CCDirector* director = [CCDirector sharedDirector];
	CCGLView* glView = (CCGLView*)director.view;
#if KK_PLATFORM_IOS
	_locationInGLView = [director convertToGL:[touch locationInView:glView]];
	_previousLocationInGLView = [director convertToGL:[touch previousLocationInView:glView]];
#elif KK_PLATFORM_MAC
	_locationInGLView = [glView convertPoint:[event locationInWindow] fromView:nil];
	_previousLocationInGLView = _locationInGLView;
#endif
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ locationInGLView: %.1f,%.1f, previousLocationInGLView: %.1f,%.1f, swallowTouch: %u - event: %p - touch: %@",
			[super description], _locationInGLView.x, _locationInGLView.y, _previousLocationInGLView.x, _previousLocationInGLView.y, _swallowTouch, _event, _touch];
}

@end
