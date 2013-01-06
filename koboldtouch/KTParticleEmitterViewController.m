//
//  KTParticleEmitterViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTParticleEmitterViewController.h"
#import "KTMacros.h"

#import "CCParticleSystemQuad.h"

@interface KTParticleEmitterViewController ()
// declare private methods here
@end


@implementation KTParticleEmitterViewController

+(id) particleEmitterControllerWithEmitterFile:(NSString*)emitterFile
{
	return [[self alloc] initWithEmitterFile:emitterFile];
}
-(id) initWithEmitterFile:(NSString*)emitterFile
{
	self = [super init];
	if (self)
	{
		self.emitterFile = emitterFile;
	}
	return self;
}

-(void) loadView
{
	NSAssert1(_emitterFile, @"particle emitter view controller (%@): emitterFile is nil!", self);
	KTASSERT_FILEEXISTS(_emitterFile);
	
	self.rootNode = [CCParticleSystemQuad particleWithFile:_emitterFile];
}

@end
