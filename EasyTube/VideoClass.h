#import <Foundation/Foundation.h>

@interface VideoClass : NSObject {
@private
	NSUInteger Length;
	NSString   *Title;
	NSString   *URL;
	NSString   *Author;
	UIImage    *Thumbnail;
}

@property (nonatomic, assign) NSUInteger Length;
@property (nonatomic, strong) NSString   *Title;
@property (nonatomic, strong) NSString   *URL;
@property (nonatomic, strong) NSString   *Author;
@property (nonatomic, strong) UIImage    *Thumbnail;

- (id)initWithVideo:(VideoClass *)video;
- (id)initWithPath:(NSString *)path error:(NSError **)error;

- (BOOL)saveToPath:(NSString *)path error:(NSError **)error;

- (BOOL)isValid;

- (NSString *)getVideoId;
- (NSString *)lengthToString;
- (UIImage *)resizeThumbnailToSize:(CGSize)size;

@end
