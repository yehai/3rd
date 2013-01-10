//
//  CCNode+Autoscale.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//
//

#import "CCNode.h"

@class KTAutoscaleNodeProxy;

@interface CCNode (Autoscale)

+(void) setAutoscaleNodeProxyClass;

-(KTAutoscaleNodeProxy*) autoscaleNodeProxy;

-(void) cleanupReplacement;
-(void) visitReplacement;

-(void) willRenderFrame;
-(void) didRenderFrame;

@end
