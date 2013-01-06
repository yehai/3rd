//
//  KTSpriteViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#import "KTSpriteViewController.h"
#import "KTMacros.h"

#import "CCSprite.h"
#import "CCSpriteFrameCache.h"
#import "CCTextureCache.h"

@implementation KTSpriteViewController

@dynamic sprite;

-(CCSprite*) sprite
{
	return (CCSprite*)self.rootNode;
}

+(id) spriteControllerWithImageFile:(NSString*)imageFile
{
	return [[self alloc] initWithImageFile:imageFile];
}
+(id) spriteControllerWithSpriteFrameName:(NSString*)spriteFrameName
{
	return [[self alloc] initWithSpriteFrameName:spriteFrameName];
}
+(id) spriteControllerWithTexture:(CCTexture2D*)texture
{
	return [[self alloc] initWithTexture:texture];
}
+(id) spriteControllerWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
	return [[self alloc] initWithSpriteFrame:spriteFrame];
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
-(id) initWithSpriteFrameName:(NSString*)spriteFrameName
{
	self = [super init];
	if (self)
	{
		self.spriteFrameName = spriteFrameName;
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
-(id) initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
	self = [super init];
	if (self)
	{
		self.spriteFrame = spriteFrame;
	}
	return self;
}

-(void) loadView
{
	NSAssert1(_imageFile || _texture || _spriteFrame || _spriteFrameName, @"sprite view controller (%@): imageFile, texture, spriteFrame and spriteFrameName are all nil!", self);
	
	if (_spriteFrameName)
	{
		self.rootNode = [CCSprite spriteWithSpriteFrameName:_spriteFrameName];
	}
	else if (_imageFile)
	{
		KTASSERT_FILEEXISTS(_imageFile);
		self.rootNode = [CCSprite spriteWithFile:_imageFile];
	}
	else if (_texture)
	{
		self.rootNode = [CCSprite spriteWithTexture:_texture];
	}
	else if (_spriteFrame)
	{
		self.rootNode = [CCSprite spriteWithSpriteFrame:_spriteFrame];
	}
}

@end
