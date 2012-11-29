#import <Foundation/Foundation.h>

@class VideoClass;

@interface VideoDBClass : NSObject {
@private
	NSString *VideoDBDir;
	NSString *VideoDownloadsDir;
	NSString *VideoDir;
}

@property (nonatomic, strong) NSString *VideoDBDir;
@property (nonatomic, strong) NSString *VideoDownloadsDir;
@property (nonatomic, strong) NSString *VideoDir;

- (BOOL)isVideoExists:(VideoClass *)video;

- (BOOL)createDownload:(VideoClass *)video error:(NSError **)error;
- (BOOL)deleteDownload:(VideoClass *)video error:(NSError **)error;
- (BOOL)completeDownload:(VideoClass *)video error:(NSError **)error;

- (BOOL)deleteVideo:(VideoClass *)video error:(NSError **)error;

- (NSString *)getPathToVideoFile:(VideoClass *)video;

- (NSArray *)getDownloads;
- (NSArray *)getVideos;

@end
