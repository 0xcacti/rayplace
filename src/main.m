#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>

void run_picker(const char *resourcePath);

static CFMachPortRef eventTap = NULL;
static CFRunLoopSourceRef runLoopSource = NULL;
static int isPicking = 0;

static CGEventRef EventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (type == kCGEventTapDisabledByTimeout || type == kCGEventTapDisabledByUserInput) {
        CGEventTapEnable(eventTap, true);
        return event;
    }

    if (type != kCGEventKeyDown) return event;

    NSEvent *nsEvent = [NSEvent eventWithCGEvent:event];
    if (nsEvent == nil) return event;

    NSString *chars = [nsEvent charactersIgnoringModifiers];
    if (chars.length == 0) return event;

    unichar ch = [chars characterAtIndex:0];
    NSEventModifierFlags flags = [nsEvent modifierFlags];
    int ctrlDown = (flags & NSEventModifierFlagControl) == NSEventModifierFlagControl;

    if (ctrlDown && (ch == 'w' || ch == 'W') && isPicking == 0) {
        isPicking = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            run_picker("resources");
            isPicking = 0;
        });
        return NULL; // swallow Ctrl+W → no bell, front app never sees it
    }

    return event;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];

        eventTap = CGEventTapCreate(
            kCGSessionEventTap,
            kCGHeadInsertEventTap,
            kCGEventTapOptionDefault,              // not ListenOnly → we can swallow events
            CGEventMaskBit(kCGEventKeyDown),
            EventCallback,
            NULL
        );

        if (eventTap == NULL) {
            fprintf(stderr, "event tap creation failed\n");
            return 1;
        }

        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        CGEventTapEnable(eventTap, true);

        [NSApp run];

        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        CFRelease(runLoopSource);
        CFMachPortInvalidate(eventTap);
        CFRelease(eventTap);
    }

    return 0;
}

