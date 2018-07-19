//
//  AppDelegate.m
//  WindowTest
//
//  Created by liyu on 2018/1/24.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "AppDelegate.h"
#import "PopoerViewController.h"
#import "CustomStatusBarView.h"
#import <Cocoa/Cocoa.h>

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (strong) NSMenu *dockMenu;
@property (strong) NSStatusItem *statusItem;
@property(nonatomic,strong) NSPopover *popover;
@property(nonatomic,strong) PopoerViewController *popoerVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _mainWindow = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    [_mainWindow.window center];
    [_mainWindow.window makeKeyAndOrderFront:nil];
    [self addDockMenu];
    [self addDefaultStatusBar];
    //[self addCustomStatusBar];
    [NSApp setApplicationIconImage:[NSImage imageNamed:@"dog"]];
    [self setAppDockTile];
}

// 添加Dock栏菜单
- (void)addDockMenu {
    self.dockMenu = [[NSMenu alloc] initWithTitle:@"DockMenu"];
    [self.dockMenu setAutoenablesItems:NO];
    NSMenuItem *oneItem = [[NSMenuItem alloc] initWithTitle:@"新的Dock目录" action:@selector(load1) keyEquivalent:@"P"];
    [oneItem setTarget: self];
    [self.dockMenu addItem:oneItem];
}

- (NSMenu *)applicationDockMenu:(NSApplication *)sender {
    return self.dockMenu;
}

// 添加默认状态栏菜单
- (void)addDefaultStatusBar {
    // 获取系统单例NSStatusBar对象
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    NSStatusItem *statusItem = [statusBar statusItemWithLength: NSSquareStatusItemLength];
    self.statusItem = statusItem;
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"header"]]; // 设置图标，请注意尺寸
    [statusItem setToolTip:@"这是一个ToolTip，这是一个ToolTip，这是一个ToolTip！"];
    [statusItem setAction:@selector(statusOnClick:)];
    [statusItem.button setAction:@selector(statusButtonOnClick:)];
    // statusItem 和 statusItem.button 都绑定 action，那调用哪一个呢？
    // 最先绑定的那个，被后面那个覆盖。
}

// 添加自定义状态栏菜单
- (void)addCustomStatusBar {
    //获取系统单例NSStatusBar对象
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    //设置动态宽度的NSStatusItem对象
    NSStatusItem *item = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    //设置自定义的view
    NSView *customerView = [CustomStatusBarView loadWithNibNamed:@"CustomStatusBarView" owner:self loadClass:NSStringFromClass([CustomStatusBarView class])];
    [item setView: customerView];
    //保存到属性变量
    self.statusItem = item;
    NSLog(@"%@",NSStringFromRect(item.view.bounds));
}

- (void)statusOnClick:(NSStatusItem *)item{
    NSLog(@"-----statusOnClick ----- ");
}

- (void)statusButtonOnClick:(NSButton *)button{
    NSLog(@"-----status.ButtonOnClick ----- ");
    [self.popover showRelativeToRect:[button bounds] ofView:button preferredEdge:NSRectEdgeMaxY];
}

// 懒加载
- (NSPopover *)popover {
    if(!_popover) {
        _popover = [[NSPopover alloc] init];
        _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
        _popover.contentViewController = self.popoerVC;
        _popover.behavior = NSPopoverBehaviorTransient;
    }
    return _popover;
}

- (PopoerViewController *)popoerVC {
    if(!_popoerVC) {
        _popoerVC = [[PopoerViewController alloc] init];
    }
    return _popoerVC;
}

- (void)setAppDockTile {
    NSDockTile *dock = [NSApp dockTile];
    if (dock) {
        [dock setBadgeLabel:@"2"];
        [dock setShowsApplicationBadge:YES];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {

}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES; // YES - 窗口程序两者都关闭，NO-只关闭窗口；
}

@end
