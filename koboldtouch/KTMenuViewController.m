//
//  KTMenuViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTMenuViewController.h"
#import "KTSceneViewController.h"
#import "kobold2d.h"

@implementation KTMenuViewController

+(id) menuControllerWithTextMenu:(KTTextMenu*)textMenu
{
	return [[self alloc] initWithTextMenu:textMenu];
}

-(id) initWithTextMenu:(KTTextMenu*)textMenu
{
	self = [super init];
	if (self)
	{
		_textMenu = textMenu;
	}
	return self;
}

-(void) loadView
{
	if (_textMenu)
	{
		[CCMenuItemFont setFontName:_textMenu.fontName];
		[CCMenuItemFont setFontSize:_textMenu.fontSize];
		
		NSMutableArray* items = [NSMutableArray arrayWithCapacity:_textMenu.menuItems.count];
		for (KTTextMenuItem* item in _textMenu.menuItems)
		{
			[items addObject:[CCMenuItemFont itemWithString:item.text block:item.executionBlock]];
			// nil the block after use to prevent a memory leak
			item.executionBlock = nil;
		}
		
		CCMenu* menu = [CCMenu menuWithArray:items];
		if (_textMenu.alignHorizontally)
		{
			[menu alignItemsHorizontallyWithPadding:_textMenu.padding];
		}
		else
		{
			[menu alignItemsVerticallyWithPadding:_textMenu.padding];
		}
		
		self.rootNode = menu;
	}
}

@end
