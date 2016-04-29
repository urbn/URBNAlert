#import <URBNConvenience/URBNTextField.h>

#pragma mark - App Version
static inline NSString *applicationVersion() {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"URBNConvenience" ofType:@"bundle"];
    if (!bundlePath) {
        bundlePath = [[NSBundle bundleForClass:[URBNTextField class]] pathForResource:@"URBNConvenience" ofType:@"bundle"];
    }
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSDictionary *bundleInfo = [bundle infoDictionary];
	return [NSString stringWithFormat:@"%@ (%@)", [bundleInfo objectForKey:@"CFBundleShortVersionString"], [bundleInfo objectForKey:@"CFBundleVersion"]];
}

#pragma mark - Detect if attached to Xcode
BOOL attachedToDebugger(void);

#pragma mark - Paths
static inline NSString *documentsDirectory() {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
}

static inline NSString *cachesDirectory() {
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
}

static inline NSString *tempDirectory() {
	return NSTemporaryDirectory();
}

static inline NSString *fileNameBasedOnCurrentTime() {
	NSString *fileName = [NSString stringWithFormat:@"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"png"];
    
	return fileName;
}

#pragma mark - File Size conversion
NSUInteger sizeOfFolderContentsInBytes(NSString *folderPath);
double bytesWithMegaBytes(long long megaBytes);
double megaBytesWithBytes(long long bytes);
double gigaBytesWithBytes(long long bytes);
NSString *prettySizeStringWithBytesRounded(long long bytes); // includes MB or GB in string
NSString *prettySizeStringWithBytesFloored(long long bytes); // same

#pragma mark - iCloud exclude from backup
BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL);

#pragma mark - Degrees
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(angle) ((angle) * 180.0 / M_PI)

#pragma mark NSRange
BOOL rangesAreContiguous(NSRange first, NSRange second);
NSRange rangeWithFirstAndLastIndexes(NSUInteger first, NSUInteger last);

#pragma mark time
float nanosecondsWithSeconds(float seconds);
dispatch_time_t dispatchTimeFromNow(float seconds);

static inline NSString *timeZoneString() {
	NSTimeZone *ltz = [NSTimeZone localTimeZone];
	NSString *abbreviation = [ltz abbreviation];

	return abbreviation;
}

#pragma mark Dispatch
void dispatchOnMainQueue(dispatch_block_t block);
void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block);
void dispatchOnBackgroundQueue(dispatch_block_t block);
void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block);

#pragma mark Progress
typedef struct {
	unsigned long long complete;
	unsigned long long total;
	double ratio;
} Progress;

Progress ProgressMake(unsigned long long complete, unsigned long long total);
Progress ProgressMakeWithRatio(float ratio);

extern Progress const ProgressZero;
