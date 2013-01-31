//
//  KTDrawingPrimitivesModel.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 18.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTEntityModel.h"

@class KTDrawDot;
@class KTDrawLine;
@class KTDrawPolygon;

/** Model that keeps a list of KTDrawPrimitive for CCDrawNode. This allows individual drawing primitives to be added
 or removed at runtime without having to re-add them all yourself. 
 */
@interface KTDrawingPrimitivesModel : KTEntityModel
{
@protected
@private
	NSMutableArray* _dots;
	NSMutableArray* _lines;
	NSMutableArray* _polygons;
	BOOL _viewNeedsUpdate;
	BOOL _viewNeedsReset;
}

@property (nonatomic, readonly) NSArray* dots;
@property (nonatomic, readonly) NSArray* lines;
@property (nonatomic, readonly) NSArray* polygons;

-(void) addDot:(KTDrawDot*)dot;
-(void) removeDot:(KTDrawDot*)dot;
-(void) removeAllDots;

-(void) addLine:(KTDrawLine*)line;
-(void) removeLine:(KTDrawLine*)line;
-(void) removeAllLines;

-(void) addPolygon:(KTDrawPolygon*)polygon;
-(void) removePolygon:(KTDrawPolygon*)polygon;
-(void) removeAllPolygons;

@end
