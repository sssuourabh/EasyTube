#import "VideoClass.h"
#import "VideoDBClass.h"

@implementation VideoDBClass

@synthesize VideoDBDir;
@synthesize VideoDownloadsDir;
@synthesize VideoDir;

- (id)init {
	if((self = [super init])) {
		VideoDBDir        = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoDB"];
		VideoDownloadsDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoDownloads"];
		VideoDir          = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Video"];

		NSFileManager *manager = [NSFileManager defaultManager];

		[manager createDirectoryAtPath:VideoDBDir        withIntermediateDirectories:YES attributes:nil error:nil];
		[manager createDirectoryAtPath:VideoDownloadsDir withIntermediateDirectories:YES attributes:nil error:nil];
		[manager createDirectoryAtPath:VideoDir          withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return self;
}

- (BOOL)isVideoExists:(VideoClass *)video {
	NSFileManager *manager = [NSFileManager defaultManager];

	return [manager fileExistsAtPath:[self.VideoDBDir        stringByAppendingPathComponent:[video getVideoId]]] ||
	       [manager fileExistsAtPath:[self.VideoDownloadsDir stringByAppendingPathComponent:[video getVideoId]]];
}

- (BOOL)createDownload:(VideoClass *)video error:(NSError **)error {
	NSString      *dir     = [self.VideoDownloadsDir stringByAppendingPathComponent:[video getVideoId]];
	NSFileManager *manager = [NSFileManager defaultManager];

	if ([manager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:error] &&
	    [video   saveToPath:dir                                                           error:error]) {
		return YES;
	} else {
		[manager removeItemAtPath:dir error:nil];

		return NO;
	}
}

- (BOOL)deleteDownload:(VideoClass *)video error:(NSError **)error {
	static NSInteger const ERROR_UNKNOWN = -1;

	NSFileManager *manager = [NSFileManager defaultManager];

	if ([manager fileExistsAtPath:[self.VideoDownloadsDir stringByAppendingPathComponent:[video getVideoId]]]) {
		if ([manager fileExistsAtPath:[self getPathToVideoFile:video]]) {
			return [manager removeItemAtPath:[self getPathToVideoFile:video]                                            error:error] &&
			       [manager removeItemAtPath:[self.VideoDownloadsDir stringByAppendingPathComponent:[video getVideoId]] error:error];
		} else {
			return [manager removeItemAtPath:[self.VideoDownloadsDir stringByAppendingPathComponent:[video getVideoId]] error:error];
		}
	} else {
		if (error != nil) {
			NSDictionary *user_info = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Download does not exist", @"Download does not exist") forKey:NSLocalizedDescriptionKey];

			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:ERROR_UNKNOWN userInfo:user_info];
		}

		return NO;
	}
}

- (BOOL)completeDownload:(VideoClass *)video error:(NSError **)error {
	return [[NSFileManager defaultManager] moveItemAtPath:[self.VideoDownloadsDir stringByAppendingPathComponent:[video getVideoId]] toPath:[self.VideoDBDir stringByAppendingPathComponent:[video getVideoId]] error:error];
}

- (BOOL)deleteVideo:(VideoClass *)video error:(NSError **)error {
	static NSInteger const ERROR_UNKNOWN = -1;
	
	NSFileManager *manager = [NSFileManager defaultManager];

	if ([manager fileExistsAtPath:[self.VideoDBDir stringByAppendingPathComponent:[video getVideoId]]]) {
		if ([manager fileExistsAtPath:[self getPathToVideoFile:video]]) {
			return [manager removeItemAtPath:[self getPathToVideoFile:video]                                     error:error] &&
			       [manager removeItemAtPath:[self.VideoDBDir stringByAppendingPathComponent:[video getVideoId]] error:error];
		} else {
			return [manager removeItemAtPath:[self.VideoDBDir stringByAppendingPathComponent:[video getVideoId]] error:error];
		}
	} else {
		if (error != nil) {
			NSDictionary *user_info = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Video does not exist", @"Video does not exist") forKey:NSLocalizedDescriptionKey];

			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:ERROR_UNKNOWN userInfo:user_info];
		}

		return NO;
	}
}

- (NSString *)getPathToVideoFile:(VideoClass *)video {
	return [self.VideoDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [video getVideoId]]];
}

- (NSArray *)getDownloads {
    NSError *error;
	NSString       *dir;
	NSMutableArray *result   = [NSMutableArray array];
	NSFileManager  *manager  = [NSFileManager defaultManager];
	NSEnumerator   *dir_enum = [[manager contentsOfDirectoryAtPath:self.VideoDownloadsDir error:&error] objectEnumerator];

	while ((dir = [dir_enum nextObject])) {
		BOOL directory;

		NSString *full_dir = [self.VideoDownloadsDir stringByAppendingPathComponent:dir];

		if ([manager fileExistsAtPath:full_dir isDirectory:&directory] && directory) {
			VideoClass *video = [[VideoClass alloc] initWithPath:full_dir error:nil];

			if (video != nil) {
				[result addObject:video];
			} else {
				[manager removeItemAtPath:full_dir error:nil];
			}
		}
	}

	return [NSArray arrayWithArray:result];
}

- (NSArray *)getVideos {
    NSError *error;
	NSString       *dir;
	NSMutableArray *result   = [NSMutableArray array];
	NSFileManager  *manager  = [NSFileManager defaultManager];
	NSEnumerator   *dir_enum = [[manager contentsOfDirectoryAtPath:self.VideoDBDir error:&error] objectEnumerator];
	
	while ((dir = [dir_enum nextObject])) {
		BOOL directory;
		
		NSString *full_dir = [self.VideoDBDir stringByAppendingPathComponent:dir];
		
		if ([manager fileExistsAtPath:full_dir isDirectory:&directory] && directory) {
			VideoClass *video = [[VideoClass alloc] initWithPath:full_dir error:nil];
			
			if (video != nil) {
				[result addObject:video];
			} else {
				[manager removeItemAtPath:full_dir error:nil];
			}
		}
	}
	
	return [NSArray arrayWithArray:result];
}


@end
