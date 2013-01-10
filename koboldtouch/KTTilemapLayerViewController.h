//
//  KTTilemapLayerViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class KTTilemapLayer;
@class KTTilemapLayerModel;
@class KTTilemapLayerView;
@class KTTilemapModel;
@class CCSpriteBatchNode;

@interface KTTilemapLayerViewController : KTViewController
{
@protected
@private
}

@property (nonatomic) KTTilemapLayerModel* tilemapLayerModel;
@property (nonatomic) KTTilemapLayerView* tilemapLayerView;

-(id) initWithTilemapModel:(KTTilemapModel*)tilemapModel tileLayer:(KTTilemapLayer*)tileLayer;

@end
