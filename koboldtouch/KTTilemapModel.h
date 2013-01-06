//
//  KTTilemapModel.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTModel.h"
#import "KTTilemap.h"

/** Model for a TMX tilemap. */
@interface KTTilemapModel : KTModel
{
@protected
@private
}

@property (nonatomic, readonly) KTTilemap* tilemap;

@end
