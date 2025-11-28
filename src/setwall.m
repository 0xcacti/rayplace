#import <AppKit/AppKit.h>

static NSString *ResolvePath(const char *cpath) {
    NSString *path = [NSString stringWithUTF8String:cpath];
    if (path == nil || [path length] == 0) return nil;
    if ([path isAbsolutePath]) return path;
    NSString *cwd = [[NSFileManager defaultManager] currentDirectoryPath];
    return [cwd stringByAppendingPathComponent:path];
}

void set_wallpaper(const char *cpath) {
    @autoreleasepool {
        NSString *fullPath = ResolvePath(cpath);
        if (fullPath == nil) return;

        NSURL *url = [NSURL fileURLWithPath:fullPath];
        NSScreen *screen = [NSScreen mainScreen];
        NSDictionary *opts = @{};
        NSError *error = nil;

        BOOL ok = [[NSWorkspace sharedWorkspace]
                   setDesktopImageURL:url
                   forScreen:screen
                   options:opts
                   error:&error];

        if (!ok && error != nil) {
            fprintf(stderr, "%s\n", [[error localizedDescription] UTF8String]);
        }
    }
}

