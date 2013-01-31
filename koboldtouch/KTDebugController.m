//
//  KTDebugController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTDebugController.h"
#import "KTModel.h"
#import "KTViewController.h"
#import "CCNode.h"

#import <objc/runtime.h>

@implementation KTDebugController

-(NSString*) stringWithNumberOfTabs:(int)tabs
{
	return [@"" stringByPaddingToLength:tabs withString:@"\t" startingAtIndex:0];
}

-(void) dumpController:(KTController*)controller tabLevel:(int)tabLevel output:(NSMutableString*)output
{
	[output appendFormat:@"%i:%@ %@", (int)tabLevel, [self stringWithNumberOfTabs:tabLevel], NSStringFromClass([controller class])];
	if (controller.model)
	{
		[output appendFormat:@" (model: %@)", NSStringFromClass([controller.model class])];
	}
	if ([controller isKindOfClass:[KTViewController class]])
	{
		KTViewController* viewController = (KTViewController*)controller;
		[output appendFormat:@" (view: %@", NSStringFromClass([viewController.rootNode class])];
		if (viewController.rootNode.children.count > 0)
		{
			[output appendFormat:@" + %u children", (unsigned int)viewController.rootNode.children.count];
		}
		[output appendString:@")"];
	}
	[output appendString:@"\n"];
	
	tabLevel++;
	for (KTController* subController in controller.subControllers)
	{
		[self dumpController:subController tabLevel:tabLevel output:output];
	}
}

-(NSString*) objectGraphWithRootController:(KTController*)controller
{
	NSMutableString* output = [NSMutableString stringWithCapacity:1000];
	[output appendString:@"Dump of object graph:\n"];
	[output appendString:@"Level: Controller (Model, if any) (View + children, if any)\n"];
	[self dumpController:controller tabLevel:0 output:output];
	return output;
}

-(NSString*) objectGraph
{
	return [self objectGraphWithRootController:(KTController*)self.gameController];
}

-(size_t) sizeOfClassInstance:(Class)class
{
	return class_getInstanceSize(class);
}

-(void) logSizeOfClassInstance:(Class)class
{
	NSLog(@"Class %@ instance size is %lu bytes.", NSStringFromClass(class), class_getInstanceSize(class));
}

@end
