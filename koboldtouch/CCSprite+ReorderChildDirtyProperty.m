//
//  CCSprite+ReorderChildDirtyProperty.m
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 22.01.13.
//
//

#import "CCSprite+ReorderChildDirtyProperty.h"

@implementation CCSprite (ReorderChildDirtyProperty)

@dynamic isReorderChildDirty;

-(BOOL) isReorderChildDirty
{
	return isReorderChildDirty_;
}
-(void) setIsReorderChildDirty:(BOOL)isReorderChildDirty
{
	isReorderChildDirty_ = isReorderChildDirty;
}

@end
