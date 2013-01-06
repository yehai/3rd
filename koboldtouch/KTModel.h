//
//  KTModel.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 24.09.12.
//
//

#import "KTModelControllerBase.h"

@class KTController;
@class KTMutableNumber;

/** Base class for model objects. A model implements logic and contains the data needed for model logic. A model is archivable
 when implementing the initWithArchive and archiveWithCoder methods. A model is always associated with a specific controller,
 accessible via self.controller.
 
 The Model also implements keyed values for common data types (BOOL, float, double, Int32, Int64). Key-value variables have great benefits:
 - no need to subclass a model to add properties
 - keyed values are automatically archived & loaded
 - you can simply create a new key/value simply by setting it
 - reading a non-existing key/value returns a sensible default value
 .

 Internally Key/Value does *not* use NSNumber to avoid alloc/dealloc every time the value changes. Instead very simple
 ObjC classes (ie KTBoolValue) with a single property (BOOL boolValue) are used to store the values in a mutable dictionary.
 The key/value dictionary is allocated when the first key/value is set.
 */
@interface KTModel : KTModelControllerBase <NSCoding>
{
	NSMutableDictionary* _keyedValues;
}

/** Points to the model's controller object. Each model has exactly one controller. */
@property (nonatomic, readonly, weak) KTController* controller;


/** Returns a new model object. */
+(id) model;

/** Override to restore model values from archive. Note: self.controller is nil at this point.
 Use load method to fully initialize model and to run code that is common to both initializing from archive and initializing with defaults. */
-(void) initWithArchive:(NSKeyedUnarchiver*)aDecoder archiveVersion:(int)archiveVersion;

/** Runs when archiving the model. Save your model's data here. */
-(void) archiveWithCoder:(NSKeyedArchiver*)aCoder;

/** Set value of the given type for key. Value is mutable, it is not an NSNumber to avoid alloc/dealloc for every set. */
-(void) setBool:(BOOL)boolValue forKey:(NSString*)key;
/** Returns the value of the given type for key. Returns NO if there's no value with this key. */
-(BOOL) boolForKey:(NSString*)key;
/** Set value of the given type for key. Value is mutable, it is not an NSNumber to avoid alloc/dealloc for every set. */
-(void) setFloat:(float)floatValue forKey:(NSString*)key;
/** Returns the value of the given type for key. Returns 0 if there's no value with this key. */
-(float) floatForKey:(NSString*)key;
/** Set value of the given type for key. Value is mutable, it is not an NSNumber to avoid alloc/dealloc for every set. */
-(void) setDouble:(double)doubleValue forKey:(NSString*)key;
/** Returns the value of the given type for key. Returns 0 if there's no value with this key. */
-(double) doubleForKey:(NSString*)key;
/** Set value (32-Bit) of the given type for key. Value is mutable, it is not an NSNumber to avoid alloc/dealloc for every set. */
-(void) setInt32:(int32_t)int32Value forKey:(NSString*)key;
/** Returns the value (32-Bit) of the given type for key. Returns 0 if there's no value with this key. */
-(int32_t) int32ForKey:(NSString*)key;
/** Set value (32-Bit) of the given type for key. Value is mutable, it is not an NSNumber to avoid alloc/dealloc for every set. */
-(void) setUnsignedInt32:(uint32_t)unsignedInt32Value forKey:(NSString*)key;
/** Returns the value (32-Bit) of the given type for key. Returns 0 if there's no value with this key. */
-(uint32_t) unsignedInt32ForKey:(NSString*)key;
/** Set value (64-Bit) of the given type for key. Value is mutable, it is not an NSNumber to avoid alloc/dealloc for every set. */
-(void) setInt64:(int64_t)int64Value forKey:(NSString*)key;
/** Returns the value (64-Bit) of the given type for key. Returns 0 if there's no value with this key. */
-(int64_t) int64ForKey:(NSString*)key;
/** Set value (64-Bit) of the given type for key. Value is mutable, it is not an NSNumber to avoid alloc/dealloc for every set. */
-(void) setUnsignedInt64:(uint64_t)unsignedInt64Value forKey:(NSString*)key;
/** Returns the value (64-Bit) of the given type for key. Returns 0 if there's no value with this key. */
-(uint64_t) unsignedInt64ForKey:(NSString*)key;

/** Returns the underlying KTMutableNumber object for a specific variable key. You can then modify the
 number value without having to reassign it to the model. */
-(KTMutableNumber*) mutableNumberForKey:(NSString*)key;

// internal use only
-(void) internal_setController:(KTController*)controller;
@end
