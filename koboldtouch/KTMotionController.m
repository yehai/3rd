//
//  KTMotionController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTMotionController.h"
#import "KTMotionDelegateWrapper.h"

#import "CCDirector.h"

@implementation KTAccelerometerData
-(id) init
{
	self = [super init];
	if (self)
	{
		_filteringFactor = 0.1;
	}
	return self;
}
-(void) updateWithAccelerometerData:(CMAccelerometerData*)accelerometerData
{
#if KK_PLATFORM_IOS
	_rawAcceleration.x = accelerometerData.acceleration.x;
	_rawAcceleration.y = accelerometerData.acceleration.y;
	_rawAcceleration.z = accelerometerData.acceleration.z;
#endif
	_smoothAcceleration.x = (_rawAcceleration.x * _filteringFactor) + (_smoothAcceleration.x * (1.0 - _filteringFactor));
	_smoothAcceleration.y = (_rawAcceleration.y * _filteringFactor) + (_smoothAcceleration.y * (1.0 - _filteringFactor));
	_smoothAcceleration.z = (_rawAcceleration.z * _filteringFactor) + (_smoothAcceleration.z * (1.0 - _filteringFactor));
	_instantAcceleration.x = _rawAcceleration.x - ((_rawAcceleration.x * _filteringFactor) + (_instantAcceleration.x * (1.0 - _filteringFactor)));
	_instantAcceleration.y = _rawAcceleration.y - ((_rawAcceleration.y * _filteringFactor) + (_instantAcceleration.y * (1.0 - _filteringFactor)));
	_instantAcceleration.z = _rawAcceleration.z - ((_rawAcceleration.z * _filteringFactor) + (_instantAcceleration.z * (1.0 - _filteringFactor)));
}
-(NSString*) description
{
	return [NSString stringWithFormat:@"%@ rawAcceleration: (%.3f,%.3f,%.3f) smoothAcceleration: (%.3f,%.3f,%.3f) instantAcceleration: (%.3f,%.3f,%.3f)",
			[super description], _rawAcceleration.x, _rawAcceleration.y, _rawAcceleration.z, _smoothAcceleration.x, _smoothAcceleration.y, _smoothAcceleration.z,
			_instantAcceleration.x, _instantAcceleration.y, _instantAcceleration.z];
}
@end


@implementation KTMotionController

-(id) init
{
	self = [super init];
	if (self)
	{
		_accelerometerData = [[KTAccelerometerData alloc] init];
		
#if KK_PLATFORM_IOS
		_motionManager = [[CMMotionManager alloc] init];
		_motionManager.accelerometerUpdateInterval = [CCDirector sharedDirector].animationInterval;
#endif
		
		_delegateWrappers = [NSMutableArray array];
		_delegateWrappersToAdd = [NSMutableArray array];
		_delegateWrappersToRemove = [NSMutableArray array];
		
		self.enabled = NO;
	}
	return self;
}

-(void) unload
{
	_accelerometerData = nil;
#if KK_PLATFORM_IOS
	_motionManager = nil;
#endif
	_delegateWrappers = nil;
	_delegateWrappersToAdd = nil;
	_delegateWrappersToRemove = nil;
}

-(void) setEnabled:(BOOL)enabled
{
	if (_enabled != enabled)
	{
		_enabled = enabled;
		
#if KK_PLATFORM_IOS
		if (_enabled)
		{
			[self startAccelerometer];
		}
		else
		{
			[self stopAccelerometer];
		}
#endif
	}
}

-(void) startAccelerometer
{
#if KK_PLATFORM_IOS
	[self stopAccelerometer];
	[_motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
										 withHandler:^(CMAccelerometerData* accelerometerData, NSError* error) {
											 [self accelerometerDidReceiveData:accelerometerData];
										 }];
#endif
}

-(void) stopAccelerometer
{
#if KK_PLATFORM_IOS
	[_motionManager stopAccelerometerUpdates];
#endif
}

-(void) accelerometerDidReceiveData:(CMAccelerometerData*)accelerometerData
{
	if (_delegateWrappers.count > 0)
	{
		[_accelerometerData updateWithAccelerometerData:accelerometerData];
		
		_currentlyProcessingEvent = YES;
		for (KTMotionDelegateWrapper* delegateWrapper in _delegateWrappers)
		{
			[delegateWrapper sendAccelerometerDidAccelerate:_accelerometerData];
		}
		_currentlyProcessingEvent = NO;
	}
}

#pragma mark delegates

-(void) addDelegate:(id<KTMotionProtocol>)delegate
{
	KTMotionDelegateWrapper* wrapper = [[KTMotionDelegateWrapper alloc] initWithDelegate:delegate
																		motionController:self];
	if (_currentlyProcessingEvent)
	{
		[_delegateWrappersToAdd addObject:wrapper];
	}
	else
	{
		[_delegateWrappers addObject:wrapper];
	}
}

-(void) removeDelegate:(id<KTMotionProtocol>)delegate
{
	for (KTMotionDelegateWrapper* wrapper in _delegateWrappers)
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

#pragma mark Step

-(void) beforeStep:(KTStepInfo *)stepInfo
{
	if (_delegateWrappersToAdd.count > 0 && _currentlyProcessingEvent == NO)
	{
		for (KTMotionDelegateWrapper* wrapper in _delegateWrappersToAdd)
		{
			[_delegateWrappers addObject:wrapper];
		}
		[_delegateWrappersToAdd removeAllObjects];
	}
	
	if (_delegateWrappersToRemove.count > 0 && _currentlyProcessingEvent == NO)
	{
		for (KTMotionDelegateWrapper* wrapper in _delegateWrappersToRemove)
		{
			[_delegateWrappers removeObject:wrapper];
		}
		[_delegateWrappersToRemove removeAllObjects];
	}
}

@end
