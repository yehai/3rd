//
//  KTSceneTransitionTypes.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 22.09.12.
//
//

#ifndef Kobold2D_Libraries_KTSceneTransitionTypes_h
#define Kobold2D_Libraries_KTSceneTransitionTypes_h

/** @file KTSceneTransitionTypes.h */

/** Mapping for the various cocos2d scene transition types of the same name. Note that you *can* transition even to the very first scene
 (first presentScene call in AppDelegate) but not all transition types support this. For example the page turn transition requires that
 an "outgoing" scene exists. */
typedef enum : int
{
	KTSceneTransitionTypeNone = 0,		/**< */
	KTSceneTransitionTypeFade,		/**< */
	KTSceneTransitionTypeCrossFade,		/**< */
	KTSceneTransitionTypeFadeFromBottomLeft,		/**< */
	KTSceneTransitionTypeFadeFromTopRight,		/**< */
	KTSceneTransitionTypeFadeUpwards,		/**< */
	KTSceneTransitionTypeFadeDownwards,		/**< */
	KTSceneTransitionTypeJumpAndZoom,		/**< */
	KTSceneTransitionTypeMoveInFromLeft,		/**< */
	KTSceneTransitionTypeMoveInFromRight,		/**< */
	KTSceneTransitionTypeMoveInFromTop,		/**< */
	KTSceneTransitionTypeMoveInFromBottom,		/**< */
	KTSceneTransitionTypePageTurnFromLeft,		/**< can not be used for transitions to the very first scene */
	KTSceneTransitionTypePageTurnFromRight,		/**< can not be used for transitions to the very first scene */
	KTSceneTransitionTypeProgressRadialClockwise,		/**< */
	KTSceneTransitionTypeProgressRadialCounterClockwise,		/**< */
	KTSceneTransitionTypeProgressHorizontal,		/**< */
	KTSceneTransitionTypeProgressVertical,		/**< */
	KTSceneTransitionTypeProgressInOut,		/**< */
	KTSceneTransitionTypeProgressOutIn,		/**< */
	KTSceneTransitionTypeRotateAndZoom,		/**< */
	KTSceneTransitionTypeFlipAngularFromBottomLeft,		/**< */
	KTSceneTransitionTypeFlipAngularFromTopRight,		/**< */
	KTSceneTransitionTypeZoomAndFlipAngularFromBottomLeft,		/**< */
	KTSceneTransitionTypeZoomAndFlipAngularFromTopRight,		/**< */
	KTSceneTransitionTypeFlipHorizontalFromLeft,		/**< */
	KTSceneTransitionTypeFlipHorizontalFromRight,		/**< */
	KTSceneTransitionTypeFlipVerticalFromTop,		/**< */
	KTSceneTransitionTypeFlipVerticalFromBottom,		/**< */
	KTSceneTransitionTypeZoomAndFlipHorizontalFromLeft,		/**< */
	KTSceneTransitionTypeZoomAndFlipHorizontalFromRight,		/**< */
	KTSceneTransitionTypeZoomAndFlipVerticalFromTop,		/**< */
	KTSceneTransitionTypeZoomAndFlipVerticalFromBottom,		/**< */
	KTSceneTransitionTypeShrinkAndGrow,		/**< */
	KTSceneTransitionTypeSlideInFromLeft,		/**< */
	KTSceneTransitionTypeSlideInFromRight,		/**< */
	KTSceneTransitionTypeSlideInFromTop,		/**< */
	KTSceneTransitionTypeSlideInFromBottom,		/**< */
	KTSceneTransitionTypeSplitColumns,		/**< */
	KTSceneTransitionTypeSplitRows,		/**< */
	KTSceneTransitionTypeTurnOffTiles,		/**< */
} KTSceneTransitionType;


#endif
