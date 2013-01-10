//
//  KTTilemapLayerModel.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 20.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KoboldTouch.h"

@interface KTTilemapLayerModel : KTEntityModel
{
@protected
@private
	__weak KTTilemapModel* _tilemapModel;
}

@property (nonatomic, weak) KTTilemapLayer* tileLayer;
@property (nonatomic) CGPoint scrollCenter;

-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel tileLayer:(KTTilemapLayer*)tileLayer;

@end
