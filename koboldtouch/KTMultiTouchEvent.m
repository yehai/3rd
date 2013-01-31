//
//  KTMultiTouchEvent.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 17.01.13.
//
//

#import "KTMultiTouchEvent.h"
#import "KTTouchEvent.h"

const int kMaxMultiTouchCount = 5;

@implementation KTMultiTouchEvent

-(id) init
{
	self = [super init];
	if (self)
	{
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
	KTTouchEvent* touchEvent = [_touchEvents objectAtIndex:0];
	[touchEvent updateWithEvent:event touch:nil];
#endif
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ swallowTouches: %u", [super description], _swallowTouches];
}

@end
