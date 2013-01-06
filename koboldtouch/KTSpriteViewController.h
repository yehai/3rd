//
//  KTSpriteViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTViewController.h"

@class CCSprite;
@class CCSpriteFrame;
@class CCTexture2D;

/** A view controller whose rootNode is a CCSprite. */
@interface KTSpriteViewController : KTViewController

/** Returns the rootNode cast to a CCSprite object. */
@property (nonatomic, readonly) CCSprite* sprite;

/** The (non-suffixed) image file name for the texture used by this sprite. */
@property (nonatomic, copy) NSString* imageFile;
/** The (non-suffixed) sprite frame name used by this sprite. */
@property (nonatomic, copy) NSString* spriteFrameName;
/** The texture used by this sprite. */
@property (nonatomic, weak) CCTexture2D* texture;
/** The sprite frame used by this sprite. */
@property (nonatomic, weak) CCSpriteFrame* spriteFrame;

/** Creates a sprite view controller with an image file. */
+(id) spriteControllerWithImageFile:(NSString*)imageFile;
/** Creates a sprite view controller with a spriteframe name. */
+(id) spriteControllerWithSpriteFrameName:(NSString*)spriteFrameName;
/** Creates a sprite view controller with a texture. */
+(id) spriteControllerWithTexture:(CCTexture2D*)texture;
/** Creates a sprite view controller with a spriteframe. */
+(id) spriteControllerWithSpriteFrame:(CCSpriteFrame*)spriteFrame;

/** Creates a sprite view controller with an image file. */
-(id) initWithImageFile:(NSString*)imageFile;
/** Creates a sprite view controller with a spriteframe. */
-(id) initWithSpriteFrameName:(NSString*)spriteFrameName;
/** Creates a sprite view controller with a texture. */
-(id) initWithTexture:(CCTexture2D*)texture;
/** Creates a sprite view controller with a spriteframe. */
-(id) initWithSpriteFrame:(CCSpriteFrame*)spriteFrame;

@end
