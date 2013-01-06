//
//  KTMultiTouchController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTMultiTouchController.h"
#import "KTMultiTouchDelegateWrapper.h"

#import "CCDirector.h"
#import "CCDirectorIOS.h"
#import "CCDirectorMac.h"
#import "CCGLView.h"
#import "CCTouchDispatcher.h"


const int kMaxMultiTouchCount = 5;
static CGPoint kInvalidTouchLocation;

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
#if KK_PLATFORM_IOS
	CCDirector* director = [CCDirector sharedDirector];
	CCGLView* glView = (CCGLView*)director.view;
	_locationInGLView = [director convertToGL:[touch locationInView:glView]];
	_previousLocationInGLView = [director convertToGL:[touch previousLocationInView:glView]];
#elif KK_PLATFORM_MAC
	// TODO...
#endif
}
-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ locationInGLView: %.1f,%.1f, previousLocationInGLView: %.1f,%.1f, swallowTouch: %u - event: %p - touch: %@",
			[super description], _locationInGLView.x, _locationInGLView.y, _previousLocationInGLView.x, _previousLocationInGLView.y, _swallowTouch, _event, _touch];
}
@end

@implementation KTMultiTouchEvent
-(id) init
{
	self = [super init];
	if (self)
	{
		kInvalidTouchLocation = CGPointMake(-1, -1);
		_touchEvents = [NSMutableArray arrayWithCapacity:kMaxMultiTouchCount];
		
		for (int i = 0; i < kMaxMultiTouchCount; i++)
		{
			KTTouchEvent* touchEvent = [[KTTouchEvent alloc] init];
			[_touchEvents addObject:touchEvent];
		}
	}
	return self;
}
-(void) reset
{
	_swallowTouches = NO;
	
	for (KTTouchEvent* touchEvent in _touchEvents)
	{
		[touchEvent reset];
	}
}

-(void) updateWithTouches:(NSSet*)touches event:(KTEvent*)event
{
	[self reset];
	
#if KK_PLATFORM_IOS
	NSUInteger i = 0;
	for (KTTouch* touch in touches)
	{
		KTTouchEvent* touchEvent = [_touchEvents objectAtIndex:i++];
		[touchEvent updateWithEvent:event touch:touch];
	}
#elif KK_PLATFORM_MAC
	// TODO ...
#endif
}
-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ swallowTouches: %u", [super description], _swallowTouches];
}
@end


@implementation KTMultiTouchController
@dynamic multipleTouchEnabled;

#pragma mark Controller Callbacks

-(id) init
{
	self = [super init];
	if (self)
	{
		_director = [CCDirector sharedDirector];
		_glView = (CCGLView*)_director.view;
		NSAssert(_glView, @"glView is nil");
		
		_multiTouchEvent = [[KTMultiTouchEvent alloc] init];
		_delegateWrappers = [NSMutableArray array];
		_delegateWrappersToAdd = [NSMutableArray array];
		_delegateWrappersToRemove = [NSMutableArray array];
		
		self.enabled = YES;
	}
	return self;
}

-(void) unload
{
	_multiTouchEvent = nil;
	_delegateWrappers = nil;
	_delegateWrappersToAdd = nil;
	_delegateWrappersToRemove = nil;
}

#pragma mark properties

-(void) setMultipleTouchEnabled:(BOOL)multipleTouchEnabled
{
#if KK_PLATFORM_IOS
	_glView.multipleTouchEnabled = multipleTouchEnabled;
#endif
}
-(BOOL) multipleTouchEnabled
{
#if KK_PLATFORM_IOS
	return _glView.multipleTouchEnabled;
#endif
	return NO;
}

-(void) setEnabled:(BOOL)enabled
{
	if (_enabled != enabled)
	{
		_enabled = enabled;
		
#if KK_PLATFORM_IOS
		if (_enabled)
		{
			_glView.touchDelegate = self;
		}
		else
		{
			_glView.touchDelegate = nil;
		}
#endif
	}
}

#pragma mark delegates

-(void) addDelegate:(id<KTMultiTouchProtocol>)delegate
{
	KTMultiTouchDelegateWrapper* wrapper = [[KTMultiTouchDelegateWrapper alloc] initWithDelegate:delegate
																			multiTouchController:self];
	if (_currentlyProcessingEvent)
	{
		[_delegateWrappersToAdd addObject:wrapper];
	}
	else
	{
		[_delegateWrappers addObject:wrapper];
	}
}

