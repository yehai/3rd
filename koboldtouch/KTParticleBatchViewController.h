//
//  KTParticleBatchViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class CCParticleBatchNode;
@class CCTexture2D;

/** Batch draw view controller for particle emitters. Allows only particle emitters using the same texture as child,
 and generally only allows view controllers as subcontrollers whose rootNode is of CCParticleSystemQuad class. */
@interface KTParticleBatchViewController : KTViewController
{
@protected
@private
}

/** Returns the rootNode cast to CCSpriteBatchNode. */
@property (nonatomic, readonly) CCParticleBatchNode* batchNode;

/** The (non-suffixed) image file name for the texture used by this sprite batch node. */
@property (nonatomic, copy) NSString* imageFile;
/** The texture used by this sprite batch node. */
@property (nonatomic, weak) CCTexture2D* texture;

/** Creates a sprite batch view controller with an image file. */
+(id) particleBatchControllerWithImageFile:(NSString*)imageFile;
/** Creates a sprite batch view controller with a texture. */
+(id) particleBatchControllerWithTexture:(CCTexture2D*)texture;

/** Creates a sprite batch view controller with a image file. */
-(id) initWithImageFile:(NSString*)imageFile;
/** Creates a sprite batch view controller with a texture. */
-(id) initWithTexture:(CCTexture2D*)texture;

@end
