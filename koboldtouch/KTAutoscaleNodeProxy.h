//
//  KTAutoscaleNodeProxy.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//
//

#import <Foundation/Foundation.h>

#import "KTAutoscaleController.h"

@interface KTAutoscaleNodeProxy : NSObject
{
}

@property (nonatomic) CCNode* node;
@property (nonatomic, weak) KTAutoscaleController* autoscaleController;
@property (nonatomic) KTAutoscaleProperty scaledProperties;
@property (nonatomic) BOOL autoscalePosition;
//@property (nonatomic) BOOL autoscaleScaleX;
//@property (nonatomic) BOOL autoscaleScaleY;
@property (nonatomic) CGPoint unscaledPosition;

-(id) initWithNode:(CCNode*)node autoscaleController:(KTAutoscaleController*)autoscaleController;
-(void) cleanup;
-(CGPoint) scaledPosition:(CGPoint)position;

@end
