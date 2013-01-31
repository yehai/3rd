//
//  KTDrawingPrimitivesViewController.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 18.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class KTDrawDot;
@class KTDrawLine;
@class KTDrawPolygon;

/** View controller for drawing geometric primitives: dots (filled), lines (rounded) and polygons (closed, optional fill color). Renders all
 primitives in a single draw call. Is a wrapper for the cocos2d CCDrawNode class, but you can now add/remove individual primitives.
 
 Caution: CCDrawNode is currently not capable of drawing concave polygons with fill color correctly. The fill color will "bleed out" as if the polygon
 were actually convex. But support for concave polygons in CCDrawNode is promised as "coming soon".
 
 Caution: If you add a drawing primitive, it will be added to CCDrawNode. But if you remove a drawing primitive, it will issue
 a "clear" to CCDrawNode and re-add all the existing primitives back to CCDrawNode. Depending on how many drawing primitives
 you've added this may impact performance, since CCDrawNode will have to re-allocate the memory for all the newly added
 drawing primitives. You may want to avoid removing drawing primitives very frequently, especially if that particular
 KTDrawingPrimitivesViewController renders a lot of drawing primitives. You may be able to optimize this behavior by creating a separate
 KTDrawingPrimitivesViewController for those primitives which you'll often need to remove, while keeping those that are permanent
 or rarely removed in another KTDrawingPrimitivesViewController.
 */
@interface KTDrawingPrimitivesViewController : KTViewController
{
@protected
@private
}

/** Adds the primitive to the view. */
-(void) addDot:(KTDrawDot*)dot;
/** Removes the primitive from the view. Causes all primitives to be recreated on the view side. */
-(void) removeDot:(KTDrawDot*)dot;
/** Removes all the primitives from the view. Causes all primitives to be recreated on the view side. */
-(void) removeAllDots;

/** Adds the primitive to the view. */
-(void) addLine:(KTDrawLine*)line;
/** Removes the primitive from the view. Causes all primitives to be recreated on the view side. */
-(void) removeLine:(KTDrawLine*)line;
/** Removes all the primitives from the view. Causes all primitives to be recreated on the view side. */
-(void) removeAllLines;

/** Adds the primitive to the view. */
-(void) addPolygon:(KTDrawPolygon*)polygon;
/** Removes the primitive from the view. Causes all primitives to be recreated on the view side. */
-(void) removePolygon:(KTDrawPolygon*)polygon;
/** Removes all the primitives from the view. Causes all primitives to be recreated on the view side. */
-(void) removeAllPolygons;


/// internal use
// removes all primitives and re-adds them all
-(void) resetView;
// only adds new primitives
-(void) updateView;

@end
