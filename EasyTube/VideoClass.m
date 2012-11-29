#import "VideoClass.h"

@implementation VideoClass

@synthesize Length;
@synthesize Title;
@synthesize URL;
@synthesize Author;
@synthesize Thumbnail;

static NSString *FILE_LENGTH    = @"Length";
static NSString *FILE_TITLE     = @"Title";
static NSString *FILE_URL       = @"URL";
static NSString *FILE_AUTHOR    = @"Author";
static NSString *FILE_THUMBNAIL = @"Thumbnail";

- (id)init {
	if((self = [super init])) {
		Length    = 0;
		Title     = nil;
		URL       = nil;
		Author    = nil;
		Thumbnail = nil;
	}
	return self;
}

- (id)initWithVideo:(VideoClass *)video {
	if((self = [super init])) {
		Length = video.Length;

		if (video.Title != nil) {
			Title = [NSString stringWithString:video.Title];
		} else {
			Title = nil;
		}
		if (video.URL != nil) {
			URL = [NSString stringWithString:video.URL];
		} else {
			URL = nil;
		}
		if (video.Author != nil) {
			Author = [NSString stringWithString:video.Author];
		} else {
			Author = nil;
		}

		Thumbnail = [UIImage imageWithData:UIImagePNGRepresentation(video.Thumbnail)];
	}
	return self;
}

- (id)initWithPath:(NSString *)path error:(NSError **)error {
	if((self = [super init])) {
		Length    = 0;
		Title     = nil;
		URL       = nil;
		Author    = nil;
		Thumbnail = nil;

		if (self != nil) {
			NSString *file_contents = [NSString stringWithContentsOfFile:[path stringByAppendingPathComponent:FILE_LENGTH] encoding:NSUTF8StringEncoding error:error];

			if (file_contents == nil) {
				self = nil;
			} else {
				Length = [file_contents intValue];
			}
		}
		if (self != nil) {
			Title = [NSString stringWithContentsOfFile:[path stringByAppendingPathComponent:FILE_TITLE] encoding:NSUTF8StringEncoding error:error];

			if (Title == nil) {
				self = nil;
			}
		}
		if (self != nil) {
			URL = [NSString stringWithContentsOfFile:[path stringByAppendingPathComponent:FILE_URL] encoding:NSUTF8StringEncoding error:error];

			if (URL == nil) {
				self = nil;
			}
		}
		if (self != nil) {
			Author = [NSString stringWithContentsOfFile:[path stringByAppendingPathComponent:FILE_AUTHOR] encoding:NSUTF8StringEncoding error:error];

			if (Author == nil) {
				self = nil;
			}
		}
		if (self != nil) {
			Thumbnail = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:FILE_THUMBNAIL]];

			if (Thumbnail == nil) {
				self = nil;
			}
		}
	}
	return self;
}

- (BOOL)saveToPath:(NSString *)path error:(NSError **)error {
	return [[NSString stringWithFormat:@"%d", self.Length] writeToFile:[path stringByAppendingPathComponent:FILE_LENGTH]    atomically:YES        encoding:NSUTF8StringEncoding error:error] &&
	       [self.Title                                     writeToFile:[path stringByAppendingPathComponent:FILE_TITLE]     atomically:YES        encoding:NSUTF8StringEncoding error:error] &&
	       [self.URL                                       writeToFile:[path stringByAppendingPathComponent:FILE_URL]       atomically:YES        encoding:NSUTF8StringEncoding error:error] &&
	       [self.Author                                    writeToFile:[path stringByAppendingPathComponent:FILE_AUTHOR]    atomically:YES        encoding:NSUTF8StringEncoding error:error] &&
	       [UIImagePNGRepresentation(self.Thumbnail)       writeToFile:[path stringByAppendingPathComponent:FILE_THUMBNAIL] options:NSAtomicWrite                               error:error];
}

- (BOOL)isValid {
	if (self.Length    != 0 &&
	    self.Title     != nil &&
	    self.URL       != nil &&
	    self.Author    != nil &&
	    self.Thumbnail != nil) {
		NSString *video_id = [self getVideoId];

		if (video_id != nil && ![video_id isEqualToString:@""]) {
			return YES;
		} else {
			return NO;
		}
	} else {
		return NO;
	}
}

- (NSString *)getVideoId {
	NSRange begin;
	
	begin = [self.URL rangeOfString:@"?v="];
	
	if (begin.location == NSNotFound) {
		begin = [self.URL rangeOfString:@"&v="];
	}

	if (begin.location != NSNotFound) {
		NSRange range;

		range.location = begin.location + begin.length;
		range.length   = [self.URL length] - range.location;

		NSRange end = [self.URL rangeOfString:@"&" options:0 range:range];

		if (end.location != NSNotFound) {
			range.location = begin.location + begin.length;
			range.length   = end.location - range.location;
		} else {
			range.location = begin.location + begin.length;
			range.length   = [self.URL length] - range.location;
		}

		return [[self.URL substringWithRange:range] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	} else {
		return nil;
	}
}

- (NSString *)lengthToString {
	int d =  self.Length / 86400;
	int h = (self.Length % 86400) / 3600;
	int m = (self.Length % 3600)  / 60;
	int s =  self.Length % 60;

	if (d == 0) {
		return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
	} else {
		return [NSString stringWithFormat:@"%dd %02d:%02d:%02d", d, h, m, s];
	}
}

- (UIImage *)resizeThumbnailToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);

	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.Thumbnail.CGImage);

	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return result;
}


@end
