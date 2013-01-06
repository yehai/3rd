//
//  KTLabelViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

#import "CCProtocols.h"
#import "ccTypes.h"

/** Determines horizontal text alignment. */
typedef enum : unsigned char
{
	/** Text is left aligned. */
	KTHorizontalTextAlignmentLeft,
	/** Text is horizontally center. */
	KTHorizontalTextAlignmentCenter,
	/** Text is right aligned. */
	KTHorizontalTextAlignmentRight,
} KTHorizontalTextAlignment;

/** Determines vertical text alignment. */
typedef enum : unsigned char
{
	/** Text is aligned to the top. */
	KTVerticalTextAlignmentTop,
	/** Text is vertically centered. */
	KTVerticalTextAlignmentCenter,
	/** Text is aligned to the bottom. */
	KTVerticalTextAlignmentBottom,
} KTVerticalTextAlignment;

/** Determines line break (truncate or wrap) behavior. */
typedef enum : unsigned char
{
	/** The text wraps at the nearest word. Words are guaranteed to be on one line, unless a word is too long to fit into a single line. */
	KTLineBreakBehaviorWordWrap,
	/** The text wraps at the nearest character. This can cause words to span two lines. */
	KTLineBreakBehaviorCharacterWrap,
	/** The text is clipped when it exceeds the label's contentSize. */
	KTLineBreakBehaviorClip,
	/** The text is truncated at the beginning. */
	KTLineBreakBehaviorTruncateStart,
	/** The text is truncated at the end. */
	KTLineBreakBehaviorTruncateEnd,
	/** The text is truncated in the middle, adding ellipsis (...) in place of the truncated text. */
	KTLineBreakBehaviorTruncateMiddle,
} KTLineBreakBehavior;

// used internally to determine type of class
typedef enum : unsigned char
{
	KTLabelTypeUnknown = 0,
	KTLabelTypeTrueTypeFont,
	KTLabelTypeBitmapFont,
	KTLabelTypeAtlasFont,
} KTLabelType;

// Align to Byte boundaries to conserve some memory
#pragma pack(push, 1)

/** Abstract base class for defining a label's properties. Use one of the concrete subclasses, for example KTTrueTypeFontLabel */
@interface KTFontLabel : NSObject
/** The label's initial text, defaults to empty string. */
@property (nonatomic) NSString* text;
/** The label's text color. */
@property (nonatomic) ccColor3B color;
// used internally
@property (nonatomic, readonly) KTLabelType labelType;
// used internally
-(id) initWithText:(NSString*)text;
// internal use only
-(void) internal_setLabelType;
@end

/** Creates a true type font with the given properties. Only Truetype labels allow line breaks.
 You can not change the distance between two lines, to achieve that you'll have to create one label for each line. */
@interface KTTrueTypeFontLabel : KTFontLabel
/** The name of the font or font family. Defaults to Arial. */
@property (nonatomic, copy) NSString* fontName;
/** The size of the font in points. Defaults to 24. */
@property (nonatomic) float fontSize;
/** The size to which the label is restricted. Defaults to the optimum size for the given text, font and fontSize.
 If the size is smaller than the label's text length with the given font,
 then lineBreakBehavior comes into effect. */
@property (nonatomic) CGSize contentSize;
/** Determines how the text is wrapped or truncated when the text length is wider than contentSize.width. Defaults to word wrap. */
@property (nonatomic) KTLineBreakBehavior lineBreakBehavior;
/** Determines the text's horizontal alignment. Defaults to left alignment. */
@property (nonatomic) KTHorizontalTextAlignment horizontalAlignment;
/** Determines the text's vertical alignment. Defaults to top alignment. */
@property (nonatomic) KTVerticalTextAlignment verticalAlignment;

/** Create a truetype font label with text and default settings. */
+(id) trueTypeFontLabelWithText:(NSString*)text;
/** Create a truetype font label with text and default settings. */
-(id) initWithText:(NSString*)text;
@end

/** Creates a bitmap font with the given properties. Bitmap fonts do not support line breaks. You will have to
 create one label for each line to achieve line breaks, and implement a way to split the text properly, ie at word boundaries. */
@interface KTBitmapFontLabel : KTFontLabel
/** The .fnt definition file to load. Such a file can be created with a number of editors, for example Glyph Designer.
 Hiero is not recommended, as it produces upside down images and is quite buggy. The corresponding .png file must also
 be added to the project's resources folder. */
