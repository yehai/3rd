//
//  KTLabelViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTLabelViewController.h"
#import "KTMacros.h"

#import "CCLabelAtlas.h"
#import "CCLabelBMFont.h"
#import "CCLabelTTF.h"
#import "CCFileUtils.h"

@implementation KTFontLabel
-(id) initWithText:(NSString*)text
{
	self = [super init];
	if (self)
	{
		_text = [text copy];
		_color = ccWHITE;
		[self internal_setLabelType];
	}
	return self;
}
-(void) internal_setLabelType
{
	if ([self isKindOfClass:[KTTrueTypeFontLabel class]])
	{
		_labelType = KTLabelTypeTrueTypeFont;
	}
	else if ([self isKindOfClass:[KTBitmapFontLabel class]])
	{
		_labelType = KTLabelTypeBitmapFont;
	}
	else if ([self isKindOfClass:[KTAtlasFontLabel class]])
	{
		_labelType = KTLabelTypeAtlasFont;
	}
	else
	{
		[NSException raise:@"unsupported KTFontLabel class" format:@"unsupported KTFontLabel class"];
	}
}
@end

@implementation KTTrueTypeFontLabel
+(id) trueTypeFontLabelWithText:(NSString*)text
{
	return [[self alloc] initWithText:text];
}
-(id) initWithText:(NSString*)text
{
	self = [super initWithText:text];
	if (self)
	{
		[self setDefaults];
	}
	return self;
}
-(void) setDefaults
{
	self.fontName = @"Arial";
	_fontSize = 24;
	_contentSize = CGSizeZero;
	_lineBreakBehavior = KTLineBreakBehaviorWordWrap;
	_horizontalAlignment = KTHorizontalTextAlignmentLeft;
	_verticalAlignment = KTVerticalTextAlignmentTop;
}
@end

@implementation KTBitmapFontLabel
+(id) bitmapFontLabelWithText:(NSString*)text fntFile:(NSString*)fntFile
{
	return [[self alloc] initWithText:text fntFile:fntFile];
}
-(id) initWithText:(NSString*)text fntFile:(NSString*)fntFile
{
	self = [super initWithText:text];
	if (self)
	{
		[self setDefaults];
		_fntFile = [fntFile copy];
	}
	return self;
}
-(void) setDefaults
{
	_width = kCCLabelAutomaticWidth;
	_imageOffset = CGPointZero;
	_horizontalAlignment = KTHorizontalTextAlignmentLeft;
}
@end

@implementation KTAtlasFontLabel
+(id) atlasFontLabelWithText:(NSString*)text atlasFile:(NSString*)atlasFile characterWidth:(unsigned short)characterWidth characterHeight:(unsigned short)characterHeight firstCharacter:(unsigned short)firstCharacter
{
	return [[self alloc] initWithText:text atlasFile:atlasFile characterWidth:characterWidth characterHeight:characterHeight firstCharacter:firstCharacter];
}
-(id) initWithText:(NSString*)text atlasFile:(NSString*)atlasFile characterWidth:(unsigned short)characterWidth characterHeight:(unsigned short)characterHeight firstCharacter:(unsigned short)firstCharacter
{
	self = [super initWithText:text];
	if (self)
	{
		_atlasFile = [atlasFile copy];
		_characterWidth = characterWidth;
		_characterHeight = characterHeight;
		_firstCharacter = firstCharacter;
	}
	return self;
}
@end


#pragma mark KTLabelViewController
@implementation KTLabelViewController

@dynamic label, labelAtlas, labelBitmapFont, labelTTF, text;

-(NSString*) text
{
	if (_labelNode)
	{
		return _labelNode.string;
	}
	return _fontLabel.text;
}
-(void) setText:(NSString *)text
{
	if (_labelNode)
	{
		_labelNode.string = text;
	}
	else
	{
		_fontLabel.text = text;
	}
}

-(CCNode<CCLabelProtocol, CCRGBAProtocol>*) label
{
	return (CCNode<CCLabelProtocol, CCRGBAProtocol>*)self.rootNode;
}
-(CCLabelAtlas*) labelAtlas
{
	if (_labelType == KTLabelTypeAtlasFont)
	{
		return (CCLabelAtlas*)self.rootNode;
	}
	return nil;
}
-(CCLabelBMFont*) labelBitmapFont
{
	if (_labelType == KTLabelTypeBitmapFont)
	{
		return (CCLabelBMFont*)self.rootNode;
	}
	return nil;
}
-(CCLabelTTF*) labelTTF
{
	if (_labelType == KTLabelTypeTrueTypeFont)
	{
		return (CCLabelTTF*)self.rootNode;
	}
	return nil;
}


+(id) labelControllerWithFontLabel:(KTFontLabel*)fontLabel
{
	return [[self alloc] initWithFontLabel:fontLabel];
}
-(id) initWithFontLabel:(KTFontLabel*)fontLabel
{
	self = [super init];
	if (self)
	{
		_fontLabel = fontLabel;
	}
	return self;
}

-(void) loadView
{
	_labelType = _fontLabel.labelType;
	switch (_labelType)
	{
		case KTLabelTypeTrueTypeFont:
		{
			KTTrueTypeFontLabel* ttfLabel = (KTTrueTypeFontLabel*)_fontLabel;
			_labelNode = [CCLabelTTF labelWithString:ttfLabel.text
											fontName:ttfLabel.fontName
											fontSize:ttfLabel.fontSize
										  dimensions:ttfLabel.contentSize
										  hAlignment:ttfLabel.horizontalAlignment
										  vAlignment:ttfLabel.verticalAlignment
									   lineBreakMode:ttfLabel.lineBreakBehavior];
			break;
		}
		case KTLabelTypeBitmapFont:
		{
			KTBitmapFontLabel* bmLabel = (KTBitmapFontLabel*)_fontLabel;
			KTASSERT_FILEEXISTS(bmLabel.fntFile);
			_labelNode = [CCLabelBMFont labelWithString:bmLabel.text
												fntFile:bmLabel.fntFile
												  width:bmLabel.width
											  alignment:bmLabel.horizontalAlignment
											imageOffset:bmLabel.imageOffset];
			break;
		}
		case KTLabelTypeAtlasFont:
		{
			KTAtlasFontLabel* atlasLabel = (KTAtlasFontLabel*)_fontLabel;
			KTASSERT_FILEEXISTS(atlasLabel.atlasFile);
			_labelNode = [CCLabelAtlas labelWithString:atlasLabel.text
										   charMapFile:atlasLabel.atlasFile
											 itemWidth:atlasLabel.characterWidth
											itemHeight:atlasLabel.characterHeight
										  startCharMap:atlasLabel.firstCharacter];
			break;
		}
			
		default:
			[NSException raise:@"unsupported font label type" format:@"unsupported font label type"];
			break;
	}

	NSAssert(_labelNode, @"labelNode is nil, failed to initialize font label");
	_labelNode.color = _fontLabel.color;
	self.rootNode = _labelNode;
}

@end
