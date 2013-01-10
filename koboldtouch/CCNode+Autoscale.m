//
//  CCNode+Autoscale.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//
//

#import "CCNode+Autoscale.h"
#import "KTAutoscaleNodeProxy.h"

@implementation CCNode (Autoscale)

static Class autoscaleNodeProxyClass = nil;
+(void) setAutoscaleNodeProxyClass
{
	autoscaleNodeProxyClass = [KTAutoscaleNodeProxy class];
}

-(KTAutoscaleNodeProxy*) autoscaleNodeProxy
{
	if ([userObject_ isKindOfClass:autoscaleNodeProxyClass])
	{
		return (KTAutoscaleNodeProxy*)userObject_;
	}
	return nil;
}

-(void) cleanupReplacement
{
	// remove autoscaled node
	[self.autoscaleNodeProxy cleanup];
	
	// call original implementation - if this look wrong to you, read up on Method Swizzling: http://www.cocoadev.com/index.pl?MethodSwizzling)
	[self cleanupReplacement];
}

-(void) visitReplacement
{
	[self willRenderFrame];
	
	// call original implementation - if this look wrong to you, read up on Method Swizzling: http://www.cocoadev.com/index.pl?MethodSwizzling)
	[self visitReplacement];
	
	[self didRenderFrame];
}

-(void) willRenderFrame
{
	KTAutoscaleNodeProxy* proxy = self.autoscaleNodeProxy;
	if (proxy)
	{
		// apply scaled position before rendering
		proxy.unscaledPosition = position_;
		self.position = [proxy scaledPosition:position_];
	}
}

-(void) didRenderFrame
{
	KTAutoscaleNodeProxy* proxy = self.autoscaleNodeProxy;
	if (proxy)
	{
		// reset to unscaled position
		self.position = proxy.unscaledPosition;
	}
}

@end
