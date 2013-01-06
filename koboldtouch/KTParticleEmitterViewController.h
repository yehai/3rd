//
//  KTParticleEmitterViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

/** View controller for a particle emitter (CCParticleSystemQuad). */
@interface KTParticleEmitterViewController : KTViewController
{
@protected
@private
}

/** The .plist file containing the properties of the emitter. Create this plist with a particle design tool like Particle Designer. */
@property (nonatomic, copy) NSString* emitterFile;

/** Creates a particle emitter view controller with a particle file (plist created by Particle Designer or similar tool). */
+(id) particleEmitterControllerWithEmitterFile:(NSString*)emitterFile;
/** Creates a particle emitter view controller with a particle file (plist created by Particle Designer or similar tool). */
-(id) initWithEmitterFile:(NSString*)emitterFile;

@end
