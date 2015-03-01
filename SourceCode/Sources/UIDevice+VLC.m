/*****************************************************************************
 * UIDevice+VLC
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2013-2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan.org>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "UIDevice+VLC.h"
#import <sys/sysctl.h> // for sysctlbyname

@implementation UIDevice (VLC)

- (int)speedCategory
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);

    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);

    NSString *currentMachine = @(answer);
    free(answer);

    if ([currentMachine hasPrefix:@"iPhone2"] || [currentMachine hasPrefix:@"iPhone3"] || [currentMachine hasPrefix:@"iPad1"] || [currentMachine hasPrefix:@"iPod3"] || [currentMachine hasPrefix:@"iPod4"]) {
        // iPhone 3GS, iPhone 4, first gen. iPad, 3rd and 4th generation iPod touch
        APLog(@"this is a cat one device");
        return 1;
    } else if ([currentMachine hasPrefix:@"iPhone4"] || [currentMachine hasPrefix:@"iPad3,1"] || [currentMachine hasPrefix:@"iPad3,2"] || [currentMachine hasPrefix:@"iPad3,3"] || [currentMachine hasPrefix:@"iPod4"] || [currentMachine hasPrefix:@"iPad2"] || [currentMachine hasPrefix:@"iPod5"]) {
        // iPhone 4S, iPad 2 and 3, iPod 4 and 5
        APLog(@"this is a cat two device");
        return 2;
    } else if ([currentMachine hasPrefix:@"iPhone5"] || [currentMachine hasPrefix:@"iPhone6"] || [currentMachine hasPrefix:@"iPad4"]) {
        // iPhone 5 + 5S, iPad 4, iPad Air, iPad mini 2G
        APLog(@"this is a cat three device");
        return 3;
    } else {
        // iPhone 6, 2014 iPads
        APLog(@"this is a cat four device");
        return 4;
    }
}

- (NSNumber *)freeDiskspace
{
    NSNumber *totalSpace;
    NSNumber *totalFreeSpace;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

    if (!error) {
        totalSpace = [dictionary objectForKey:NSFileSystemSize];
        totalFreeSpace = [dictionary objectForKey:NSFileSystemFreeSize];
        NSString *totalSize = [NSByteCountFormatter stringFromByteCount:[totalSpace longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
        NSString *totalFreeSize = [NSByteCountFormatter stringFromByteCount:[totalFreeSpace longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
        APLog(@"Memory Capacity of %@ with %@ Free memory available.", totalSize, totalFreeSize);
    } else
        APLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %li", [error domain], [error code]);

    return totalFreeSpace;
}

@end
