//
//  KTSpriteBatchViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 26.09.12.
//
//

#import "KTViewController.h"

@class CCTexture2D;
@class CCSpriteBatchNode;

/** A view controller whose rootNode is a CCSpriteBatchNode. */
@interface KTSpriteBatchViewController : KTViewController

/** Returns the rootNode cast to CCSpriteBatchNode. */
@property (nonatomic, readonly) CCSpriteBatchNode* batchNode;

/** The (non-suffixed) image file name for the texture used by this sprite batch node. */
@property (nonatomic, copy) NSString* imageFile;
/** The texture used by this sprite batch node. */
@property (nonatomic, weak) CCTexture2D* texture;

/** Creates a sprite batch view controller with an image file. */
+(id) spriteBatchControllerWithImageFile:(NSString*)imageFile;
/** Creates a sprite batch view controller with a texture. */
+(id) spriteBatchControllerWithTexture:(CCTexture2D*)texture;

/** Creates a sprite batch view controller with a image file. */
-(id) initWithImageFile:(NSString*)imageFile;
/** Creates a sprite batch view controller with a texture. */
-(id) initWithTexture:(CCTexture2D*)texture;

@end
