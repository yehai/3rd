//
//  KTPhysicsDebugViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTPhysicsDebugViewController.h"

#import "KTPhysicsController.h"
#import "KTBox2DController.h"
#import "KTBox2DDebugViewController.h"

@implementation KTPhysicsDebugViewController

+(id) physicsDebugViewControllerWithPhysicsController:(KTPhysicsController*)physicsController
{
	if ([physicsController isKindOfClass:[KTBox2DController class]])
	{
		return [[KTBox2DDebugViewController alloc] initWithPhysicsController:(KTBox2DController*)physicsController];
	}
	return nil;
}

@end
