//
//  KTTextMenu.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTTextMenu.h"

@implementation KTTextMenuItem

+(id) itemWithText:(NSString*)text executionBlock:(MenuItemExecutionBlock)executionBlock
{
	return [[self alloc] initWithText:text executionBlock:executionBlock];
}

-(id) initWithText:(NSString*)text executionBlock:(MenuItemExecutionBlock)executionBlock
{
	self = [super init];
	if (self)
	{
		self.text = text;
		self.executionBlock = executionBlock;
	}
	return self;
}

@end

@implementation KTTextMenu

+(id) menuWithTextMenuItems:(NSArray*)menuItems
{
	return [[self alloc] initWithTextMenuItems:menuItems];
}

-(id) initWithTextMenuItems:(NSArray*)menuItems
{
	self = [super init];
	if (self)
	{
		self.menuItems = menuItems;
		_fontName = @"Arial";
		_fontSize = 24;
		_padding = 0;
	}
	return self;
}

-(void) dealloc
{
	NSLog(@"dealloc: %@", self);
}

@end
