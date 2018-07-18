//
//  MainWindowController.m
//  WindowTest
//
//  Created by liyu on 2018/1/24.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "MainWindowController.h"
#import "NewsWindowController.h"

@interface MainWindowController ()

@property (strong) NewsWindowController *newsWindow;

@property (weak) IBOutlet NSView *bgView;
@property (weak) IBOutlet NSButton *button;
@property (weak) IBOutlet NSImageView *imageView1;
@property (weak) IBOutlet NSImageView *imageView2;

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    _bgView.wantsLayer = YES;
    _bgView.layer.backgroundColor = [NSColor cyanColor].CGColor;
    //_bgView.layer.backgroundColor = CGColorCreateGenericRGB(0.12, 0.44, 0.86, 1.0);
    NSImage *image = [NSImage imageNamed:@"bg"];
    [[self.window standardWindowButton:NSWindowDocumentIconButton] setImage:image];
    [self.window setTitle:@"MainWindowController"];
    // 注册窗体大小变化时的事件处理的通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self.window selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:self];
    [self setupImageView];
}

- (IBAction)showNewsWindow:(NSButton *)sender {
     _newsWindow = [[NewsWindowController alloc] initWithWindowNibName:@"NewsWindowController"];
    [_newsWindow.window orderFront:nil];
    [self.window orderOut:nil];
}


- (void)windowDidResize:(NSNotification *)notification {
    // 调整Window上View的frame
    self.button.frame = NSMakeRect(500, 500, 100, 50);
}

// 根据需要调整View上面的别的控件和视图的frame
- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize {

}


- (void)setupImageView {
    self.imageView1.imageFrameStyle = NSImageFramePhoto; //图片边框的样式
    self.imageView1.wantsLayer = YES;
    self.imageView1.layer.backgroundColor = [NSColor cyanColor].CGColor;
    self.imageView1.image = [NSImage imageNamed:@"dog"];
    self.imageView1.imageScaling = NSImageScaleAxesIndependently;
    [self.imageView1 setAnimates:YES];
    self.imageView1.imageAlignment = NSImageAlignTopRight; //图片内容对于控件的位置
    [self.imageView1 setEditable:YES]; //用户能否直接将图片拖到一个NSImageView类里
    [self.imageView1 setAllowsCutCopyPaste:YES]; //表示用户能否对图片内容进行剪切、复制、粘贴行操作
    self.imageView1.wantsLayer = YES;
    self.imageView1.layer.cornerRadius = 60;
    
    self.imageView2.imageFrameStyle = NSImageFramePhoto; //图片边框的样式
    self.imageView2.wantsLayer = YES;
    self.imageView2.layer.backgroundColor = [NSColor cyanColor].CGColor;
    self.imageView2.image = [NSImage imageNamed:@"dog"];
    self.imageView2.imageScaling = NSImageScaleAxesIndependently;
    [self.imageView2 setAnimates:YES];
    self.imageView2.imageAlignment = NSImageAlignTopRight; //图片内容对于控件的位置
    [self.imageView2 setEditable:YES]; //用户能否直接将图片拖到一个NSImageView类里
    [self.imageView2 setAllowsCutCopyPaste:YES]; //表示用户能否对图片内容进行剪切、复制、粘贴行操作
    self.imageView2.wantsLayer = YES;
    self.imageView2.layer.cornerRadius = 60;
}


@end
