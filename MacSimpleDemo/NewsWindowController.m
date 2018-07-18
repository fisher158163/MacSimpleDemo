//
//  NewsWindowController.m
//  WindowTest
//
//  Created by liyu on 2018/1/24.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "NewsWindowController.h"
#import "ThirdWindowController.h"
#import "AppDelegate.h"

@interface NewsWindowController ()<NSComboBoxDataSource, NSComboBoxDelegate>
@property (weak) IBOutlet NSView *bgView;
@property (weak) IBOutlet NSImageView *wallpaperImageView;
@property (strong) NSArray *datas;
@property (strong) ThirdWindowController *thirdWindowVC;
@end

@implementation NewsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window center];
    _bgView.layer.backgroundColor = CGColorCreateGenericRGB(0.55, 0.78, 0.86, 1.0);
    [self.window setTitle:@"NewsWindowController"];
    [self addComboBox];
}

// 返回
- (IBAction)back:(NSButton *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [self.window close];
    [[appDelegate.mainWindow window] makeKeyAndOrderFront:nil];
}

// 下一页
- (IBAction)nextPage:(NSButton *)sender {
    _thirdWindowVC = [[ThirdWindowController alloc] initWithWindowNibName:@"ThirdWindowController"];
    [_thirdWindowVC.window orderFront:nil];
    [self.window orderOut:nil];
    // [self openUrlBySafari];
}

// 获取桌面背景图片信息
- (IBAction)showWallPaper:(NSButton *)sender {
    NSURL *url = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:[NSScreen mainScreen]];
    NSImage *img = [[NSImage alloc] initWithContentsOfURL:url];
    NSLog(@"url：%@",url);
    self.wallpaperImageView.image = img;
    NSDictionary *dic = [[NSWorkspace sharedWorkspace] desktopImageOptionsForScreen:[NSScreen mainScreen]];
    NSLog(@"当前桌面背景图信息：%@", dic);
}

// 设置桌面背景图片(设置不成功)
- (IBAction)setDesktopImage:(NSButton *)sender {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"coderWallpaper" ofType:@"png"];
    NSURL *imageURL = [NSURL fileURLWithPath:imagePath isDirectory:NO];
    // NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"coderWallpaper" withExtension:@"png"];
    NSError *error;
    [[NSWorkspace sharedWorkspace] setDesktopImageURL:imageURL forScreen:[NSScreen mainScreen] options:nil error:&error];
    if (error) {
        NSLog(@"设置背景图失败：%@", error);
    }
}

- (void)addComboBox{
    NSComboBox *box = [[NSComboBox alloc]init];
    // 下面两者只对 box 内容有效
    box.frame = NSMakeRect(50, 100, 100, 30);
    box.backgroundColor = [NSColor whiteColor];
    box.numberOfVisibleItems = 4; // 下拉可视2行，其他选项可滑动查看
    // 初始化数据
    self.datas = @[
                   @"羊肉泡馍",
                   @"油泼扯面",
                   @"板栗烧鸡",
                   @"豆腐花",
                   ];
    [self.window.contentView addSubview:box];
    box.usesDataSource = YES;
    box.delegate = self;
    box.dataSource = self;
}

#pragma mark - NSComboBoxDataSource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return [self.datas count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return self.datas[index];
}


#pragma mark - NSComboBoxDelegate
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    NSComboBox *comboBox = notification.object;
    NSInteger selectedIndex = comboBox.indexOfSelectedItem;
    NSLog(@"comboBoxSelectionDidChange selected item %@",self.datas[selectedIndex]);
}

- (void)comboBoxSelectionIsChanging:(NSNotification *)notification {
    NSComboBox *comboBox = notification.object;
    NSInteger selectedIndex = comboBox.indexOfSelectedItem;
    NSLog(@"comboBoxSelectionIsChanging selected item %@",self.datas[selectedIndex]);
}

- (void)controlTextDidChange:(NSNotification*)notification {
    id object = [notification object];
    NSLog(@"notification : %@",notification);
}

#pragma mark - 使用safari打开网页
- (void)openUrlBySafari {
    NSURL *url = [NSURL URLWithString:@"http://blog.csdn.net/lovechris00?viewmode=contents"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

@end
