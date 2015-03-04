#import "URBNFunctions.h"
#import "URBNMacros.h"
#import <mach/mach_time.h>
#include <sys/xattr.h>
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

BOOL attachedToDebugger(void) {
    // Returns true if the current process is being debugged (either
    // running under the debugger or has a debugger attached post facto).
	int junk;
	int mib[4];
	struct kinfo_proc info;
	size_t size;

	// Initialize the flags so that, if sysctl fails for some bizarre
	// reason, we get a predictable result.
	info.kp_proc.p_flag = 0;

	// Initialize mib, which tells sysctl the info we want, in this case
	// we're looking for information about a specific process ID.
	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();

	// Call sysctl.
	size = sizeof(info);
	junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
	assert(junk == 0);

	// We're being debugged if the P_TRACED flag is set.
	return ((info.kp_proc.p_flag & P_TRACED) != 0);
}

BOOL rangesAreContiguous(NSRange first, NSRange second) {
	NSIndexSet *firstIndexes = [NSIndexSet indexSetWithIndexesInRange:first];
	NSIndexSet *secondIndexes = [NSIndexSet indexSetWithIndexesInRange:second];

	NSUInteger endOfFirstRange = [firstIndexes lastIndex];
	NSUInteger beginingOfSecondRange = [secondIndexes firstIndex];

    if (beginingOfSecondRange - endOfFirstRange == 1) {
        return YES;
    }

	return NO;
}

NSRange rangeWithFirstAndLastIndexes(NSUInteger first, NSUInteger last) {
    if (last < first || (first == NSNotFound || last == NSNotFound)) {
        return NSMakeRange(0, 0);
    }

	NSUInteger length = last - first + 1;
	NSRange r = NSMakeRange(first, length);
	return r;
}

float nanosecondsWithSeconds(float seconds) {
	return (seconds * 1000000000);
}

dispatch_time_t dispatchTimeFromNow(float seconds) {
	return dispatch_time(DISPATCH_TIME_NOW, nanosecondsWithSeconds(seconds));
}

BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL) {
#ifdef DEBUG
	assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
#endif

    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

NSUInteger sizeOfFolderContentsInBytes(NSString *folderPath) {
	NSError *error = nil;
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];

	if (error != nil) {
		return NSNotFound;
	}

	double bytes = 0.0;
	for (NSString *eachFile in contents) {
		NSDictionary *meta = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:eachFile] error:&error];

		if (error != nil) {
			break;
		}

		NSNumber *fileSize = [meta objectForKey:NSFileSize];
		bytes += [fileSize unsignedIntegerValue];
	}

	if (error != nil) {
		return NSNotFound;
	}

	return bytes;
}

double bytesWithMegaBytes(long long megaBytes) {
	NSNumber *mb = [NSNumber numberWithLongLong:megaBytes];
	double mbAsDouble = [mb doubleValue];
	double b = mbAsDouble * 1048576.0;

	return b;
}

double megaBytesWithBytes(long long bytes) {
	NSNumber *b = [NSNumber numberWithLongLong:bytes];
	double bytesAsDouble = [b doubleValue];
	double mb = bytesAsDouble / 1048576.0;

	return mb;
}

double gigaBytesWithBytes(long long bytes) {
	NSNumber *b = [NSNumber numberWithLongLong:bytes];
	double bytesAsDouble = [b doubleValue];
	double gb = bytesAsDouble / 1073741824.0;

	return gb;
}

NSString *prettySizeStringWithBytesRounded(long long bytes) {
	NSString *size = nil;

	if (bytes <= 524288000) { // smaller than 500 MB
		double mb = megaBytesWithBytes(bytes);
		mb = round(mb);
		size = [NSString stringWithFormat:@"%.f MB", mb];
	}
	else {
		double gb = gigaBytesWithBytes(bytes);
		gb = round(gb / 0.1) * 0.1;
		size = [NSString stringWithFormat:@"%.1f GB", gb];
	}

    return size;
}

NSString *prettySizeStringWithBytesFloored(long long bytes) {
	NSString *size = nil;

	if (bytes <= 524288000) { // smaller than 500 MB
		double mb = megaBytesWithBytes(bytes);
		mb = floor(mb);
		size = [NSString stringWithFormat:@"%.f MB", mb];
	}
	else {
		double gb = gigaBytesWithBytes(bytes);
		gb = floor(gb / 0.1) * 0.1;
		size = [NSString stringWithFormat:@"%.1f GB", gb];
	}

    return size;
}

void dispatchOnMainQueue(dispatch_block_t block) {
    if (!block) {
        return;
    }

	dispatch_async(dispatch_get_main_queue(), block);
}

void dispatchOnBackgroundQueue(dispatch_block_t block) {
    if (!block) {
        return;
    }

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block) {
	dispatchAfterDelayInSeconds(delay, dispatch_get_main_queue(), block);
}

void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block) {
    if (!block) {
        return;
    }

	dispatch_after(dispatchTimeFromNow(delay), queue, block);
}

Progress ProgressMake(unsigned long long complete, unsigned long long total) {
    if (total == 0) {
        return ProgressZero;
    }

	Progress p;
	p.total = total;
	p.complete = complete;

	NSNumber *t = [NSNumber numberWithLongLong:total];
	NSNumber *c = [NSNumber numberWithLongLong:complete];
	double r = [c doubleValue] / [t doubleValue];

	p.ratio = r;

	return p;
}

Progress ProgressMakeWithRatio(float ratio) {
	Progress p;
	p.total = ratio;
	p.complete = 1.0;
	p.ratio = ratio;

	return p;
}

Progress const ProgressZero = {
	0,
	0,
	0.0
};
