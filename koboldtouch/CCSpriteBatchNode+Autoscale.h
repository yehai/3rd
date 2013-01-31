//
//  CCSpriteBatchNode+Autoscale.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 03.01.13.
//
//

#import "CCSpriteBatchNode.h"

/** Autoscale category for CCSpriteBatchNode. CCSpriteBatchNode handles drawing of all CCSprite children, 
 this category ensures that willRenderFrame and didRenderFrame messages are sent to CCSprite children.
 This is required to allow autoscaling of sprite batched sprites. */
@interface CCSpriteBatchNode (Autoscale)

/** Called in place of visit method in order to send willRenderFrame and didRenderFrame to itself and all of the CCSprite children. */
-(void) visitReplacement;

@end
