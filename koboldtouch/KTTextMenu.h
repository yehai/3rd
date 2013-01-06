//
//  KTTextMenu.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import <Foundation/Foundation.h>

/** typedef of the menu item's execution block. */
typedef void (^MenuItemExecutionBlock)(id sender);

/** A text menu item with text and an execution block that runs when the item is tapped. */
@interface KTTextMenuItem : NSObject
/** The text to display for this menu item. */
@property (nonatomic, copy) NSString* text;
/** The block that is run when this menu item is tapped/clicked by the user. The sender parameter will be set to the
 menu item's CCMenu node. */
@property (nonatomic, copy) MenuItemExecutionBlock executionBlock;

/** initialize a text menu item with an execution block */
+(id) itemWithText:(NSString*)text executionBlock:(MenuItemExecutionBlock)executionBlock;
@end

/** Used by KTMenuViewController. Stores all info needed to create a simple text-based menu. */
@interface KTTextMenu : NSObject
/** A list of KTTextMenuItem objects. */
@property (nonatomic) NSArray* menuItems;
/** The font to use for each menu item. Defaults to Arial. */
@property (nonatomic, copy) NSString* fontName;
/** The font size for each menu item. Defaults to 24. */
@property (nonatomic) float fontSize;
/** The amount of padding between menu items. Defaults to 0. */
@property (nonatomic) float padding;
/** Set if the menu items should be aligned horizontally. By default menu items are aligned vertically. */
@property (nonatomic) BOOL alignHorizontally;

/** Returns a new KTTextMenu object initialized with an array of KTTextMenuItem objects. */
+(id) menuWithTextMenuItems:(NSArray*)menuItems;
@end
