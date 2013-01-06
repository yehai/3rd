//
//  KTSpriteBatchViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 26.09.12.
//
//

#import "KTSpriteBatchViewController.h"
#import "KTMacros.h"

#import "CCSprite.h"
#import "CCSpriteBatchNode.h"
#import "CCTexture2D.h"
#import "CCTextureCache.h"

@implementation KTSpriteBatchViewController

@dynamic batchNode;

-(CCSpriteBatchNode*) batchNode
{
	return (CCSpriteBatchNode*)self.rootNode;
}

+(id) spriteBatchControllerWithImageFile:(NSString*)imageFile
{
	return [[self alloc] initWithImageFile:imageFile];
}
+(id) spriteBatchControllerWithTexture:(CCTexture2D*)texture
{
	return [[self alloc] initWithTexture:texture];
}

-(id) initWithImageFile:(NSString*)imageFile
{
	self = [super init];
	if (self)
	{
		self.imageFile = imageFile;
	}
	return self;
}

-(id) initWithTexture:(CCTexture2D*)texture
{
	self = [super init];
	if (self)
	{
		self.texture = texture;
	}
	return self;
}

-(void) loadView
{
	NSAssert1(_imageFile || _texture, @"sprite batch view controller (%@): both imageFile and texture are nil!", self);

	if (_imageFile)
	{
		KTASSERT_FILEEXISTS(_imageFile);
		self.texture = [[CCTextureCache sharedTextureCache] addImage:_imageFile];
	}

	self.rootNode = [CCSpriteBatchNode batchNodeWithTexture:_texture];
}

-(void) addSubView:(CCNode *)viewNode
{
	NSAssert2([viewNode isKindOfClass:[CCSprite class]],
			  @"subviews of sprite batch view controller (%@) must be CCSprite nodes! Tried to add subview of class: %@",
			  self, NSStringFromClass([viewNode class]));
	NSAssert3(((CCSprite*)viewNode).texture == self.batchNode.texture,
			  @"sprites added to spritebatch view controller (%@) *must* use the batch node's texture (%@)! Tried to add sprite with texture: %@",
			  self, self.batchNode.texture, ((CCSprite*)viewNode).texture);
	
	[super addSubView:viewNode];
}

@end