@property (nonatomic, readonly) NSString* fntFile;
/** The width of the label. If width is too small text will be truncated. Defaults to optimal width. */
@property (nonatomic) float width;
/** Offset in points for the image file referenced by the fnt file. Use only if the image file has an offset. Defaults to no offset. */
@property (nonatomic) CGPoint imageOffset;
/** Determines the text's horizontal alignment. Defaults to center alignment. */
@property (nonatomic) KTHorizontalTextAlignment horizontalAlignment;

/** Create a bitmap font label with text, fnt file and default settings. */
+(id) bitmapFontLabelWithText:(NSString*)text fntFile:(NSString*)fntFile;
/** Create a bitmap font label with text, fnt file and default settings. */
-(id) initWithText:(NSString*)text fntFile:(NSString*)fntFile;
@end

/** Creates an atlas (bitmap) font with the given properties. All characters must be the same width and height (fixed font).
 All characters must be in ascending order of the ASCII table, but can start with any character in the ASCII table. */
@interface KTAtlasFontLabel : KTFontLabel
/** Determines the texture atlas (image) file which contains the characters. */
@property (nonatomic, readonly) NSString* atlasFile;
/** The width of the characters in the texture atlas. */
@property (nonatomic, readonly) unsigned short characterWidth;
/** The height of the characters in the texture atlas. */
@property (nonatomic, readonly) unsigned short characterHeight;
/** The ASCII code of the first character in the atlas. For example, if you set this to '.' (46 decimal) then the subsequent
 characters in the atlas file from left to right must be ASCII characters naturally following the first character.
 In this case: '.' '/' '0' '1' and so on. Refer to http://www.asciitable.com for the ASCII charts. */
@property (nonatomic, readonly) unsigned short firstCharacter;

/** Create a atlas font label with text, atlas (image) file, character width and height, and the ASCII code of the first character in the atlas. */
+(id) atlasFontLabelWithText:(NSString*)text atlasFile:(NSString*)atlasFile characterWidth:(unsigned short)characterWidth characterHeight:(unsigned short)characterHeight firstCharacter:(unsigned short)firstCharacter;
/** Create a atlas font label with text, atlas (image) file, character width and height, and the ASCII code of the first character in the atlas. */
-(id) initWithText:(NSString*)text atlasFile:(NSString*)atlasFile characterWidth:(unsigned short)characterWidth characterHeight:(unsigned short)characterHeight firstCharacter:(unsigned short)firstCharacter;
@end

#pragma pack(pop)

@class CCLabelAtlas;
@class CCLabelBMFont;
@class CCLabelTTF;

/** Displays a text label. You can choose between TTF, bitmap and atlas fonts. The rootNode is one of either CCLabelTTF, CCLabelBMFont or CCLabelAtlas.

 - Truetype fonts are just as fast as sprites, except changing the label text which is extremely slow every time it occurs.
 - Bitmap fonts are fast, changing label text has no performance impact. Can be created with Glyph Designer and other tools. 
 Individual characters are sprites and can be modified individually. Bitmap fonts also work with Unicode text.
 - Atlas fonts are legacy bitmap fonts with similar features, but it requires the font characters to be placed in a texture
 using a fixed width and height and following the order of the ASCII table. Because of this bitmap fonts are the preferred choice.
 */
@interface KTLabelViewController : KTViewController
{
@protected
@private
	KTFontLabel* _fontLabel;
	id<CCLabelProtocol, CCRGBAProtocol> _labelNode;
	KTLabelType _labelType;
}

/** Returns the label implementing CCLabelProtocol. This only supports getting and setting the label's text via the string property. */
@property (nonatomic, readonly) CCNode<CCLabelProtocol, CCRGBAProtocol>* label;
/** Returns the CCLabelAtlas object. Returns nil if the view controller's label object is of a different label class. */
@property (nonatomic, readonly) CCLabelAtlas* labelAtlas;
/** Returns the CCLabelBMFont object. Returns nil if the view controller's label object is of a different label class. */
@property (nonatomic, readonly) CCLabelBMFont* labelBitmapFont;
/** Returns the CCLabelTTF object. Returns nil if the view controller's label object is of a different label class. */
@property (nonatomic, readonly) CCLabelTTF* labelTTF;

/** The text displayed by the label. Note: Changing text of truetype font labels is very slow, try to avoid doing that or switch to a bitmap font label. */
@property (nonatomic) NSString* text;

/** Create a lavel viewcontroller instance with the given font label definition object. */
+(id) labelControllerWithFontLabel:(KTFontLabel*)fontLabel;
/** Create a lavel viewcontroller instance with the given font label definition object. */
-(id) initWithFontLabel:(KTFontLabel*)fontLabel;

@end
