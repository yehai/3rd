//
//  KTGameStepInfo.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTStepInfo.h"

@implementation KTStepInfo

-(NSString*) description
{
	return [NSString stringWithFormat:@"<KTStepInfo - currentStep: %u - deltaTime: %.3f>", (unsigned int)_currentStep, _deltaTime];
}

-(void) internal_setStepDeltaTime:(float)deltaTime currentStep:(NSUInteger)currentStep
{
	_deltaTime = deltaTime;
	_currentStep = currentStep;
}

@end
