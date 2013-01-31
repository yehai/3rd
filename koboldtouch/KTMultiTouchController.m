//
//  KTMultiTouchController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTMultiTouchController.h"
#import "KTMultiTouchDelegateWrapper.h"
#import "KTMultiTouchEvent.h"
#import "KTTouchEvent.h"

#import "CCDirector.h"
#import "CCDirectorIOS.h"
#import "CCDirectorMac.h"
#import "CCGLView.h"
#import "CCTouchDispatcher.h"


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
#elif KK_PLATFORM_MAC
		if (_emulateTouchesWithMouse)
		{
			if (_enabled)
			{
				[[CCDirector sharedDirector].eventDispatcher addMouseDelegate:self priority:INT_MIN];
			}
			else
			{
				[[CCDirector sharedDirector].eventDispatcher removeMouseDelegate:self];
			}
		}
#endif
	}
}

-(void) setEmulateTouchesWithMouse:(BOOL)emulateTouchesWithMouse
{
	if (_emulateTouchesWithMouse != emulateTouchesWithMouse)
	{
		_emulateTouchesWithMouse = emulateTouchesWithMouse;
		// turn yourself off and on again (or vice versa)
		self.enabled = !self.enabled;
		self.enabled = !self.enabled;
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

-(void) touchesBegan:(NSSet *)touches withEvent:(KTEvent *)event
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
-(void) touchesMoved:(NSSet *)touches withEvent:(KTEvent *)event
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
-(void) touchesEnded:(NSSet *)touches withEvent:(KTEvent *)event
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
-(void) touchesCancelled:(NSSet *)touches withEvent:(KTEvent *)event
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

#if KK_PLATFORM_MAC

-(BOOL) ccMouseDown:(NSEvent*)event
{
	if (_emulateTouchesWithMouse)
	{
		[self touchesBegan:nil withEvent:event];
	}
	return NO;
}
-(BOOL) ccRightMouseDown:(NSEvent*)event
{
	return [self ccMouseDown:event];
}
-(BOOL) ccOtherMouseDown:(NSEvent*)event
{
	return [self ccMouseDown:event];
}

-(BOOL) ccMouseDragged:(NSEvent*)event
{
	if (_emulateTouchesWithMouse)
	{
		[self touchesMoved:nil withEvent:event];
	}
	return NO;
}
-(BOOL) ccRightMouseDragged:(NSEvent*)event
{
	return [self ccMouseDragged:event];
}
-(BOOL) ccOtherMouseDragged:(NSEvent*)event
{
	return [self ccMouseDragged:event];
}

-(BOOL) ccMouseUp:(NSEvent*)event
{
	if (_emulateTouchesWithMouse)
	{
		[self touchesEnded:nil withEvent:event];
	}
	return NO;
}
-(BOOL) ccRightMouseUp:(NSEvent*)event
{
	return [self ccMouseUp:event];
}
-(BOOL) ccOtherMouseUp:(NSEvent*)event
{
	return [self ccMouseUp:event];
}

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
