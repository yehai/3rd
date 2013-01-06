//
//  KTMenuViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTViewController.h"
#import "KTTextMenu.h"


/** A view controller that wraps CCMenu and provides a simple interface for creating common menus and single buttons. */
@interface KTMenuViewController : KTViewController
{
	@private
	KTTextMenu* _textMenu;
}

/** Creates a menu with text items from a KTTextMenu object. */
+(id) menuControllerWithTextMenu:(KTTextMenu*)textMenu;
/** Creates a menu with text items from a KTTextMenu object. */
-(id) initWithTextMenu:(KTTextMenu*)textMenu;

@end
