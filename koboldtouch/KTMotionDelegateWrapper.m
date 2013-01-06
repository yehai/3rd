//
//  KTMotionDelegateWrapper.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//
//

#import "KTMotionDelegateWrapper.h"

@implementation KTMotionDelegateWrapper

-(id) initWithDelegate:(id<KTMotionProtocol>)delegate motionController:(KTMotionController*)motionController
{
	self = [super init];
	if (self)
	{
		_motionController = motionController;
		self.delegate = delegate;
		[self setImplementsFlags];
	}
	return self;
}

-(void) setImplementsFlags
{
	_implementsDidAccelerate = [_delegate respondsToSelector:@selector(accelerometerDidAccelerate:)];
}

-(void) sendAccelerometerDidAccelerate:(KTAccelerometerData*)accelerometerData
{
	if (_implementsDidAccelerate)
	{
		[_delegate accelerometerDidAccelerate:accelerometerData];
	}
}

@end
