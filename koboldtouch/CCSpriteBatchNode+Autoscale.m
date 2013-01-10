//
//  CCSpriteBatchNode+Autoscale.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 03.01.13.
//
//

#import "CCSpriteBatchNode+Autoscale.h"
#import "CCNode+Autoscale.h"

@implementation CCSpriteBatchNode (Autoscale)

-(void) visitReplacement
{
	[self willRenderFrame];
	[self sendWillRenderFrameToChildren:self];
	
	// call original implementation - if this look wrong to you, read up on Method Swizzling: http://www.cocoadev.com/index.pl?MethodSwizzling)
	[self visitReplacement];
	
	[self didRenderFrame];
	[self sendDidRenderFrameToChildren:self];
}

-(void) sendWillRenderFrameToChildren:(CCNode*)node
{
	for (CCNode* childNode in node.children)
	{
		[childNode willRenderFrame];
		[self sendWillRenderFrameToChildren:childNode];
	}
}

-(void) sendDidRenderFrameToChildren:(CCNode*)node
{
	for (CCNode* childNode in node.children)
	{
		[childNode didRenderFrame];
		[self sendDidRenderFrameToChildren:childNode];
	}
}

@end
