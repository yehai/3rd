//
//  KTMultiTouchDelegateWrapper.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//
//

#import "KTMultiTouchDelegateWrapper.h"
#import "KTMultiTouchController.h"
#import "KTMultiTouchEvent.h"
#import "KTTouchEvent.h"

@implementation KTMultiTouchDelegateWrapper

-(id) initWithDelegate:(id<KTMultiTouchProtocol>)delegate multiTouchController:(KTMultiTouchController*)multiTouchController
{
	self = [super init];
	if (self)
	{
		_multiTouchController = multiTouchController;
		self.delegate = delegate;
		[self setImplementsFlags];
	}
	return self;
}

-(void) setImplementsFlags
{
	_implementsTouchesBegan = [_delegate respondsToSelector:@selector(touchesBeganWithEvent:)];
	_implementsTouchesMoved = [_delegate respondsToSelector:@selector(touchesMovedWithEvent:)];
	_implementsTouchesEnded = [_delegate respondsToSelector:@selector(touchesEndedWithEvent:)];
	_implementsTouchesCancelled = [_delegate respondsToSelector:@selector(touchesCancelledWithEvent:)];
	_implementsTouchBegan = [_delegate respondsToSelector:@selector(touchBeganWithEvent:)];
	_implementsTouchMoved = [_delegate respondsToSelector:@selector(touchMovedWithEvent:)];
	_implementsTouchEnded = [_delegate respondsToSelector:@selector(touchEndedWithEvent:)];
	_implementsTouchCancelled = [_delegate respondsToSelector:@selector(touchCancelledWithEvent:)];
}

#pragma mark dispatch events
-(void) sendTouchesBeganEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	if (_delegate == nil)
	{
		return;
	}

	if (_implementsTouchesBegan)
	{
		[_delegate touchesBeganWithEvent:multiTouchEvent];
		if (multiTouchEvent.swallowTouches)
		{
			return;
		}
	}
	
	if (_implementsTouchBegan)
	{
		for (KTTouchEvent* touchEvent in multiTouchEvent.touchEvents)
		{
			if ([touchEvent isValid] == NO || touchEvent.swallowTouch)
			{
				break;
			}
			
			[_delegate touchBeganWithEvent:touchEvent];
		}
	}
}

-(void) sendTouchesMovedEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	if (_delegate)
	{
		if (_implementsTouchesMoved)
		{
			[_delegate touchesMovedWithEvent:multiTouchEvent];
			if (multiTouchEvent.swallowTouches)
			{
				return;
			}
		}
		
		if (_implementsTouchMoved)
		{
			for (KTTouchEvent* touchEvent in multiTouchEvent.touchEvents)
			{
				if ([touchEvent isValid] == NO || touchEvent.swallowTouch)
				{
					break;
				}
				
				[_delegate touchMovedWithEvent:touchEvent];
			}
		}
	}
}

-(void) sendTouchesEndedEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	if (_delegate)
	{
		if (_implementsTouchesEnded)
		{
			[_delegate touchesEndedWithEvent:multiTouchEvent];
			if (multiTouchEvent.swallowTouches)
			{
				return;
			}
		}
		
		if (_implementsTouchEnded)
		{
			for (KTTouchEvent* touchEvent in multiTouchEvent.touchEvents)
			{
				if ([touchEvent isValid] == NO || touchEvent.swallowTouch)
				{
					break;
				}
				
				[_delegate touchEndedWithEvent:touchEvent];
			}
		}
	}
}

-(void) sendTouchesCancelledEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	if (_delegate)
	{
		if (_implementsTouchesCancelled)
		{
			[_delegate touchesCancelledWithEvent:multiTouchEvent];
			if (multiTouchEvent.swallowTouches)
			{
				return;
			}
		}
		
		if (_implementsTouchCancelled)
		{
			for (KTTouchEvent* touchEvent in multiTouchEvent.touchEvents)
			{
				if ([touchEvent isValid] == NO || touchEvent.swallowTouch)
				{
					break;
				}
				
				[_delegate touchCancelledWithEvent:touchEvent];
			}
		}
	}
}

@end