-(void) removeDelegate:(id<KTMultiTouchProtocol>)delegate
{
	for (KTMultiTouchDelegateWrapper* wrapper in _delegateWrappers)
	{
		if (wrapper.delegate == delegate)
		{
			if (_currentlyProcessingEvent)
			{
				[_delegateWrappersToRemove addObject:wrapper];
			}
			else
			{
				[_delegateWrappers removeObject:wrapper];
			}
			break;
		}
	}
}


#pragma mark touch events

#if KK_PLATFORM_IOS
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_delegateWrappers.count > 0)
	{
		[_multiTouchEvent updateWithTouches:touches event:event];

		_currentlyProcessingEvent = YES;
		for (KTMultiTouchDelegateWrapper* delegateWrapper in _delegateWrappers)
		{
			[delegateWrapper sendTouchesBeganEvent:_multiTouchEvent];
		}
		_currentlyProcessingEvent = NO;
	}

#if KK_PLATFORM_IOS
	// be nice to cocos2d and allow CCTouchDispatcher to run (mainly for CCMenu)
	[((CCDirectorIOS*)_director).touchDispatcher touchesBegan:touches withEvent:event];
#endif
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_delegateWrappers.count > 0)
	{
		[_multiTouchEvent updateWithTouches:touches event:event];

		_currentlyProcessingEvent = YES;
		for (KTMultiTouchDelegateWrapper* delegateWrapper in _delegateWrappers)
		{
			[delegateWrapper sendTouchesMovedEvent:_multiTouchEvent];
		}
		_currentlyProcessingEvent = NO;
	}

#if KK_PLATFORM_IOS
	// be nice to cocos2d and allow CCTouchDispatcher to run (mainly for CCMenu)
	[((CCDirectorIOS*)_director).touchDispatcher touchesMoved:touches withEvent:event];
#endif
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_delegateWrappers.count > 0)
	{
		[_multiTouchEvent updateWithTouches:touches event:event];

		_currentlyProcessingEvent = YES;
		for (KTMultiTouchDelegateWrapper* delegateWrapper in _delegateWrappers)
		{
			[delegateWrapper sendTouchesEndedEvent:_multiTouchEvent];
		}
		_currentlyProcessingEvent = NO;
	}

#if KK_PLATFORM_IOS
	// be nice to cocos2d and allow CCTouchDispatcher to run (mainly for CCMenu)
	[((CCDirectorIOS*)_director).touchDispatcher touchesEnded:touches withEvent:event];
#endif
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_delegateWrappers.count > 0)
	{
		[_multiTouchEvent updateWithTouches:touches event:event];

		_currentlyProcessingEvent = YES;
		for (KTMultiTouchDelegateWrapper* delegateWrapper in _delegateWrappers)
		{
			[delegateWrapper sendTouchesCancelledEvent:_multiTouchEvent];
		}
		_currentlyProcessingEvent = NO;
	}

#if KK_PLATFORM_IOS
	// be nice to cocos2d and allow CCTouchDispatcher to run (mainly for CCMenu)
	[((CCDirectorIOS*)_director).touchDispatcher touchesCancelled:touches withEvent:event];
#endif
}

#elif KK_PLATFORM_MAC

// TODO...

#endif

#pragma mark Step

-(void) beforeStep:(KTStepInfo *)stepInfo
{
	if (_delegateWrappersToAdd.count > 0 && _currentlyProcessingEvent == NO)
	{
		for (KTMultiTouchDelegateWrapper* wrapper in _delegateWrappersToAdd)
		{
			[_delegateWrappers addObject:wrapper];
		}
		[_delegateWrappersToAdd removeAllObjects];
	}

	if (_delegateWrappersToRemove.count > 0 && _currentlyProcessingEvent == NO)
	{
		for (KTMultiTouchDelegateWrapper* wrapper in _delegateWrappersToRemove)
		{
			[_delegateWrappers removeObject:wrapper];
		}
		[_delegateWrappersToRemove removeAllObjects];
	}
}


@end
