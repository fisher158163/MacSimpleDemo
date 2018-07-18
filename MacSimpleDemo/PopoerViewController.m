//
//  PopoerViewController.m
//  WindowTest
//
//  Created by liyu on 2018/7/16.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "PopoerViewController.h"
#import <Quartz/Quartz.h>

@interface PopoerViewController ()<NSUserNotificationCenterDelegate>
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSImageView *pictureImageView;
@property (weak) IBOutlet NSTextField *label;
@property (nonatomic,strong) NSFont *font;

@end

@implementation PopoerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [NSColor orangeColor].CGColor;
    [self setupImageView];
}
- (void)setupImageView {
    self.imageView.imageFrameStyle = NSImageFramePhoto; // 图片边框的样式
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = [NSColor cyanColor].CGColor;
    self.imageView.image = [NSImage imageNamed:@"dog"];
    self.imageView.imageScaling = NSImageScaleAxesIndependently;
    [self.imageView setAnimates:YES];
    self.imageView.imageAlignment = NSImageAlignTopRight; // 图片内容对于控件的位置
    [self.imageView setEditable:YES]; // 用户能否直接将图片拖到一个NSImageView类里
    [self.imageView setAllowsCutCopyPaste:YES]; // 表示用户能否对图片内容进行剪切、复制、粘贴行操作
    self.imageView.wantsLayer = YES;
    self.imageView.layer.cornerRadius = 75;
}

// 获取照片
- (IBAction)takePicture:(NSButton *)sender {
    [[IKPictureTaker pictureTaker] beginPictureTakerWithDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)pictureTakerDidEnd:(IKPictureTaker *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    NSImage *image = [sheet outputImage];
    if(image !=nil && (returnCode == NSModalResponseOK) ) {
        self.pictureImageView.image = image;
    }
}

// 打开字体选择面板
- (IBAction)selectFont:(NSButton *)sender {
    [self openFontPanel];
}

- (void)openFontPanel {
    // 初始化
    self.font = [NSFont systemFontOfSize:14];
    // 不需要使用代理 NSFontManagerDelegate，代理也没有方法
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setSelectedFont:[NSFont systemFontOfSize:24] isMultiple:NO];
    [fontManager setTarget:self];
    [fontManager setAction:@selector(changeFont:)];
    [fontManager orderFrontFontPanel:self];
}

- (void)changeFont:(id)sender {
    self.font = [sender convertFont:self.font];
    self.label.font = self.font;
    NSLog(@"pointSize：%f ，fontName : %@ , familyName : %@",self.font.pointSize,self.font.fontName,self.font.familyName);
}

// 打开颜色选择面板
- (IBAction)selectColor:(NSButton *)sender {
    [self openColorPanel];
}

- (void)openColorPanel {
    NSColorPanel *colorpanel = [NSColorPanel sharedColorPanel];
    colorpanel.mode = NSColorPanelModeWheel; //调出时，默认色盘
    [colorpanel setAction:@selector(changeColor:)];
    [colorpanel setTarget:self];
    [colorpanel orderFront:nil];
}

//颜色选择action事件
- (void)changeColor:(id)sender {
    NSColorPanel *colorPanel = sender ;
    NSColor *color = colorPanel.color;
    self.label.textColor = color;
}

// 发送通知
- (IBAction)sendNotification:(NSButton *)sender {
   // [self sendDefaultNotice];
      [self sendHasButtonNotice];
}

// 一般通知
- (void)sendDefaultNotice {
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"这是测试title"; // 标题
    localNotify.subtitle = @"这是测试的subtitle"; // 副标题
    NSImage *image = [NSImage imageNamed:@"Mac"];
    localNotify.contentImage = image; // 显示在弹窗右边的图片
    [localNotify setValue:image forKey:@"_identityImage"]; // 显示在弹窗左边的图片logo
    localNotify.informativeText = @"如果不设置代理，通知可能发送成功并显示在通知栏，但是不会弹出。打断点的话，会弹出";
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
    // 设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

// 带有按钮的通知
- (void)sendHasButtonNotice {
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"这是测试title"; // 标题
    localNotify.subtitle = @"这是测试的subtitle"; // 副标题
    NSImage *image = [NSImage imageNamed:@"Mac"];
    localNotify.contentImage = image; // 显示在弹窗右边的图片
    [localNotify setValue:image forKey:@"_identityImage"]; // 显示在弹窗左边的图片logo
    localNotify.informativeText = @"http://www.zealer.com";
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    // 只有当用户设置为提示模式时，才会显示按钮.不设置的话，默认为yes
    localNotify.hasActionButton = YES;
    localNotify.actionButtonTitle = @"确定";
    localNotify.otherButtonTitle = @"取消";
    [localNotify setValue:@YES forKey:@"_showsButtons"]; // 需要显示按钮
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
    // 设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    //    BOOL showAlternateActionMenu = 1; //按钮是否显示目录
    //    if (showAlternateActionMenu) {
    //        [localNotify setValue:@[@"menu1", @"menu2"] forKey:@"_alternateActionButtonTitles"];
    //        [localNotify setValue:@YES forKey:@"_alwaysShowAlternateActionMenu"];
    //    }
    //
    //    //设置回复属性
    //    localNotify.hasReplyButton = YES;
    //    localNotify.responsePlaceholder = @"回复的placeHolder";
    
    //    // 设置通知提交的时间
    //    localNotify.deliveryDate = [NSDate dateWithTimeIntervalSinceNow:2];//延时2s发送
    //
    //    //设置通知的循环(系统限制必须大于1分钟，可能是为了防止刷屏)
    //    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    //    [dateComponents setSecond:70];
    //    localNotify.deliveryRepeatInterval = dateComponents;
    
    //    [localNotify setValue:@(0) forKey:@"_lockscreenOnly"]; //是否只有锁屏状态下可见
}

//通知已经提交给通知中心
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    NSLog(@"收到通知:%@",notification);
}

//用户已经点击了通知
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    NSLog(@"用户点击");
    NSLog(@"activationType : %ld , actualDeliveryDate : %@",(long)notification.activationType,notification.actualDeliveryDate);
    //如果推送有按钮，点击按钮时，activationType 会变为 2
    if (notification.activationType == 2) {
        [self openUrlBySafariWithUrlString:notification.informativeText];
    }
}

//returen YES; 强制显示(即不管通知是否过多)
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

// 使用safari打开网页
- (void)openUrlBySafariWithUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSWorkspace sharedWorkspace] openURL: url];
}

- (void)dealloc {
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
}


@end
