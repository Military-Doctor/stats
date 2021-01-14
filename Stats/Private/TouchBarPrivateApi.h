#import <AppKit/AppKit.h>

extern void DFRElementSetControlStripPresenceForIdentifier(NSTouchBarItemIdentifier, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);


@interface NSTouchBarItem (PrivateMethods)
+ (void)addSystemTrayItem:(nullable NSTouchBarItem *)item;
+ (void)removeSystemTrayItem:(nullable NSTouchBarItem *)item;
@end


@interface NSTouchBar (PrivateMethods)

// macOS 10.14
+ (void)presentSystemModalTouchBar:(nullable NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;
+ (void)presentSystemModalTouchBar:(nullable NSTouchBar *)touchBar systemTrayItemIdentifier:(nullable NSTouchBarItemIdentifier)identifier;
+ (void)dismissSystemModalTouchBar:(nullable NSTouchBar *)touchBar;
+ (void)minimizeSystemModalTouchBar:(nullable NSTouchBar *)touchBar;

// macOS 10.13
+ (void)presentSystemModalFunctionBar:(nullable NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;
+ (void)presentSystemModalFunctionBar:(nullable NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;
+ (void)dismissSystemModalFunctionBar:(nullable NSTouchBar *)touchBar;
+ (void)minimizeSystemModalFunctionBar:(nullable NSTouchBar *)touchBar;

@end

