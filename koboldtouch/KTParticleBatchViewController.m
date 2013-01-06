//
//  KTParticleBatchViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTParticleBatchViewController.h"
#import "KTMacros.h"

#import "CCTextureCache.h"
#import "CCParticleBatchNode.h"
#import "CCParticleSystemQuad.h"


@implementation KTParticleBatchViewController

@dynamic batchNode;

-(CCParticleBatchNode*) batchNode
{
	return (CCParticleBatchNode*)self.rootNode;
}

+(id) particleBatchControllerWithImageFile:(NSString*)imageFile
{
	return [[self alloc] initWithImageFile:imageFile];
}
+(id) particleBatchControllerWithTexture:(CCTexture2D*)texture
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
	NSAssert1(_imageFile || _texture, @"particle batch view controller (%@): both imageFile and texture are nil!", self);
	
	if (_imageFile)
	{
		KTASSERT_FILEEXISTS(_imageFile);
		self.texture = [[CCTextureCache sharedTextureCache] addImage:_imageFile];
	}
	
	self.rootNode = [CCParticleBatchNode batchNodeWithTexture:_texture];
}

-(void) addSubView:(CCNode *)viewNode
{
	NSAssert2([viewNode isKindOfClass:[CCParticleSystemQuad class]],
			  @"subviews of particle batch view controller (%@) must be CCParticleSystemQuad nodes! Tried to add subview of class: %@",
			  self, NSStringFromClass([viewNode class]));
	NSAssert3(((CCParticleSystemQuad*)viewNode).texture == self.batchNode.texture,
			  @"particle emitter added to particle batch view controller (%@) *must* use the batch node's texture (%@)! Tried to add sprite with texture: %@",
			  self, self.batchNode.texture, ((CCParticleSystemQuad*)viewNode).texture);
	
	[super addSubView:viewNode];
}

@end
