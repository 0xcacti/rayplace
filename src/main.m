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

    CGEventFlags flags = CGEventGetFlags(event);
    int ctrlDown = (flags & kCGEventFlagMaskControl) == kCGEventFlagMaskControl;
    CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);

    if (ctrlDown && keycode == (CGKeyCode)13 && isPicking == 0) {
        isPicking = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            run_picker("resources");
            isPicking = 0;
        });
    }

    return event;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];

        eventTap = CGEventTapCreate(kCGSessionEventTap,
                                    kCGHeadInsertEventTap,
                                    kCGEventTapOptionListenOnly,
                                    CGEventMaskBit(kCGEventKeyDown),
                                    EventCallback,
                                    NULL);

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

